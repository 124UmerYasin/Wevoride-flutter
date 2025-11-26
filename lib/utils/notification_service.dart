import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:wevoride/app/help_support_screen/help_support_screen.dart';
import 'package:wevoride/app/payment/force_payment_screen.dart';
import 'package:wevoride/constant/constant.dart';
import 'package:wevoride/model/booking_model.dart';
import 'package:wevoride/utils/fire_store_utils.dart';
import 'package:wevoride/utils/preferences.dart';

Future<void> firebaseMessageBackgroundHandle(RemoteMessage message) async {
  log("BackGround Message :: ${message.messageId}");
}

class NotificationService {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  initInfo() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    var request = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (request.authorizationStatus == AuthorizationStatus.authorized || request.authorizationStatus == AuthorizationStatus.provisional) {
      const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
      var iosInitializationSettings = const DarwinInitializationSettings();
      final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: iosInitializationSettings);
      await flutterLocalNotificationsPlugin.initialize(initializationSettings, onDidReceiveNotificationResponse: (response) async {
        if (response.payload != null) {
          final data = jsonDecode(response.payload!);
          final String type = data['type'] ?? '';
          await _handleMessageClick(type: type, isBgApp: false);
        }
      });
      setupInteractedMessage();
    }
  }

  Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      FirebaseMessaging.onBackgroundMessage((message) => firebaseMessageBackgroundHandle(message));
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      log("::::::::::::onMessage:::::::::::::::::");
      if (message.notification != null) {
        log(message.notification.toString());
        display(message);
      }
      // Handle ride_arrive notification in foreground
      final String type = message.data['type'] ?? '';
      if (type == Constant.ride_arrive) {
        await _handleRideArrive();
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? message) async {
      log("::::::::::::onMessageOpenedApp:::::::::::::::::");
      if (message != null) {
        final String type = message.data['type'] ?? '';
        _handleMessageClick(type: type, isBgApp: false);
      }
    });

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        final String type = message.data['type'] ?? '';
        _handleMessageClick(type: type, isBgApp: true);
      }
    });

    log("::::::::::::Permission authorized:::::::::::::::::");
    await FirebaseMessaging.instance.subscribeToTopic("wevoride");
  }

  _handleMessageClick({required String type, required bool isBgApp}) async {
    final String uid = FireStoreUtils.getCurrentUid();
    if (type == 'admin_chat' && uid.isNotEmpty) {
      await Preferences.setBoolean(Preferences.isClickOnNotification, true);
      if (isBgApp == false) {
        Get.offAll(HelpSupportScreen());
      }
    } else if (type == Constant.ride_arrive) {
      await _handleRideArrive();
    }
  }

  /// Handle ride_arrive notification by showing payment screen
  Future<void> _handleRideArrive() async {
    try {
      log("Handling ride_arrive notification");
      // Longer delay to ensure database is updated after driver clicks "Reached"
      // The booking status needs to be updated to "completed" in Firestore first
      await Future.delayed(const Duration(seconds: 2));
      
      // Check for unpaid trip with retry logic
      Map<String, dynamic>? unpaidTrip;
      int retries = 3;
      for (int i = 0; i < retries; i++) {
        unpaidTrip = await FireStoreUtils.getUnpaidTrip();
        if (unpaidTrip != null) {
          log("Found unpaid trip on attempt ${i + 1}");
          break;
        }
        // If not found, wait a bit and retry (database might still be updating)
        if (i < retries - 1) {
          log("No unpaid trip found, retrying... (attempt ${i + 1}/$retries)");
          await Future.delayed(const Duration(milliseconds: 1000));
        }
      }
      
      if (unpaidTrip != null) {
        BookingModel bookingModel = unpaidTrip['bookingModel'] as BookingModel;
        BookedUserModel bookedUserModel = unpaidTrip['bookedUserModel'] as BookedUserModel;
        
        log("Showing payment screen for booking: ${bookingModel.id}");
        
        // Show force payment screen
        Get.to(
          () => ForcePaymentScreen(
            bookingModel: bookingModel,
            bookedUserModel: bookedUserModel,
          ),
        );
      } else {
        log("No unpaid trip found after ride_arrive notification");
      }
    } catch (e) {
      log("Error handling ride_arrive: $e");
    }
  }

  static getToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    return token!;
  }

  void display(RemoteMessage message) async {
    log('Got a message whilst in the foreground!');
    try {
      AndroidNotificationChannel channel = const AndroidNotificationChannel(
        '0',
        'goRide-customer',
        description: 'Show QuickLAI Notification',
        importance: Importance.max,
      );
      AndroidNotificationDetails notificationDetails =
          AndroidNotificationDetails(channel.id, channel.name, channelDescription: 'your channel Description', importance: Importance.high, priority: Priority.high, ticker: 'ticker');
      const DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(presentAlert: true, presentBadge: true, presentSound: true);
      NotificationDetails notificationDetailsBoth = NotificationDetails(android: notificationDetails, iOS: darwinNotificationDetails);
      await FlutterLocalNotificationsPlugin().show(
        0,
        message.notification!.title,
        message.notification!.body,
        notificationDetailsBoth,
        payload: jsonEncode(message.data),
      );
    } on Exception catch (e) {
      log(e.toString());
    }
  }
}
