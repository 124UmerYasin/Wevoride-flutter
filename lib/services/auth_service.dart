import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wevoride/utils/fire_store_utils.dart';
import 'package:wevoride/utils/preferences.dart';

class AuthService extends GetxService {
  static AuthService get to => Get.find();
  
  final FirebaseAuth _auth = FirebaseAuth.instance;
  StreamSubscription<User?>? _authStateSubscription;
  
  final Rx<User?> currentUser = Rx<User?>(null);
  final RxBool isLoggedIn = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    _initAuthStateListener();
  }
  
  @override
  void onClose() {
    _authStateSubscription?.cancel();
    super.onClose();
  }
  
  void _initAuthStateListener() {
    _authStateSubscription = _auth.authStateChanges().listen((User? user) {
      currentUser.value = user;
      isLoggedIn.value = user != null;
      
      if (user != null) {
        // User is signed in
        debugPrint("User signed in: ${user.uid}");
        Preferences.setBoolean(Preferences.isUserLoggedInKey, true);
        Preferences.setString(Preferences.userUidKey, user.uid);
      } else {
        // User is signed out
        debugPrint("User signed out");
        Preferences.setBoolean(Preferences.isUserLoggedInKey, false);
        Preferences.setString(Preferences.userUidKey, "");
      }
    });
  }
  
  Future<bool> checkAuthState() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        // Verify user exists in Firestore
        bool userExists = await FireStoreUtils.userExistOrNot(user.uid);
        if (userExists) {
          currentUser.value = user;
          isLoggedIn.value = true;
          return true;
        } else {
          // User doesn't exist in Firestore, sign out
          await signOut();
          return false;
        }
      } else {
        // Check SharedPreferences as fallback
        bool isLoggedInPref = Preferences.getBoolean(Preferences.isUserLoggedInKey);
        if (isLoggedInPref) {
          String savedUid = Preferences.getString(Preferences.userUidKey);
          if (savedUid.isNotEmpty) {
            bool userExists = await FireStoreUtils.userExistOrNot(savedUid);
            if (userExists) {
              isLoggedIn.value = true;
              return true;
            } else {
              // Clear invalid session data
              await Preferences.setBoolean(Preferences.isUserLoggedInKey, false);
              await Preferences.setString(Preferences.userUidKey, "");
            }
          }
        }
        isLoggedIn.value = false;
        return false;
      }
    } catch (e) {
      debugPrint("Error checking auth state: $e");
      isLoggedIn.value = false;
      return false;
    }
  }
  
  Future<void> signOut() async {
    try {
      await FireStoreUtils.logout();
      currentUser.value = null;
      isLoggedIn.value = false;
    } catch (e) {
      debugPrint("Error signing out: $e");
    }
  }
  
  String? get currentUserId => currentUser.value?.uid;
}
