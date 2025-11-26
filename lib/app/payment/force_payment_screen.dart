import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wevoride/app/dashboard_screen.dart';
import 'package:wevoride/app/report_help_screen/report_help_screen.dart';
import 'package:wevoride/app/wallet_screen/select_payment_method_screen.dart';
import 'package:wevoride/constant/constant.dart';
import 'package:wevoride/controller/booked_details_controller.dart';
import 'package:wevoride/controller/dashboard_controller.dart';
import 'package:wevoride/model/booking_model.dart';
import 'package:wevoride/themes/app_them_data.dart';
import 'package:wevoride/themes/round_button_fill.dart';
import 'package:wevoride/utils/dark_theme_provider.dart';
import 'package:provider/provider.dart';

class ForcePaymentScreen extends StatelessWidget {
  final BookingModel bookingModel;
  final BookedUserModel bookedUserModel;

  const ForcePaymentScreen({
    super.key,
    required this.bookingModel,
    required this.bookedUserModel,
  });

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final controller = Get.put(BookedDetailsController());
    controller.bookingModel.value = bookingModel;
    controller.bookingUserModel.value = bookedUserModel;

    return PopScope(
      canPop: false, // Prevent back button
      child: Scaffold(
        backgroundColor: themeChange.getThem() ? AppThemeData.grey900 : AppThemeData.grey50,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppThemeData.primary300.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.payment,
                    size: 50,
                    color: AppThemeData.primary300,
                  ),
                ),
                const SizedBox(height: 30),
                
                // Title
                Text(
                  "Payment Required".tr,
                  style: TextStyle(
                    color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey900,
                    fontFamily: AppThemeData.bold,
                    fontSize: 24,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                
                // Description
                Text(
                  "Please complete payment for your trip to continue using the app.".tr,
                  style: TextStyle(
                    color: themeChange.getThem() ? AppThemeData.grey300 : AppThemeData.grey700,
                    fontFamily: AppThemeData.regular,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                
                // Trip Info Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: themeChange.getThem() ? AppThemeData.grey800 : AppThemeData.grey100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Trip Details".tr,
                        style: TextStyle(
                          color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey900,
                          fontFamily: AppThemeData.semiBold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "From:".tr,
                            style: TextStyle(
                              color: themeChange.getThem() ? AppThemeData.grey300 : AppThemeData.grey700,
                              fontFamily: AppThemeData.regular,
                              fontSize: 14,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              bookingModel.pickUpAddress ?? "",
                              style: TextStyle(
                                color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey900,
                                fontFamily: AppThemeData.medium,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.end,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "To:".tr,
                            style: TextStyle(
                              color: themeChange.getThem() ? AppThemeData.grey300 : AppThemeData.grey700,
                              fontFamily: AppThemeData.regular,
                              fontSize: 14,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              bookingModel.dropAddress ?? "",
                              style: TextStyle(
                                color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey900,
                                fontFamily: AppThemeData.medium,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.end,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Divider(),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Amount:".tr,
                            style: TextStyle(
                              color: themeChange.getThem() ? AppThemeData.grey300 : AppThemeData.grey700,
                              fontFamily: AppThemeData.regular,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            Constant.amountShow(amount: controller.calculateAmount().toString()),
                            style: TextStyle(
                              color: AppThemeData.primary300,
                              fontFamily: AppThemeData.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                
                // Payment Button
                RoundedButtonFill(
                  title: "Complete Payment".tr,
                  color: AppThemeData.primary300,
                  textColor: AppThemeData.grey50,
                  onPress: () async {
                    try {
                      var result = await Get.to(
                        const SelectPaymentMethodScreen(),
                        arguments: {
                          "type": "booking",
                          "amount": controller.calculateAmount().toString(),
                          "selectedPaymentMethod": bookedUserModel.paymentType.toString(),
                          "bookingId": bookingModel.id.toString(),
                        },
                      );
                      
                      if (result != null && result is Map) {
                        // Get payment type from result
                        String? paymentType = result['paymentType'];
                        if (paymentType != null && paymentType.isNotEmpty) {
                          controller.paymentType.value = paymentType;
                          // Complete the payment - this will update payment status in database
                          await controller.paymentCompleted();
                          // Reset payment screen flag in dashboard controller
                          try {
                            var dashboardController = Get.find<DashboardScreenController>();
                            dashboardController.resetPaymentScreenFlag();
                          } catch (e) {
                            print("Dashboard controller not found: $e");
                          }
                          // Navigate to home screen immediately after payment completion
                          // Using offAll to clear navigation stack and go to home
                          Get.offAll(const DashBoardScreen());
                        }
                      }
                    } catch (e) {
                      print("Error in payment flow: $e");
                      // Even if there's an error, try to navigate to home
                      Get.offAll(const DashBoardScreen());
                    }
                  },
                ),
                const SizedBox(height: 16),
                
                // Report Ride Button
                RoundedButtonFill(
                  title: "Report This Ride".tr,
                  color: themeChange.getThem() ? AppThemeData.grey700 : AppThemeData.grey200,
                  textColor: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800,
                  onPress: () async {
                    // IMPORTANT: Reset the payment screen flag BEFORE navigating away
                    // and manually suppress this booking until reporting completes to avoid re-show.
                    try {
                      var dashboardController = Get.find<DashboardScreenController>();
                      dashboardController.resetPaymentScreenFlag();
                      if (bookingModel.id != null) {
                        dashboardController.suppressPaymentUntilCleared(bookingModel.id!);
                      }
                    } catch (e) {
                      print("Dashboard controller not found: $e");
                    }

                    // Close payment screen and navigate to report screen
                    Get.back();

                    // Navigate to report screen
                    await Get.to(
                      const ReportHelpScreen(),
                      arguments: {
                        "reportedBy": "customer",
                        "reportedTo": bookingModel.createdBy,
                        "bookingId": bookingModel.id,
                      },
                    );

                    // After reporting, suppress for a short time to allow Firestore update to propagate
                    // then clear suppression
                    try {
                      var dashboardController = Get.find<DashboardScreenController>();
                      if (bookingModel.id != null) {
                        // Keep suppressed for 2 more seconds to let Firestore catch up
                        dashboardController.suppressPaymentForBooking(bookingModel.id!, duration: const Duration(seconds: 2));
                      }
                    } catch (e) {
                      print("Dashboard controller not found when extending suppression: $e");
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

