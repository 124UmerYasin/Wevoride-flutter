import 'dart:async';
import 'dart:developer';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wevoride/constant/collection_name.dart';
import 'package:wevoride/constant/constant.dart';
import 'package:wevoride/constant/show_toast_dialog.dart';
import 'package:wevoride/model/admin_commission.dart';
import 'package:wevoride/model/booking_model.dart';
import 'package:wevoride/model/conversation_admin_model.dart';
import 'package:wevoride/model/currency_model.dart';
import 'package:wevoride/model/document_model.dart';
import 'package:wevoride/model/inbox_admin_model.dart';
import 'package:wevoride/model/language_model.dart';
import 'package:wevoride/model/notification_model.dart';
import 'package:wevoride/model/on_boarding_model.dart';
import 'package:wevoride/model/payment_method_model.dart';
import 'package:wevoride/model/recent_search_model.dart';
import 'package:wevoride/model/referral_model.dart';
import 'package:wevoride/model/report_model.dart';
import 'package:wevoride/model/review_model.dart';
import 'package:wevoride/model/sos_model.dart';
import 'package:wevoride/model/tax_model.dart';
import 'package:wevoride/model/user_model.dart';
import 'package:wevoride/model/user_verification_model.dart';
import 'package:wevoride/model/vehicle_brand_model.dart';
import 'package:wevoride/model/vehicle_information_model.dart';
import 'package:wevoride/model/vehicle_model.dart';
import 'package:wevoride/model/vehicle_type_model.dart';
import 'package:wevoride/model/wallet_transaction_model.dart';
import 'package:wevoride/model/withdraw_method_model.dart';
import 'package:wevoride/model/withdraw_model.dart';
import 'package:wevoride/themes/app_them_data.dart';
import 'package:wevoride/utils/preferences.dart';

class FireStoreUtils {
  static FirebaseFirestore fireStore = FirebaseFirestore.instance;

  static String getCurrentUid() {
    if (FirebaseAuth.instance.currentUser != null) {
      return FirebaseAuth.instance.currentUser!.uid;
    } else {
      // Fallback to SharedPreferences if Firebase Auth is null
      String savedUid = Preferences.getString(Preferences.userUidKey);
      if (savedUid.isNotEmpty) {
        return savedUid;
      } else {
        throw Exception("No authenticated user found");
      }
    }
  }

  static Future<bool> isLogin() async {
    bool isLogin = false;
    try {
      // Check if Firebase Auth has a current user
      if (FirebaseAuth.instance.currentUser != null) {
        // Verify the user exists in Firestore
        isLogin = await userExistOrNot(FirebaseAuth.instance.currentUser!.uid);
        
        // Also check SharedPreferences for additional persistence
        if (isLogin) {
          await Preferences.setBoolean(Preferences.isUserLoggedInKey, true);
          await Preferences.setString(Preferences.userUidKey, FirebaseAuth.instance.currentUser!.uid);
        }
      } else {
        // Check SharedPreferences as fallback
        bool isLoggedInPref = Preferences.getBoolean(Preferences.isUserLoggedInKey);
        if (isLoggedInPref) {
          String savedUid = Preferences.getString(Preferences.userUidKey);
          if (savedUid.isNotEmpty) {
            // Try to verify if user still exists
            isLogin = await userExistOrNot(savedUid);
            if (!isLogin) {
              // Clear invalid session data
              await Preferences.setBoolean(Preferences.isUserLoggedInKey, false);
              await Preferences.setString(Preferences.userUidKey, "");
            }
          }
        }
      }
    } catch (e) {
      log("Error checking login status: $e");
      isLogin = false;
    }
    return isLogin;
  }

  static Future<bool> userExistOrNot(String uid) async {
    bool isExist = false;

    await fireStore.collection(CollectionName.users).doc(uid).get().then(
      (value) {
        if (value.exists) {
          isExist = true;
        } else {
          isExist = false;
        }
      },
    ).catchError((error) {
      log("Failed to check user exist: $error");
      isExist = false;
    });
    return isExist;
  }

  static Future<List<OnBoardingModel>> getOnBoardingList() async {
    List<OnBoardingModel> onBoardingModel = [];
    await fireStore.collection(CollectionName.onBoarding).get().then((value) {
      for (var element in value.docs) {
        OnBoardingModel documentModel = OnBoardingModel.fromJson(element.data());
        onBoardingModel.add(documentModel);
      }
    }).catchError((error) {
      log(error.toString());
    });
    return onBoardingModel;
  }

  Future<List<TaxModel>?> getTaxList() async {
    List<TaxModel> taxList = [];

    await fireStore.collection(CollectionName.tax).where('country', isEqualTo: Constant.country).where('enable', isEqualTo: true).get().then((value) {
      for (var element in value.docs) {
        TaxModel taxModel = TaxModel.fromJson(element.data());
        taxList.add(taxModel);
      }
    }).catchError((error) {
      log(error.toString());
    });
    return taxList;
  }

  static Future<bool?> checkReferralCodeValidOrNot(String referralCode) async {
    bool? isExit;
    try {
      await fireStore.collection(CollectionName.referral).where("referralCode", isEqualTo: referralCode).get().then((value) {
        if (value.size > 0) {
          isExit = true;
        } else {
          isExit = false;
        }
      });
    } catch (e, s) {
      log('FireStoreUtils.firebaseCreateNewUser $e $s');
      return false;
    }
    return isExit;
  }

  static Future<ReferralModel?> getReferralUserByCode(String referralCode) async {
    ReferralModel? referralModel;
    try {
      await fireStore.collection(CollectionName.referral).where("referralCode", isEqualTo: referralCode).get().then((value) {
        referralModel = ReferralModel.fromJson(value.docs.first.data());
      });
    } catch (e, s) {
      log('FireStoreUtils.firebaseCreateNewUser $e $s');
      return null;
    }
    return referralModel;
  }

  static Future<String?> referralAdd(ReferralModel ratingModel) async {
    try {
      await fireStore.collection(CollectionName.referral).doc(ratingModel.id).set(ratingModel.toJson());
    } catch (e, s) {
      log('FireStoreUtils.firebaseCreateNewUser $e $s');
      return null;
    }
    return null;
  }

  static Future<bool> updateUser(UserModel userModel) async {
    bool isUpdate = false;
    await fireStore.collection(CollectionName.users).doc(userModel.id).set(userModel.toJson()).whenComplete(() {
      isUpdate = true;
    }).catchError((error) {
      log("Failed to update user: $error");
      isUpdate = false;
    });
    return isUpdate;
  }

  static Future<UserModel?> getUserProfile(String uuid) async {
    print(uuid);
    UserModel? userModel;
    await fireStore.collection(CollectionName.users).doc(uuid).get().then((value) {
      if (value.exists) {
        userModel = UserModel.fromJson(value.data()!);
      }
    }).catchError((error) {
      log("Failed to update user: $error");
      userModel = null;
    });
    return userModel;
  }

  Future<CurrencyModel?> getCurrency() async {
    CurrencyModel? currencyModel;
    await fireStore.collection(CollectionName.currency).where("enable", isEqualTo: true).get().then((value) {
      if (value.docs.isNotEmpty) {
        currencyModel = CurrencyModel.fromJson(value.docs.first.data());
      }
    });
    return currencyModel;
  }

  static Future<List<LanguageModel>?> getLanguage() async {
    List<LanguageModel> languageList = [];

    await fireStore.collection(CollectionName.languages).where("enable", isEqualTo: true).get().then((value) {
      for (var element in value.docs) {
        LanguageModel taxModel = LanguageModel.fromJson(element.data());
        languageList.add(taxModel);
      }
    }).catchError((error) {
      log(error.toString());
    });
    return languageList;
  }

  static Future<List<ReviewModel>?> getRating(String reviewReceivedId) async {
    List<ReviewModel> taxList = [];

    await fireStore.collection(CollectionName.review).where('receiver_id', isEqualTo: reviewReceivedId).orderBy("date", descending: true).get().then((value) {
      for (var element in value.docs) {
        ReviewModel taxModel = ReviewModel.fromJson(element.data());
        taxList.add(taxModel);
      }
    }).catchError((error) {
      log(error.toString());
    });
    return taxList;
  }

  static Future<bool?> deleteUser() async {
    bool? isDelete;
    try {
      await fireStore.collection(CollectionName.users).doc(FireStoreUtils.getCurrentUid()).delete();

      // delete user  from firebase auth
      await FirebaseAuth.instance.currentUser!.delete().then((value) {
        isDelete = true;
      });
    } catch (e, s) {
      log('FireStoreUtils.firebaseCreateNewUser $e $s');
      return false;
    }
    return isDelete;
  }

  static Future<void> logout() async {
    try {
      // Sign out from Firebase Auth
      await FirebaseAuth.instance.signOut();
      
      // Clear session data from SharedPreferences
      await Preferences.setBoolean(Preferences.isUserLoggedInKey, false);
      await Preferences.setString(Preferences.userUidKey, "");
      
      log("User logged out successfully");
    } catch (e) {
      log("Error during logout: $e");
    }
  }

  getSettings() async {
    await fireStore.collection(CollectionName.settings).doc("global").get().then((value) {
      if (value.exists) {
        Constant.termsAndConditions = value.data()!["termsAndConditions"];
        Constant.privacyPolicy = value.data()!["privacyPolicy"];
        Constant.appBannerImageDark = value.data()!["appBannerImageDark"];
        Constant.appBannerImageLight = value.data()!["appBannerImageLight"];
        Constant.globalUrl = value.data()!["globalUrl"];
        AppThemeData.primary300 = Color(int.parse(value.data()!["appColor"].replaceFirst("#", "0xff")));
      }
    });

    await fireStore.collection(CollectionName.settings).doc("adminCommission").get().then((value) {
      if (value.data() != null) {
        Constant.adminCommission = AdminCommission.fromJson(value.data()!);
      }
    });

    fireStore.collection(CollectionName.settings).doc("globalKey").snapshots().listen((event) {
      if (event.exists) {
        Constant.mapAPIKey = event.data()!["googleMapKey"];
        Constant.distanceType = event.data()!["distanceType"];
      }
    });

    fireStore.collection(CollectionName.settings).doc("globalValue").snapshots().listen((event) {
      if (event.exists) {
        Constant.priceVariation = event.data()!["priceVariation"];
        Constant.radius = event.data()!["radius"];
        Constant.intervalHoursForPublishNewRide = event.data()!['intervalHoursForPublishNewRide'];
        Constant.minimumAmountToDeposit = event.data()!["minimumAmountToDeposit"];
        Constant.minimumAmountToWithdrawal = event.data()!["minimumAmountToWithdrawal"];
        Constant.verifyBooking = event.data()!["verifyBooking"];
        Constant.verifyPublish = event.data()!["verifyPublish"];
      }
    });

    fireStore.collection(CollectionName.settings).doc("notification_settings").get().then((value) {
      if (value.exists) {
        Constant.senderId = value.data()!["senderId"];
        Constant.jsonNotificationFileURL = value.data()!["serviceJson"];
      }
    });

    await fireStore.collection(CollectionName.settings).doc("referral").get().then((value) {
      if (value.exists) {
        Constant.referralAmount = value.data()!["referralAmount"];
      }
    });

    await fireStore.collection(CollectionName.settings).doc("contact_us").get().then((value) {
      if (value.exists) {
        Constant.supportURL = value.data()!["supportURL"];
      }
    });
  }

  Future<PaymentModel?> getPayment() async {
    PaymentModel? paymentModel;
    await fireStore.collection(CollectionName.settings).doc("payment").get().then((value) {
      paymentModel = PaymentModel.fromJson(value.data()!);
    });
    return paymentModel;
  }

  static Future<bool?> updateUserWallet({required String amount}) async {
    bool isAdded = false;
    await getUserProfile(FireStoreUtils.getCurrentUid()).then((value) async {
      if (value != null) {
        UserModel userModel = value;
        userModel.walletAmount = (double.parse(userModel.walletAmount.toString()) + double.parse(amount)).toString();
        await FireStoreUtils.updateUser(userModel).then((value) {
          isAdded = value;
        });
      }
    });
    return isAdded;
  }

  static Future<bool?> updateOtherUserWallet({required String amount, required String id}) async {
    bool isAdded = false;
    await getUserProfile(id).then((value) async {
      if (value != null) {
        UserModel userModel = value;
        userModel.walletAmount = (double.parse(userModel.walletAmount.toString()) + double.parse(amount)).toString();
        await FireStoreUtils.updateUser(userModel).then((value) {
          isAdded = value;
        });
      }
    });
    return isAdded;
  }

  static Future<bool?> setSearchHistory(RecentSearchModel recentSearchModel) async {
    bool isAdded = false;
    await fireStore.collection(CollectionName.userSearchHistory).doc(recentSearchModel.id).set(recentSearchModel.toJson()).then((value) {
      isAdded = true;
    }).catchError((error) {
      log("Failed to update user: $error");
      isAdded = false;
    });
    return isAdded;
  }

  static Future<List<RecentSearchModel>?> getSearchHistory() async {
    List<RecentSearchModel> list = [];

    await fireStore.collection(CollectionName.userSearchHistory).where("userId", isEqualTo: getCurrentUid()).orderBy('createdAt', descending: true).get().then((value) {
      for (var element in value.docs) {
        RecentSearchModel searchModel = RecentSearchModel.fromJson(element.data());
        list.add(searchModel);
      }
    }).catchError((error) {
      log(error.toString());
    });
    return list;
  }

  static Future<List<VehicleBrandModel>?> getVehicleBrand() async {
    List<VehicleBrandModel> list = [];

    await fireStore.collection(CollectionName.vehicleBrand).where("enable", isEqualTo: true).get().then((value) {
      for (var element in value.docs) {
        VehicleBrandModel searchModel = VehicleBrandModel.fromJson(element.data());
        list.add(searchModel);
      }
    }).catchError((error) {
      log(error.toString());
    });
    return list;
  }

  static Future<List<VehicleModel>?> getVehicleModel(String brandId) async {
    List<VehicleModel> list = [];

    await fireStore.collection(CollectionName.vehicleModel).where("brandId", isEqualTo: brandId).where("enable", isEqualTo: true).get().then((value) {
      for (var element in value.docs) {
        VehicleModel searchModel = VehicleModel.fromJson(element.data());
        list.add(searchModel);
      }
    }).catchError((error) {
      log(error.toString());
    });
    return list;
  }

  static Future<List<VehicleTypeModel>?> getVehicleType() async {
    List<VehicleTypeModel> list = [];

    await fireStore.collection(CollectionName.vehicleType).where("enable", isEqualTo: true).get().then((value) {
      for (var element in value.docs) {
        VehicleTypeModel searchModel = VehicleTypeModel.fromJson(element.data());
        list.add(searchModel);
      }
    }).catchError((error) {
      log(error.toString());
    });
    return list;
  }

  static Future<bool?> setUserVehicleInformation(VehicleInformationModel informationModel) async {
    bool isAdded = false;
    await fireStore.collection(CollectionName.userVehicleInformation).doc(informationModel.id).set(informationModel.toJson()).then((value) {
      isAdded = true;
    }).catchError((error) {
      log("Failed to update user: $error");
      isAdded = false;
    });
    return isAdded;
  }

  static Future<bool?> deleteVehicleInformation(VehicleInformationModel informationModel) async {
    bool isAdded = false;
    await fireStore.collection(CollectionName.userVehicleInformation).doc(informationModel.id).delete().then((value) {
      isAdded = true;
    }).catchError((error) {
      log("Failed to update user: $error");
      isAdded = false;
    });
    return isAdded;
  }

  static Future<List<VehicleInformationModel>?> getUserVehicleInformation() async {
    List<VehicleInformationModel> list = [];

    await fireStore.collection(CollectionName.userVehicleInformation).where("userId", isEqualTo: getCurrentUid()).get().then((value) {
      for (var element in value.docs) {
        VehicleInformationModel searchModel = VehicleInformationModel.fromJson(element.data());
        list.add(searchModel);
      }
    }).catchError((error) {
      log(error.toString());
    });
    return list;
  }

  static Future<bool?> setBooking(BookingModel bookingModel) async {
    bool isAdded = false;
    await fireStore.collection(CollectionName.booking).doc(bookingModel.id).set(bookingModel.toJson()).then((value) {
      isAdded = true;
    }).catchError((error) {
      log("Failed to update user: $error");
      isAdded = false;
    });
    return isAdded;
  }

  static Future<bool?> deleteBooking(BookingModel bookingModel) async {
    bool isAdded = false;
    await fireStore.collection(CollectionName.booking).doc(bookingModel.id).delete().then((value) {
      isAdded = true;
    }).catchError((error) {
      log("Failed to update user: $error");
      isAdded = false;
    });
    return isAdded;
  }

  static Future<List<BookingModel>?> getPublishes() async {
    List<BookingModel>? bookingList = [];
    await fireStore.collection(CollectionName.booking).where("createdBy", isEqualTo: FireStoreUtils.getCurrentUid()).orderBy("createdAt", descending: true).get().then((value) {
      for (var element in value.docs) {
        BookingModel documentModel = BookingModel.fromJson(element.data());
        bookingList.add(documentModel);
      }
    }).catchError((error) {
      log("Failed to update user: $error");
    });
    return bookingList;
  }

  static Future<List<BookingModel>?> checkAtivePublishes() async {
    List<BookingModel>? bookingList = [];

    await fireStore
        .collection(CollectionName.booking)
        .where("createdBy", isEqualTo: FireStoreUtils.getCurrentUid())
        .where("status", isNotEqualTo: Constant.completed)
        .where('publish', isEqualTo: true)
        .orderBy("createdAt", descending: true)
        .get()
        .then((value) {
      for (var element in value.docs) {
        log("BookingList :: ${element.id}");
        BookingModel documentModel = BookingModel.fromJson(element.data());
        bookingList.add(documentModel);
      }
    }).catchError((error) {
      log("Failed to update user: $error");
    });
    return bookingList;
  }

  static Future<List<BookingModel>?> getMyBooking() async {
    List<BookingModel>? bookingList = [];
    await fireStore.collection(CollectionName.booking).where("bookedUserId", arrayContains: FireStoreUtils.getCurrentUid()).orderBy("createdAt", descending: true).get().then((value) {
      for (var element in value.docs) {
        BookingModel documentModel = BookingModel.fromJson(element.data());
        bookingList.add(documentModel);
      }
    }).catchError((error) {
      log("Failed to update user: $error");
    });
    return bookingList;
  }

  static Future<BookingModel?> getMyBookingNyUserId(String id) async {
    BookingModel? bookingList;
    await fireStore.collection(CollectionName.booking).doc(id).get().then((value) {
      if (value.exists) {
        bookingList = BookingModel.fromJson(value.data()!);
      }
    }).catchError((error) {
      log("Failed to update user: $error");
    });
    return bookingList;
  }

  static Future<BookedUserModel?> getMyBookingUser(BookingModel bookingModel) async {
    BookedUserModel? bookingList;
    await fireStore.collection(CollectionName.booking).doc(bookingModel.id).collection("bookedUser").doc(getCurrentUid()).get().then((value) {
      if (value.exists) {
        bookingList = BookedUserModel.fromJson(value.data()!);
      }
    }).catchError((error) {
      log("Failed to update user: $error");
    });
    return bookingList;
  }

  /// Get unpaid trips for current user
  /// Returns the first unpaid trip with booking model and booked user model
  /// Only checks for completed trips (when driver clicks "Reached")
  static Future<Map<String, dynamic>?> getUnpaidTrip() async {
    try {
      String currentUserId = getCurrentUid();
      if (currentUserId.isEmpty) {
        log("getUnpaidTrip: User ID is empty");
        return null;
      }

      log("getUnpaidTrip: Checking for unpaid trips for user: $currentUserId");

      // Get all bookings where user is a passenger
      // Only check completed trips (when driver clicks "Reached")
      // Payment screen should only show when trip is completed, not when it's onGoing
      QuerySnapshot completedSnapshot;
      try {
        // Try with orderBy first
        completedSnapshot = await fireStore
            .collection(CollectionName.booking)
            .where("bookedUserId", arrayContains: currentUserId)
            .where("status", isEqualTo: Constant.completed)
            .orderBy("createdAt", descending: true)
            .get();
      } catch (e) {
        // If orderBy fails (missing index), try without it
        log("getUnpaidTrip: orderBy failed, trying without orderBy: $e");
        completedSnapshot = await fireStore
            .collection(CollectionName.booking)
            .where("bookedUserId", arrayContains: currentUserId)
            .where("status", isEqualTo: Constant.completed)
            .get();
      }
      
      log("getUnpaidTrip: Found ${completedSnapshot.docs.length} completed bookings");

      // Process all snapshots
      for (var bookingDoc in completedSnapshot.docs) {
        try {
          BookingModel bookingModel = BookingModel.fromJson(bookingDoc.data() as Map<String, dynamic>);
          
          log("getUnpaidTrip: Checking booking ${bookingModel.id}");
          
          // Get the booked user data for this booking
          var bookedUserDoc = await fireStore
              .collection(CollectionName.booking)
              .doc(bookingModel.id)
              .collection("bookedUser")
              .doc(currentUserId)
              .get();

          if (bookedUserDoc.exists) {
            BookedUserModel bookedUserModel = BookedUserModel.fromJson(bookedUserDoc.data() as Map<String, dynamic>);
            
            log("getUnpaidTrip: Booking ${bookingModel.id} - paymentStatus: ${bookedUserModel.paymentStatus}");
            
            // Check if payment is not completed (null or false means unpaid)
            // Treat null as unpaid since paymentStatus is nullable
            if (bookedUserModel.paymentStatus == null || bookedUserModel.paymentStatus == false) {
              log("getUnpaidTrip: Found unpaid trip - booking ${bookingModel.id}");
              return {
                "bookingModel": bookingModel,
                "bookedUserModel": bookedUserModel,
              };
            } else {
              log("getUnpaidTrip: Booking ${bookingModel.id} is already paid");
            }
          } else {
            log("getUnpaidTrip: BookedUser document not found for booking ${bookingModel.id}");
          }
        } catch (e) {
          log("getUnpaidTrip: Error processing booking document: $e");
          continue; // Continue to next booking
        }
      }
      
      log("getUnpaidTrip: No unpaid trips found");
      return null;
    } catch (error) {
      log("getUnpaidTrip: Failed to get unpaid trip: $error");
      return null;
    }
  }

  static Future<List<BookedUserModel>?> getMyBookingUserList(BookingModel bookingModel) async {
    List<BookedUserModel>? bookingList = [];
    await fireStore.collection(CollectionName.booking).doc(bookingModel.id).collection("bookedUser").get().then((value) {
      for (var element in value.docs) {
        BookedUserModel documentModel = BookedUserModel.fromJson(element.data());
        bookingList.add(documentModel);
      }
    }).catchError((error) {
      log("Failed to update user: $error");
    });
    return bookingList;
  }

  static Future<bool?> setUserBooking(BookingModel bookingModel, BookedUserModel bookingUserModel) async {
    bool isAdded = false;
    await fireStore.collection(CollectionName.booking).doc(bookingModel.id).collection("bookedUser").doc(bookingUserModel.id).set(bookingUserModel.toJson()).then((value) {
      isAdded = true;
    }).catchError((error) {
      log("Failed to update user: $error");
      isAdded = false;
    });
    return isAdded;
  }

  static Future<bool?> removeUserBooking(BookingModel bookingModel, BookedUserModel bookingUserModel) async {
    bool isAdded = false;
    await fireStore.collection(CollectionName.booking).doc(bookingModel.id).collection("bookedUser").doc(bookingUserModel.id).delete().then((value) {
      isAdded = true;
    }).catchError((error) {
      log("Failed to update user: $error");
      isAdded = false;
    });
    return isAdded;
  }

  static Future<bool?> setCancelledUserBooking(BookingModel bookingModel, BookedUserModel bookingUserModel) async {
    bool isAdded = false;
    await fireStore.collection(CollectionName.booking).doc(bookingModel.id).collection("cancelledUser").doc(bookingUserModel.id).set(bookingUserModel.toJson()).then((value) {
      isAdded = true;
    }).catchError((error) {
      log("Failed to update user: $error");
      isAdded = false;
    });
    return isAdded;
  }

  static Future<List<DocumentModel>> getDocumentList() async {
    List<DocumentModel> documentList = [];
    await fireStore.collection(CollectionName.documents).where('enable', isEqualTo: true).get().then((value) {
      for (var element in value.docs) {
        DocumentModel documentModel = DocumentModel.fromJson(element.data());
        documentList.add(documentModel);
      }
    }).catchError((error) {
      log(error.toString());
    });
    return documentList;
  }

  static Future<UserVerificationModel?> getDocumentOfDriver() async {
    UserVerificationModel? driverDocumentModel;
    await fireStore.collection(CollectionName.userVerification).doc(getCurrentUid()).get().then((value) async {
      if (value.exists) {
        driverDocumentModel = UserVerificationModel.fromJson(value.data()!);
      }
    });
    return driverDocumentModel;
  }

  static Future<bool> uploadDriverDocument(Documents documents) async {
    bool isAdded = false;
    UserVerificationModel driverDocumentModel = UserVerificationModel();
    List<Documents> documentsList = [];
    await fireStore.collection(CollectionName.userVerification).doc(getCurrentUid()).get().then((value) async {
      if (value.exists) {
        UserVerificationModel newDriverDocumentModel = UserVerificationModel.fromJson(value.data()!);
        documentsList = newDriverDocumentModel.documents!;
        var contain = newDriverDocumentModel.documents!.where((element) => element.documentId == documents.documentId);
        if (contain.isEmpty) {
          documentsList.add(documents);

          driverDocumentModel.id = getCurrentUid();
          driverDocumentModel.documents = documentsList;
        } else {
          var index = newDriverDocumentModel.documents!.indexWhere((element) => element.documentId == documents.documentId);

          driverDocumentModel.id = getCurrentUid();
          documentsList.removeAt(index);
          documentsList.insert(index, documents);
          driverDocumentModel.documents = documentsList;
          isAdded = false;
          ShowToastDialog.showToast("Document is under verification");
        }
      } else {
        documentsList.add(documents);
        driverDocumentModel.id = getCurrentUid();
        driverDocumentModel.documents = documentsList;
      }
    });

    await fireStore.collection(CollectionName.userVerification).doc(getCurrentUid()).set(driverDocumentModel.toJson()).then((value) {
      isAdded = true;
    }).catchError((error) {
      isAdded = false;
      log(error.toString());
    });

    return isAdded;
  }

  static Future<bool?> setWalletTransaction(WalletTransactionModel walletTransactionModel) async {
    bool isAdded = false;
    await fireStore.collection(CollectionName.walletTransaction).doc(walletTransactionModel.id).set(walletTransactionModel.toJson()).then((value) {
      isAdded = true;
    }).catchError((error) {
      log("Failed to update user: $error");
      isAdded = false;
    });
    return isAdded;
  }

  static Future<List<WalletTransactionModel>?> getWalletTransaction() async {
    List<WalletTransactionModel> walletTransactionModel = [];

    await fireStore.collection(CollectionName.walletTransaction).where('userId', isEqualTo: FireStoreUtils.getCurrentUid()).orderBy('createdDate', descending: true).get().then((value) {
      for (var element in value.docs) {
        WalletTransactionModel taxModel = WalletTransactionModel.fromJson(element.data());
        walletTransactionModel.add(taxModel);
      }
    }).catchError((error) {
      log(error.toString());
    });
    return walletTransactionModel;
  }

  static Future<bool?> setReport(ReportModel recentSearchModel) async {
    bool isAdded = false;
    await fireStore.collection(CollectionName.report).doc(recentSearchModel.id).set(recentSearchModel.toJson()).then((value) {
      isAdded = true;
    }).catchError((error) {
      log("Failed to update user: $error");
      isAdded = false;
    });
    return isAdded;
  }

  static Future<NotificationModel?> getNotificationContent(String type) async {
    NotificationModel? notificationModel;
    await fireStore.collection(CollectionName.dynamicNotification).where('type', isEqualTo: type).get().then((value) {
      print("------>");
      if (value.docs.isNotEmpty) {
        print(value.docs.first.data());
        notificationModel = NotificationModel.fromJson(value.docs.first.data());
      } else {
        notificationModel = NotificationModel(id: "", message: "Notification setup is pending", subject: "setup notification", type: "");
      }
    });
    return notificationModel;
  }

  static Future<ReviewModel?> getReview({required String bookingId, required String senderId}) async {
    ReviewModel? reviewModel;
    await fireStore
        .collection(CollectionName.review)
        .where('booking_id', isEqualTo: bookingId)
        .where(
          'sender_id',
          isEqualTo: senderId,
        )
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        reviewModel = ReviewModel.fromJson(value.docs.first.data());
      }
    });
    return reviewModel;
  }

  static Future<ReviewModel?> getReviewByReceiverId({required String bookingId, required String receiverId}) async {
    ReviewModel? reviewModel;
    await fireStore
        .collection(CollectionName.review)
        .where('booking_id', isEqualTo: bookingId)
        .where(
          'receiver_id',
          isEqualTo: receiverId,
        )
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        reviewModel = ReviewModel.fromJson(value.docs.first.data());
      }
    });
    return reviewModel;
  }

  static Future<bool?> setReview(ReviewModel reviewModel) async {
    bool isAdded = false;
    await fireStore.collection(CollectionName.review).doc(reviewModel.id).set(reviewModel.toJson()).then((value) {
      isAdded = true;
    }).catchError((error) {
      log("Failed to update user: $error");
      isAdded = false;
    });
    return isAdded;
  }

  static Future<WithdrawMethodModel?> getWithdrawMethod() async {
    WithdrawMethodModel? withdrawMethodModel;
    await fireStore.collection(CollectionName.withdrawMethod).where("userId", isEqualTo: getCurrentUid()).get().then((value) async {
      if (value.docs.isNotEmpty) {
        withdrawMethodModel = WithdrawMethodModel.fromJson(value.docs.first.data());
      }
    });
    return withdrawMethodModel;
  }

  static Future<WithdrawMethodModel?> setWithdrawMethod(WithdrawMethodModel withdrawMethodModel) async {
    if (withdrawMethodModel.id == null) {
      withdrawMethodModel.id = Constant.getUuid();
      withdrawMethodModel.userId = getCurrentUid();
    }
    await fireStore.collection(CollectionName.withdrawMethod).doc(withdrawMethodModel.id).set(withdrawMethodModel.toJson()).then((value) async {});
    return withdrawMethodModel;
  }

  static Future<bool?> setWithdrawRequest(WithdrawModel withdrawModel) async {
    bool isAdded = false;
    await fireStore.collection(CollectionName.withdrawalHistory).doc(withdrawModel.id).set(withdrawModel.toJson()).then((value) {
      isAdded = true;
    }).catchError((error) {
      log("Failed to update user: $error");
      isAdded = false;
    });
    return isAdded;
  }

  static Future<List<WithdrawModel>?> getWithDrawRequest() async {
    List<WithdrawModel> withdrawalList = [];
    await fireStore.collection(CollectionName.withdrawalHistory).where('userId', isEqualTo: getCurrentUid()).orderBy('createdDate', descending: true).get().then((value) {
      for (var element in value.docs) {
        WithdrawModel documentModel = WithdrawModel.fromJson(element.data());
        withdrawalList.add(documentModel);
      }
    }).catchError((error) {
      log(error.toString());
    });
    return withdrawalList;
  }

  static Future<List<String>> getAdvertiseBannersData() async {
    try {
      final snapshot = await fireStore.collection(CollectionName.settings).doc("AdvertiseBanners").get();
      if (snapshot.exists) {
        final banners = snapshot.data()?['banners'] as List<dynamic>?;
        if (banners != null) {
          final advertiseBannerModel = banners.map((e) => e.toString()).toList();
          return advertiseBannerModel;
        }
      }
    } catch (error, stackTrace) {
      log('Error fetching advertise banners: $error', stackTrace: stackTrace);
    }
    return [];
  }

  static late StreamSubscription<QuerySnapshot> adminChatSeenSubscription;
  static void setSeen() {
    final currentUserId = FireStoreUtils.getCurrentUid();

    adminChatSeenSubscription = FirebaseFirestore.instance
        .collection(CollectionName.adminChat)
        .doc(currentUserId)
        .collection("thread")
        .where('senderId', isEqualTo: Constant.adminType)
        .where('seen', isEqualTo: false)
        .snapshots()
        .listen((querySnapshot) async {
      for (final doc in querySnapshot.docs) {
        try {
          await doc.reference.update({'seen': true});
        } catch (e) {
          log(e.toString());
        }
      }
    }, onError: (error) {
      log(error.toString());
    });
  }

  static void stopSeenListener() {
    adminChatSeenSubscription.cancel();
  }

  static Future addInAdminBox(InboxAdminModel inboxModel) async {
    return await fireStore.collection(CollectionName.adminChat).doc(FireStoreUtils.getCurrentUid()).set(inboxModel.toJson()).then((document) {
      return inboxModel;
    });
  }

  static Future addAdminChat(ConversationAdminModel conversationModel) async {
    return await fireStore.collection(CollectionName.adminChat).doc(conversationModel.senderId).collection("thread").doc(conversationModel.id).set(conversationModel.toJson()).then((document) {
      return conversationModel;
    });
  }

  static Future<SosModel?> getSOS({required String bookingId, required String driverId, required String customerId}) async {
    SosModel? sosModel;
    try {
      await fireStore.collection(CollectionName.sos).where("bookingId", isEqualTo: bookingId).where("customerId", isEqualTo: customerId).where("driverId", isEqualTo: driverId).get().then((value) {
        sosModel = SosModel.fromJson(value.docs.first.data());
      });
    } catch (e, s) {
      log('FireStoreUtils.firebaseCreateNewUser $e $s');
      return null;
    }
    return sosModel;
  }

  static Future<bool?> setSOS(SosModel sosModel) async {
    bool isAdded = false;
    await fireStore.collection(CollectionName.sos).doc(sosModel.id).set(sosModel.toJson()).then((value) {
      isAdded = true;
    }).catchError((error) {
      log("Failed to update user: $error");
      isAdded = false;
    });
    return isAdded;
  }
}
