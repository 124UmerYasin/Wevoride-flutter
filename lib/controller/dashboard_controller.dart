import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wevoride/app/chat/inbox_screen.dart';
import 'package:wevoride/app/home_screen/home_screen.dart';
import 'package:wevoride/app/myride/myride_screen.dart';
import 'package:wevoride/app/on_boarding_screen/get_started_screen.dart';
import 'package:wevoride/app/profile_screen/profile_screen.dart';
import 'package:wevoride/app/payment/force_payment_screen.dart';
import 'package:wevoride/app/wallet_screen/wallet_screen.dart';
import 'package:wevoride/constant/collection_name.dart';
import 'package:wevoride/constant/constant.dart';
import 'package:wevoride/model/booking_model.dart';
import 'package:wevoride/model/user_model.dart';
import 'package:wevoride/utils/fire_store_utils.dart';
import 'package:wevoride/utils/notification_service.dart';

class DashboardScreenController extends GetxController {
  /// Initialize the controller as a permanent singleton
  /// This ensures the booking status listener works on all screens
  static void initialize() {
    if (!Get.isRegistered<DashboardScreenController>()) {
      Get.put(DashboardScreenController(), permanent: true);
      print("Dashboard controller initialized as permanent singleton");
    }
  }

  RxInt selectedIndex = 0.obs;

  RxList pageList = [
    const HomeScreen(),
    const MyRideScreen(),
    const WalletScreen(),
    const InboxScreen(),
    const ProfileScreen(),
  ].obs;

  StreamSubscription? _bookingStatusSubscription;
  Timer? _periodicCheckTimer;
  bool _isPaymentScreenShowing = false;
  String? _currentPaymentBookingId; // Track which booking's payment screen is showing
  final Map<String, Timer> _suppressPaymentTimers = {}; // bookingId -> timer to stop suppression
  final Set<String> _manualSuppressions = {}; // bookingIds suppressed until explicitly cleared

  /// Reset payment screen flag (called when user reports trip or completes payment)
  void resetPaymentScreenFlag() {
    _isPaymentScreenShowing = false;
    _currentPaymentBookingId = null;
  }

  /// Temporarily suppress showing the payment screen for a booking.
  /// Useful when user navigates to a different screen related to this booking
  /// (for example reporting) to avoid immediately re-showing the payment modal.
  void suppressPaymentForBooking(String bookingId, {Duration duration = const Duration(seconds: 10)}) {
    try {
      // Cancel any existing timer for this booking
      _suppressPaymentTimers[bookingId]?.cancel();
      _suppressPaymentTimers[bookingId] = Timer(duration, () {
        _suppressPaymentTimers.remove(bookingId);
        print("Suppression expired for booking: $bookingId");
      });
      print("Suppressing payment screen for booking $bookingId for ${duration.inSeconds}s");
    } catch (e) {
      print("Error while suppressing payment screen: $e");
    }
  }

  /// Suppress payment screen for a booking until explicitly cleared.
  void suppressPaymentUntilCleared(String bookingId) {
    try {
      _manualSuppressions.add(bookingId);
      // Also cancel any existing temporary timer
      _suppressPaymentTimers[bookingId]?.cancel();
      _suppressPaymentTimers.remove(bookingId);
      print("Manual suppression enabled for booking: $bookingId");
    } catch (e) {
      print("Error enabling manual suppression: $e");
    }
  }

  /// Clear any suppression (temporary or manual) for a booking.
  void clearSuppressionForBooking(String bookingId) {
    try {
      _manualSuppressions.remove(bookingId);
      _suppressPaymentTimers[bookingId]?.cancel();
      _suppressPaymentTimers.remove(bookingId);
      print("Suppression cleared for booking: $bookingId");
    } catch (e) {
      print("Error clearing suppression: $e");
    }
  }

  @override
  void onInit() {
    getData();
    setupBookingStatusListener();
    print("Dashboard controller initialized, booking status listener set up");
    super.onInit();
  }

  @override
  void onClose() {
    _bookingStatusSubscription?.cancel();
    _periodicCheckTimer?.cancel();
    super.onClose();
  }

  RxString count = "0".obs;
  Rx<UserModel> senderUserModel = UserModel().obs;

  getData() async {
    String token = await NotificationService.getToken();
    FireStoreUtils.fireStore.collection(CollectionName.users).doc(FireStoreUtils.getCurrentUid()).snapshots().listen(
      (event) async {
        if (event.exists) {
          senderUserModel.value = UserModel.fromJson(event.data()!);
          if (senderUserModel.value.isActive == false) {
            await FirebaseAuth.instance.signOut();
            Get.offAll(const GetStartedScreen());
          }
          senderUserModel.value.fcmToken = token;
          await FireStoreUtils.updateUser(senderUserModel.value);
        }
      },
    );


    FireStoreUtils.fireStore
        .collection(CollectionName.chat)
        .doc(senderUserModel.value.id)
        .collection("inbox")
        .where("seen", isEqualTo: false)
        .orderBy("timestamp", descending: true)
        .snapshots()
        .listen(
      (event) {
        print("======>");
        print(event.docs.length);
        count.value = event.docs.length.toString();
      },
    );

    // Check for unpaid trips on app start
    checkUnpaidTrips();
  }

  /// Setup listener to monitor booking status changes in real-time
  void setupBookingStatusListener() {
    String currentUserId = FireStoreUtils.getCurrentUid();
    if (currentUserId.isEmpty) {
      print("Cannot setup booking listener: User ID is empty");
      return;
    }

    print("Setting up booking status listener for user: $currentUserId");

    // Listen to all bookings where user is a passenger
    _bookingStatusSubscription = FireStoreUtils.fireStore
        .collection(CollectionName.booking)
        .where("bookedUserId", arrayContains: currentUserId)
        .snapshots()
        .listen(
      (snapshot) async {
        print("Booking status listener triggered, changes: ${snapshot.docChanges.length}");
        for (var doc in snapshot.docChanges) {
          if (doc.type == DocumentChangeType.modified || doc.type == DocumentChangeType.added) {
            try {
              BookingModel bookingModel = BookingModel.fromJson(doc.doc.data() as Map<String, dynamic>);
              
              print("Booking ${bookingModel.id} status: ${bookingModel.status}");
              
              // Check if trip is completed and payment is required
              if (bookingModel.status == Constant.completed) {
                print("Trip completed, checking payment status...");
                // If this booking is temporarily or manually suppressed (e.g., user navigated to report), skip
                if (bookingModel.id != null && (_suppressPaymentTimers.containsKey(bookingModel.id) || _manualSuppressions.contains(bookingModel.id))) {
                  print("Payment screen suppressed for booking: ${bookingModel.id}");
                  continue;
                }
                
                // Don't show payment screen for the same booking twice
                if (_currentPaymentBookingId == bookingModel.id) {
                  print("Payment screen already showing for this booking: ${bookingModel.id}");
                  return;
                }
                
                // Get the booked user data
                var bookedUserDoc = await FireStoreUtils.fireStore
                    .collection(CollectionName.booking)
                    .doc(bookingModel.id)
                    .collection("bookedUser")
                    .doc(currentUserId)
                    .get();

                if (bookedUserDoc.exists) {
                  var bookedUserData = bookedUserDoc.data() as Map<String, dynamic>;
                  bool paymentStatus = bookedUserData['paymentStatus'] ?? false;
                  
                  // If payment is not completed, show payment screen
                  if (paymentStatus == false && !_isPaymentScreenShowing) {
                    _isPaymentScreenShowing = true;
                    _currentPaymentBookingId = bookingModel.id; // Track this booking
                    BookedUserModel bookedUserModel = BookedUserModel.fromJson(bookedUserData);
                    
                    print("Payment screen should show for booking: ${bookingModel.id}");
                    
                    // Function to attempt navigation
                    Future<bool> attemptNavigation() async {
                      try {
                        // Check if payment screen is already showing to prevent duplicates
                        if (Get.isDialogOpen == true || Get.isBottomSheetOpen == true) {
                          print("Another dialog is already open, waiting...");
                          return false;
                        }
                        
                        // Check if navigator is ready
                        if (Get.key.currentState == null) {
                          print("Navigator is not ready yet");
                          return false;
                        }
                        
                        print("Navigator is ready, attempting navigation...");
                        
                        // Use Get.to() with fullscreenDialog to show as modal
                        // GetX handles context automatically, so we don't need explicit context
                        await Get.to(
                          () => ForcePaymentScreen(
                            bookingModel: bookingModel,
                            bookedUserModel: bookedUserModel,
                          ),
                          fullscreenDialog: true,
                          preventDuplicates: true,
                        );
                        print("Payment screen navigation successful");
                        return true; // Success
                      } catch (e) {
                        print("Error in navigation attempt: $e");
                        return false;
                      }
                    }
                    
                    // Try immediate navigation first (no delay)
                    Future.microtask(() async {
                      if (!_isPaymentScreenShowing) {
                        print("Payment screen flag was reset, skipping navigation");
                        return;
                      }
                      
                      print("Attempting immediate navigation...");
                      bool success = await attemptNavigation();
                      
                      if (success) {
                        return; // Success, exit early
                      }
                      
                      // If immediate navigation failed, try with microtask delay
                      print("Immediate navigation failed, trying with microtask delay...");
                      await Future.delayed(const Duration(milliseconds: 50));
                      
                      if (!_isPaymentScreenShowing) {
                        print("Payment screen flag was reset, skipping navigation");
                        return;
                      }
                      
                      success = await attemptNavigation();
                      
                      if (success) {
                        return; // Success, exit early
                      }
                      
                      // If still failed, use post-frame callback as fallback
                      print("Microtask navigation failed, using post-frame callback...");
                      WidgetsBinding.instance.addPostFrameCallback((_) async {
                        if (!_isPaymentScreenShowing) {
                          print("Payment screen flag was reset, skipping navigation");
                          return;
                        }
                        
                        print("Attempting navigation via post-frame callback...");
                        success = await attemptNavigation();
                        
                        if (success) {
                          return; // Success, exit early
                        }
                        
                        // If still failed, use retry mechanism
                        print("Post-frame navigation failed, using retry mechanism...");
                        int retries = 5;
                        
                        for (int i = 0; i < retries; i++) {
                          if (!_isPaymentScreenShowing) {
                            print("Payment screen flag was reset during retries");
                            return;
                          }
                          
                          // Wait a bit before retrying to allow context to become available
                          if (i > 0) {
                            print("Navigation attempt ${i}/$retries failed, retrying...");
                            await Future.delayed(Duration(milliseconds: 300 * i));
                          }
                          
                          success = await attemptNavigation();
                          if (success) {
                            break; // Success, exit retry loop
                          }
                        }
                        
                        // If all retries failed, reset flag so it can be retried later
                        if (!success) {
                          print("All navigation attempts failed, resetting flag. Will retry on next check.");
                          _isPaymentScreenShowing = false;
                        }
                      });
                    });
                  }
                }
              }
            } catch (e) {
              print("Error in booking status listener: $e");
              _isPaymentScreenShowing = false; // Reset flag on error
            }
          }
        }
      },
      onError: (error) {
        print("Error in booking status listener: $error");
      },
    );
    
    // Also set up a periodic check as backup (every 5 seconds)
    // This ensures we catch status changes even if the listener misses them
    _periodicCheckTimer?.cancel();
    _periodicCheckTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!_isPaymentScreenShowing) {
        print("Periodic check for unpaid trips...");
        checkUnpaidTrips();
      }
    });
  }

  /// Check for unpaid trips and show payment screen if needed
  Future<void> checkUnpaidTrips() async {
    try {
      if (_isPaymentScreenShowing) {
        print("Payment screen already showing, skipping check");
        return; // Don't show if already showing
      }
      
      print("Checking for unpaid trips...");
      var unpaidTrip = await FireStoreUtils.getUnpaidTrip();
      if (unpaidTrip != null) {
        BookingModel bookingModel = unpaidTrip['bookingModel'] as BookingModel;
        BookedUserModel bookedUserModel = unpaidTrip['bookedUserModel'] as BookedUserModel;
        
        print("Found unpaid trip: ${bookingModel.id}, status: ${bookingModel.status}, paymentStatus: ${bookedUserModel.paymentStatus}");
        // If this booking is temporarily or manually suppressed (e.g., user navigated to report), skip
        if (bookingModel.id != null && (_suppressPaymentTimers.containsKey(bookingModel.id) || _manualSuppressions.contains(bookingModel.id))) {
          print("checkUnpaidTrips: payment suppressed for booking: ${bookingModel.id}");
          return;
        }

        // Prevent showing for the same booking twice
        if (bookingModel.id != null && _currentPaymentBookingId == bookingModel.id) {
          print("checkUnpaidTrips: payment already showing for booking: ${bookingModel.id}");
          return;
        }

        _isPaymentScreenShowing = true;
        _currentPaymentBookingId = bookingModel.id;
        
        // Function to attempt navigation
        Future<bool> attemptNavigation() async {
          try {
            // Check if payment screen is already showing to prevent duplicates
            if (Get.isDialogOpen == true || Get.isBottomSheetOpen == true) {
              print("Another dialog is already open, waiting...");
              return false;
            }
            
            // Check if navigator is ready
            if (Get.key.currentState == null) {
              print("Navigator is not ready yet");
              return false;
            }
            
            print("Navigator is ready, attempting navigation...");
            
            // Use Get.to() with fullscreenDialog to show as modal
            // GetX handles context automatically, so we don't need explicit context
            await Get.to(
              () => ForcePaymentScreen(
                bookingModel: bookingModel,
                bookedUserModel: bookedUserModel,
              ),
              fullscreenDialog: true,
              preventDuplicates: true,
            );
            print("Payment screen navigation successful");
            return true; // Success
          } catch (e) {
            print("Error in navigation attempt: $e");
            return false;
          }
        }
        
        // Try immediate navigation first (no delay)
        Future.microtask(() async {
          if (!_isPaymentScreenShowing) {
            print("Payment screen flag was reset, skipping navigation");
            return;
          }
          
          print("Attempting immediate navigation for booking: ${bookingModel.id}");
          bool success = await attemptNavigation();
          
          if (success) {
            return; // Success, exit early
          }
          
          // If immediate navigation failed, try with microtask delay
          print("Immediate navigation failed, trying with microtask delay...");
          await Future.delayed(const Duration(milliseconds: 50));
          
          if (!_isPaymentScreenShowing) {
            print("Payment screen flag was reset, skipping navigation");
            return;
          }
          
          success = await attemptNavigation();
          
          if (success) {
            return; // Success, exit early
          }
          
          // If still failed, use post-frame callback as fallback
          print("Microtask navigation failed, using post-frame callback...");
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            if (!_isPaymentScreenShowing) {
              print("Payment screen flag was reset, skipping navigation");
              return;
            }
            
            print("Attempting navigation via post-frame callback...");
            success = await attemptNavigation();
            
            if (success) {
              return; // Success, exit early
            }
            
            // If still failed, use retry mechanism
            print("Post-frame navigation failed, using retry mechanism...");
            int retries = 5;
            
            for (int i = 0; i < retries; i++) {
              if (!_isPaymentScreenShowing) {
                print("Payment screen flag was reset during retries");
                return;
              }
              
              // Wait a bit before retrying to allow context to become available
              if (i > 0) {
                print("Navigation attempt ${i}/$retries failed, retrying...");
                await Future.delayed(Duration(milliseconds: 300 * i));
              }
              
              success = await attemptNavigation();
              if (success) {
                break; // Success, exit retry loop
              }
            }
            
            // If all retries failed, reset flag so it can be retried later
            if (!success) {
              print("All navigation attempts failed, resetting flag. Will retry on next check.");
              _isPaymentScreenShowing = false;
            }
          });
        });
      } else {
        print("No unpaid trips found");
      }
    } catch (e) {
      print("Error checking unpaid trips: $e");
      _isPaymentScreenShowing = false;
    }
  }
}
