import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:wevoride/app/add_your_ride/step_five_price_screen.dart';
import 'package:wevoride/controller/add_your_ride_controller.dart';
import 'package:wevoride/themes/app_them_data.dart';
import 'package:wevoride/themes/round_button_fill.dart';
import 'package:wevoride/utils/dark_theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:wevoride/widgets/custom_scaffold.dart';

class StepFourPassengerTakeScreen extends StatelessWidget {
  const StepFourPassengerTakeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: AddYourRideController(),
        builder: (controller) {
          return CustomScaffold(
            backgroundColor: themeChange.getThem() ? AppThemeData.grey800 : AppThemeData.grey50,
            appBar: AppBar(
              backgroundColor: themeChange.getThem() ? AppThemeData.grey900 : AppThemeData.grey100,
              centerTitle: false,
              titleSpacing: 0,
              leading: InkWell(
                onTap: () {
                  Get.back();
                },
                child: Icon(
                  Icons.chevron_left_outlined,
                  color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900,
                ),
              ),
              elevation: 0,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(4.0),
                child: Container(
                  color: themeChange.getThem() ? AppThemeData.grey700 : AppThemeData.grey200,
                  height: 4.0,
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "How many passengers can you take?".tr,
                      style: TextStyle(color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900, fontFamily: AppThemeData.bold, fontSize: 20),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          if (controller.numberOfSheet.value != 1) {
                            controller.numberOfSheet.value -= 1;
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppThemeData.primary300)),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Icon(Icons.remove, color: AppThemeData.primary300),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      Text(
                        "0${controller.numberOfSheet.value}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800,
                          fontSize: 62,
                          fontFamily: AppThemeData.bold,
                        ),
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      InkWell(
                        onTap: () {
                          if (controller.numberOfSheet.value < 8) {
                            controller.numberOfSheet.value += 1;
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppThemeData.primary300)),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Icon(
                              Icons.add,
                              color: AppThemeData.primary300,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Divider(),
                  ),
                  Text(
                    "Passenger Options".tr,
                    style: TextStyle(color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900, fontFamily: AppThemeData.medium, fontSize: 16),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      if (controller.twoPassengerMaxInBack.value) {
                        controller.twoPassengerMaxInBack.value = false;
                      } else {
                        controller.twoPassengerMaxInBack.value = true;
                      }
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset("assets/icons/ic_two_passanger.svg"),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Text(
                            "2 Passengers Max in Back Seat".tr,
                            style: TextStyle(color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800, fontFamily: AppThemeData.bold, fontSize: 14),
                          ),
                        ),
                        Checkbox(
                          activeColor: AppThemeData.primary300,
                          value: controller.twoPassengerMaxInBack.value,
                          onChanged: (val) {
                            controller.twoPassengerMaxInBack.value = val!;
                          },
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      if (controller.womenOnly.value) {
                        controller.womenOnly.value = false;
                      } else {
                        controller.womenOnly.value = true;
                      }
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset("assets/icons/ic_women_only.svg"),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Text(
                            "Women Only".tr,
                            style: TextStyle(color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800, fontFamily: AppThemeData.bold, fontSize: 14),
                          ),
                        ),
                        Checkbox(
                          activeColor: AppThemeData.primary300,
                          value: controller.womenOnly.value,
                          onChanged: (val) {
                            controller.womenOnly.value = val!;
                          },
                        )
                      ],
                    ),
                  ),
                  Expanded(child: SizedBox()),
                  Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: RoundedButtonFill(
                title: "Next".tr,
                color: AppThemeData.primary300,
                textColor: AppThemeData.grey50,
                onPress: () {
                  Get.to(const StepFivePriceScreen());
                },
              ),
            )
                ],
              ),
            ),
          );
        });
  }
}
