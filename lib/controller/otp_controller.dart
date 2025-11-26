import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OtpController extends GetxController {
  Rx<TextEditingController> otpController = TextEditingController().obs;

  RxString countryCode = "".obs;
  RxString phoneNumber = "".obs;
  RxString verificationId = "".obs;
  RxInt resendToken = 0.obs;
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    getArgument();
    super.onInit();
  }

  getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      countryCode.value = argumentData['countryCode'];
      phoneNumber.value = argumentData['phoneNumber'];
      verificationId.value = argumentData['verificationId'];
    }
    isLoading.value = false;
    update();
  }

  Future<bool> sendOTP() async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: countryCode.value + phoneNumber.value,
        verificationCompleted: (PhoneAuthCredential credential) {
          debugPrint("Auto verification completed");
        },
        verificationFailed: (FirebaseAuthException e) {
          debugPrint("Resend verification failed: ${e.message}");
        },
        codeSent: (String verificationId0, int? resendToken0) async {
          verificationId.value = verificationId0;
          resendToken.value = resendToken0 ?? 0;
          debugPrint("OTP sent successfully");
        },
        timeout: const Duration(seconds: 60),
        forceResendingToken: resendToken.value > 0 ? resendToken.value : null,
        codeAutoRetrievalTimeout: (String verificationId0) {
          debugPrint("Auto retrieval timeout: $verificationId0");
        },
      );
      return true;
    } catch (e) {
      debugPrint("Error sending OTP: $e");
      return false;
    }
  }
}
