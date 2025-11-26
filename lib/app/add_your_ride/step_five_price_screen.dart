import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:wevoride/app/add_your_ride/step_six_stop_over_price_screen.dart';
import 'package:wevoride/app/travel_preference/travel_preference_screen.dart';
import 'package:wevoride/app/verification_screen/verification_screen.dart';
import 'package:wevoride/constant/constant.dart';
import 'package:wevoride/controller/add_your_ride_controller.dart';
import 'package:wevoride/themes/app_them_data.dart';
import 'package:wevoride/themes/round_button_fill.dart';
import 'package:wevoride/utils/dark_theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:wevoride/widgets/custom_scaffold.dart';

import '../../themes/text_field_widget.dart';

class StepFivePriceScreen extends StatelessWidget {
  const StepFivePriceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
      init: AddYourRideController(),
      builder: (controller) {
        return CustomScaffold(
          backgroundColor: themeChange.getThem()
              ? AppThemeData.grey800
              : AppThemeData.grey50,
          appBar: AppBar(
            backgroundColor: themeChange.getThem()
                ? AppThemeData.grey900
                : AppThemeData.grey100,
            centerTitle: false,
            titleSpacing: 0,
            leading: InkWell(
              onTap: () {
                Get.back();
              },
              child: Icon(
                Icons.chevron_left_outlined,
                color: themeChange.getThem()
                    ? AppThemeData.grey50
                    : AppThemeData.grey900,
              ),
            ),
            elevation: 0,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(4.0),
              child: Container(
                color: themeChange.getThem()
                    ? AppThemeData.grey700
                    : AppThemeData.grey200,
                height: 4.0,
              ),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "Set your price per seats".tr,
                      style: TextStyle(
                          color: themeChange.getThem()
                              ? AppThemeData.grey50
                              : AppThemeData.grey900,
                          fontFamily: AppThemeData.bold,
                          fontSize: 20),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // InkWell(
                      //   onTap: () {
                      //     if (controller.price.value >= Constant.getMinusPercentageAmount(controller.recommendedPrice.value.toString())) {
                      //       controller.changePriceVariant(false);
                      //     }
                      //   },
                      //   child: Container(
                      //     decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppThemeData.primary300)),
                      //     child: Padding(
                      //       padding: const EdgeInsets.all(4.0),
                      //       child: Icon(Icons.remove, color: AppThemeData.primary300),
                      //     ),
                      //   ),
                      // ),
                      const SizedBox(
                        width: 10,
                      ),
                      
                      Text(
                        Constant.amountShow(
                            amount: controller.price.value.toString()),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: themeChange.getThem()
                              ? AppThemeData.grey100
                              : AppThemeData.grey800,
                          fontSize: 32,
                          fontFamily: AppThemeData.bold,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      // InkWell(
                      //   onTap: () {
                      //     if (controller.price.value <= Constant.getPlusPercentageAmount(controller.recommendedPrice.value.toString())) {
                      //       controller.changePriceVariant(true);
                      //     }
                      //   },
                      //   child: Container(
                      //     decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppThemeData.primary300)),
                      //     child: Padding(
                      //       padding: const EdgeInsets.all(4.0),
                      //       child: Icon(
                      //         Icons.add,
                      //         color: AppThemeData.primary300,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Center(
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            controller.isPriceEdit.value =
                                !controller.isPriceEdit.value;
                          },
                          child: Text(
                            "Change Price".tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                decorationColor: AppThemeData.primary300,
                                color: themeChange.getThem()
                                    ? AppThemeData.primary300
                                    : AppThemeData.primary300,
                                fontFamily: AppThemeData.medium,
                                fontSize: 14),
                          ),
                        ),
                        Visibility(
                          visible: controller.isPriceEdit.value,
                          child: TextFieldWidget(
                            onChanged: (value) {
                              controller.price.value = double.parse(
                                  controller.pricePerSeatController.value.text);
                              if (controller.stopOverList.length == 1) {
                                controller.stopOverList[0].price = controller
                                    .pricePerSeatController.value.text;
                              }
                            },
                            hintText: ''.tr,
                            controller: controller.pricePerSeatController.value,
                            textInputType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Recommended Price per seat: ${Constant.amountShow(amount: controller.recommendedPrice.value.toString())}"
                              .tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: themeChange.getThem()
                                  ? AppThemeData.grey50
                                  : AppThemeData.grey900,
                              fontFamily: AppThemeData.regular,
                              fontSize: 14),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Total Distance: ${Constant.distanceCalculate(controller.distance.value.toString())} ${Constant.distanceType}"
                              .tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: themeChange.getThem()
                                  ? AppThemeData.grey50
                                  : AppThemeData.grey900,
                              fontFamily: AppThemeData.regular,
                              fontSize: 14),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Price per ${Constant.distanceType} : ${Constant.amountShow(amount: controller.selectedUserVehicle.value.vehicleType?.perKmCharges.toString())}"
                              .tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: themeChange.getThem()
                                  ? AppThemeData.grey50
                                  : AppThemeData.grey900,
                              fontFamily: AppThemeData.regular,
                              fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(const StepSixStopOverPriceScreen());
                    },
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              "Stopover prices".tr,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  decorationColor: AppThemeData.primary300,
                                  color: themeChange.getThem()
                                      ? AppThemeData.primary300
                                      : AppThemeData.primary300,
                                  fontFamily: AppThemeData.bold,
                                  fontSize: 14),
                            ),
                          ),
                        ),
                        Icon(
                          Icons.chevron_right_outlined,
                          color: AppThemeData.primary300,
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Divider(),
                  ),
                  InkWell(
                    onTap: () {
                      changeLuggageBuildBottomSheet(context);
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset("assets/icons/ic_luggage.svg"),
                        const SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: Text(
                            "Luggage allowed".tr,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: themeChange.getThem()
                                    ? AppThemeData.grey200
                                    : AppThemeData.grey700,
                                fontFamily: AppThemeData.medium,
                                fontSize: 14),
                          ),
                        ),
                        Text(
                          "${controller.luggageAllowed.value} Carry on bag".tr,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: themeChange.getThem()
                                  ? AppThemeData.grey300
                                  : AppThemeData.grey600,
                              fontFamily: AppThemeData.medium,
                              fontSize: 14),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const Icon(Icons.chevron_right_outlined)
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Divider(),
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(const TravelPreferenceScreen())!.then((value) {
                        controller.getUserData();
                      });
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset("assets/icons/ic_preferences.svg"),
                        const SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: Text(
                            "Preferences".tr,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: themeChange.getThem()
                                    ? AppThemeData.grey200
                                    : AppThemeData.grey700,
                                fontFamily: AppThemeData.medium,
                                fontSize: 14),
                          ),
                        ),
                        Text(
                          "Change".tr,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: themeChange.getThem()
                                  ? AppThemeData.grey300
                                  : AppThemeData.grey600,
                              fontFamily: AppThemeData.medium,
                              fontSize: 14),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const Icon(Icons.chevron_right_outlined)
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Divider(),
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(const VerificationScreen())!.then((value) {
                        controller.getUserData();
                      });
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          "assets/icons/ic_shield.svg",
                          color: controller.userModel.value.isVerify == false
                              ? AppThemeData.warning400
                              : AppThemeData.success400,
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: Text(
                            controller.userModel.value.isVerify == true
                                ? "Account Verified"
                                : "Account not Verify".tr,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color:
                                    controller.userModel.value.isVerify == false
                                        ? AppThemeData.warning400
                                        : AppThemeData.success400,
                                fontFamily: AppThemeData.medium,
                                fontSize: 14),
                          ),
                        ),
                        Text(
                          controller.userModel.value.isVerify == true
                              ? "Verified"
                              : "Verify".tr,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: controller.userModel.value.isVerify == true
                                  ? AppThemeData.success400
                                  : AppThemeData.warning400,
                              fontFamily: AppThemeData.medium,
                              fontSize: 14),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        controller.userModel.value.isVerify == true
                            ? const SizedBox()
                            : Icon(
                                Icons.chevron_right_outlined,
                                color:
                                    controller.userModel.value.isVerify == false
                                        ? AppThemeData.warning400
                                        : AppThemeData.warning400,
                              )
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
              // Button fixed at bottom
              Container(
                color: themeChange.getThem()
                    ? AppThemeData.grey800
                    : AppThemeData.grey50,
                padding: const EdgeInsets.all(16),
                child: SafeArea(
                  top: false,
                  child: RoundedButtonFill(
                    title: "Publish Ride".tr,
                    color: AppThemeData.primary300,
                    textColor: AppThemeData.grey50,
                    onPress: () {
                      controller.publishRide();
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  changeLuggageBuildBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.50,
        minChildSize: 0.50,
        maxChildSize: 0.92,
        expand: false,
        builder: (context, scrollController) {
          final themeChange = Provider.of<DarkThemeProvider>(context);
          return GetX(
              init: AddYourRideController(),
              builder: (controller) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: Text(
                                "Select a Luggage allowed".tr,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontFamily: AppThemeData.bold),
                              ),
                            ),
                          ),
                          InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: const Icon(Icons.close))
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                controller.luggageAllowed.value = 1;
                              },
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "1 Carry on bag".tr,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: themeChange.getThem()
                                                  ? AppThemeData.grey100
                                                  : AppThemeData.grey800,
                                              fontFamily: AppThemeData.medium),
                                        ),
                                      ),
                                      Radio(
                                        value: 1,
                                        groupValue:
                                            controller.luggageAllowed.value,
                                        activeColor: AppThemeData.primary300,
                                        onChanged: (value) {
                                          controller.luggageAllowed.value =
                                              value!;
                                        },
                                      ),
                                    ],
                                  ),
                                  const Divider(),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                controller.luggageAllowed.value = 2;
                              },
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "2 Carry on bag".tr,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: themeChange.getThem()
                                                  ? AppThemeData.grey100
                                                  : AppThemeData.grey800,
                                              fontFamily: AppThemeData.medium),
                                        ),
                                      ),
                                      Radio(
                                        value: 2,
                                        groupValue:
                                            controller.luggageAllowed.value,
                                        activeColor: AppThemeData.primary300,
                                        onChanged: (value) {
                                          controller.luggageAllowed.value =
                                              value!;
                                        },
                                      ),
                                    ],
                                  ),
                                  const Divider(),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                controller.luggageAllowed.value = 3;
                              },
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "3 Carry on bag".tr,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: themeChange.getThem()
                                                  ? AppThemeData.grey100
                                                  : AppThemeData.grey800,
                                              fontFamily: AppThemeData.medium),
                                        ),
                                      ),
                                      Radio(
                                        value: 3,
                                        groupValue:
                                            controller.luggageAllowed.value,
                                        activeColor: AppThemeData.primary300,
                                        onChanged: (value) {
                                          controller.luggageAllowed.value =
                                              value!;
                                        },
                                      ),
                                    ],
                                  ),
                                  const Divider(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      RoundedButtonFill(
                        title: "Select".tr,
                        color: AppThemeData.primary300,
                        textColor: AppThemeData.grey50,
                        onPress: () {
                          controller.selectedVehicleController.value.text =
                              "${controller.selectedUserVehicle.value.vehicleBrand!.name} ${controller.selectedUserVehicle.value.vehicleModel!.name} (${controller.selectedUserVehicle.value.licensePlatNumber})";
                          Get.back();
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                );
              });
        },
      ),
    );
  }
}
