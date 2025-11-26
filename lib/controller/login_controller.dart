import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wevoride/app/auth_screen/information_screen.dart';
import 'package:wevoride/app/auth_screen/otp_screen.dart';
import 'package:wevoride/app/dashboard_screen.dart';
import 'package:wevoride/constant/constant.dart';
import 'package:wevoride/controller/dashboard_controller.dart';
import 'package:wevoride/constant/show_toast_dialog.dart';
import 'package:wevoride/model/user_model.dart';
import 'package:wevoride/utils/fire_store_utils.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginController extends GetxController {
  Rx<TextEditingController> phoneNumber = TextEditingController().obs;
  Rx<TextEditingController> countryCodeController = TextEditingController(text: "+962").obs;

  RxBool isLogin = false.obs;

  @override
  void onInit() {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      isLogin.value = argumentData['isLogin'];
    }
    super.onInit();
  }

  sendCode() async {
    // Validate phone number format
    String fullPhoneNumber = countryCodeController.value.text + phoneNumber.value.text;
    
    // Basic phone number validation
    if (phoneNumber.value.text.isEmpty) {
      ShowToastDialog.showToast("Please enter mobile number".tr);
      return;
    }
    
    if (phoneNumber.value.text.length < 7 || phoneNumber.value.text.length > 15) {
      ShowToastDialog.showToast("Please enter a valid mobile number".tr);
      return;
    }
    
    // Check if phone number contains only digits
    if (!RegExp(r'^[0-9]+$').hasMatch(phoneNumber.value.text)) {
      ShowToastDialog.showToast("Phone number should contain only digits".tr);
      return;
    }
    
    ShowToastDialog.showLoader("please wait...".tr);
    
    try {
      await FirebaseAuth.instance
          .verifyPhoneNumber(
              phoneNumber: fullPhoneNumber,
              verificationCompleted: (PhoneAuthCredential credential) {
                ShowToastDialog.closeLoader();
                debugPrint("Auto verification completed");
              },
              verificationFailed: (FirebaseAuthException e) {
                debugPrint("FirebaseAuthException--->${e.message}");
                ShowToastDialog.closeLoader();
                if (e.code == 'invalid-phone-number') {
                  ShowToastDialog.showToast("invalid_phone_number".tr);
                } else if (e.code == 'too-many-requests') {
                  ShowToastDialog.showToast("Too many requests. Please try again later".tr);
                } else if (e.code == 'network-request-failed') {
                  ShowToastDialog.showToast("Network error. Please check your connection".tr);
                } else {
                  ShowToastDialog.showToast(e.message ?? "Verification failed. Please try again".tr);
                }
              },
              codeSent: (String verificationId, int? resendToken) {
                ShowToastDialog.closeLoader();
                Get.to(const OtpScreen(), arguments: {
                  "countryCode": countryCodeController.value.text,
                  "phoneNumber": phoneNumber.value.text,
                  "verificationId": verificationId,
                  "resendToken": resendToken,
                });
              },
              codeAutoRetrievalTimeout: (String verificationId) {
                debugPrint("Auto retrieval timeout: $verificationId");
              },
              timeout: const Duration(seconds: 60));
    } catch (error) {
      debugPrint("catchError--->$error");
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast("An error occurred. Please try again".tr);
    }
  }

  loginWithGoogle() async {
    ShowToastDialog.showLoader("please wait...".tr);
    await signInWithGoogle().then((value) async {
      ShowToastDialog.closeLoader();
      if (value != null) {
        if (value.additionalUserInfo!.isNewUser) {
          UserModel userModel = UserModel();
          userModel.id = value.user!.uid;
          userModel.email = value.user!.email;
          userModel.firstName = value.user!.displayName;
          userModel.profilePic = value.user!.photoURL;
          userModel.loginType = Constant.googleLoginType;

          ShowToastDialog.closeLoader();
          Get.to(const InformationScreen(), arguments: {
            "userModel": userModel,
          });
        } else {
          await FireStoreUtils.userExistOrNot(value.user!.uid).then((userExit) async {
            ShowToastDialog.closeLoader();
            if (userExit == true) {
              UserModel? userModel = await FireStoreUtils.getUserProfile(value.user!.uid);
              if (userModel != null) {
                if (userModel.isActive == true) {
                  // Initialize dashboard controller globally
                  DashboardScreenController.initialize();
                  Get.offAll(const DashBoardScreen());
                } else {
                  await FirebaseAuth.instance.signOut();
                  ShowToastDialog.showToast("This user is disable please contact administrator".tr);
                }
              }
            } else {
              UserModel userModel = UserModel();
              userModel.id = value.user!.uid;
              userModel.email = value.user!.email;
              userModel.firstName = value.user!.displayName;
              userModel.profilePic = value.user!.photoURL;
              userModel.loginType = Constant.googleLoginType;

              Get.to(const InformationScreen(), arguments: {
                "userModel": userModel,
              });
            }
          });
        }
      }
    });
  }

  loginWithApple() async {
    ShowToastDialog.showLoader("please wait...".tr);
    await signInWithApple().then((value) {
      ShowToastDialog.closeLoader();
      print(value);
      if (value != null) {
        Map<String, dynamic> map = value;
        AuthorizationCredentialAppleID appleCredential = map['appleCredential'];
        UserCredential userCredential = map['userCredential'];
        if (userCredential.additionalUserInfo!.isNewUser) {
          UserModel userModel = UserModel();
          userModel.id = userCredential.user!.uid;
          userModel.email = appleCredential.email ?? userCredential.user?.email;
          userModel.firstName = appleCredential.givenName;
          userModel.lastName = appleCredential.familyName;
          userModel.profilePic = "";
          userModel.loginType = Constant.appleLoginType;

          ShowToastDialog.closeLoader();
          Get.to(const InformationScreen(), arguments: {
            "userModel": userModel,
          });
        } else {
          FireStoreUtils.userExistOrNot(userCredential.user!.uid).then((userExit) async {
            ShowToastDialog.closeLoader();

            if (userExit == true) {
              UserModel? userModel = await FireStoreUtils.getUserProfile(userCredential.user!.uid);
              if (userModel != null) {
                if (userModel.isActive == true) {
                  // Initialize dashboard controller globally
                  DashboardScreenController.initialize();
                  Get.offAll(const DashBoardScreen());
                } else {
                  await FirebaseAuth.instance.signOut();
                  ShowToastDialog.showToast("This user is disable please contact administrator".tr);
                }
              }
            } else {
              UserModel userModel = UserModel();
              userModel.id = userCredential.user!.uid;
              userModel.profilePic = "";
              userModel.email = appleCredential.email ?? userCredential.user?.email;
              userModel.firstName = appleCredential.givenName;
              userModel.lastName = appleCredential.familyName;
              userModel.loginType = Constant.googleLoginType;

              Get.to(const InformationScreen(), arguments: {
                "userModel": userModel,
              });
            }
          });
        }
      }
    });
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn().catchError((error) {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast("something_went_wrong".tr);
        return null;
      });

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
    // Trigger the authentication flow
  }

  Future<Map<String, dynamic>?> signInWithApple() async {
    try {
      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);
      // Request credential for the currently signed in Apple account.
      AuthorizationCredentialAppleID appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
        // webAuthenticationOptions: WebAuthenticationOptions(clientId: clientID, redirectUri: Uri.parse(redirectURL)),
      );
      print(appleCredential);

      // Create an `OAuthCredential` from the credential returned by Apple.
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
        rawNonce: rawNonce,
      );

      // Sign in the user with Firebase. If the nonce we generated earlier does
      // not match the nonce in `appleCredential.identityToken`, sign in will fail.
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(oauthCredential);
      return {"appleCredential": appleCredential, "userCredential": userCredential};
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
