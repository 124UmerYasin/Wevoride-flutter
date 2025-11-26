import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wevoride/app/dashboard_screen.dart';
import 'package:wevoride/controller/dashboard_controller.dart';
import 'package:wevoride/themes/app_them_data.dart';
import 'package:wevoride/themes/round_button_fill.dart';
import 'package:wevoride/widgets/custom_scaffold.dart';

class BookingSuccessScreen extends StatelessWidget {
  const BookingSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: AppThemeData.success400,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 100),
              child: Image.asset("assets/images/booking_success.gif"),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              "Booked!! Enjoy Your Ride".tr,
              maxLines: 1,
              style: const TextStyle(
                color: AppThemeData.grey50,
                fontSize: 16,
                overflow: TextOverflow.ellipsis,
                fontFamily: AppThemeData.bold,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Go to “my ride” section for details of your ride and more options.".tr,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppThemeData.grey50,
                      fontSize: 16,
                      fontFamily: AppThemeData.regular,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            RoundedButtonFill(
              title: "Go to my ride".tr,
              color: AppThemeData.grey50,
              width: 50,
              textColor: AppThemeData.grey900,
              onPress: () {
                DashboardScreenController homeController = Get.put(DashboardScreenController());
                homeController.selectedIndex.value = 1;
                Get.offAll(const DashBoardScreen());
              },
            )
          ],
        ),
      ),
    );
  }
}
