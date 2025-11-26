import 'dart:async';

import 'package:get/get.dart';
import 'package:wevoride/app/dashboard_screen.dart';
import 'package:wevoride/app/help_support_screen/help_support_screen.dart';
import 'package:wevoride/app/on_boarding_screen/get_started_screen.dart';
import 'package:wevoride/app/on_boarding_screen/on_boarding_screen.dart';
import 'package:wevoride/controller/dashboard_controller.dart';
import 'package:wevoride/services/auth_service.dart';
import 'package:wevoride/utils/preferences.dart';

class SplashController extends GetxController {
  Timer? timer;
  @override
  void onInit() {
    timer = Timer(const Duration(seconds: 3), () => redirectScreen());
    super.onInit();
  }

  redirectScreen() async {
    if (Preferences.getBoolean(Preferences.isClickOnNotification) != true) {
      if (Preferences.getBoolean(Preferences.isFinishOnBoardingKey) == false) {
        Get.offAll(const OnBoardingScreen());
      } else {
        // Use AuthService to check login status
        bool isLogin = await AuthService.to.checkAuthState();
        if (isLogin == true) {
          // Initialize dashboard controller globally so listener works on all screens
          DashboardScreenController.initialize();
          Get.offAll(const DashBoardScreen());
        } else {
          Get.offAll(const GetStartedScreen());
        }
      }
    } else {
      Get.to(HelpSupportScreen());
    }
  }
}
