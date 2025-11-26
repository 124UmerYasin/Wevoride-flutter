import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:wevoride/constant/constant.dart';
import 'package:wevoride/controller/travel_preference_controller.dart';
import 'package:wevoride/themes/app_them_data.dart';
import 'package:wevoride/themes/round_button_fill.dart';
import 'package:wevoride/utils/dark_theme_provider.dart';
import 'package:wevoride/widgets/custom_scaffold.dart';
import 'package:wevoride/widgets/safe_bottom_widget.dart';
import 'package:provider/provider.dart';

class TravelPreferenceScreen extends StatelessWidget {
  const TravelPreferenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: TravelPreferenceController(),
        builder: (controller) {
          return CustomScaffold(
           backgroundColor: themeChange.getThem() ? AppThemeData.grey800 : AppThemeData.grey100,
            appBar: AppBar(
              backgroundColor: themeChange.getThem() ? AppThemeData.grey900 : AppThemeData.grey50,
              centerTitle: false,
              automaticallyImplyLeading: false,
              titleSpacing: 0,
              leading: InkWell(
                  onTap: () {
                    Get.back();
                  },
                    child: Icon(
                  Icons.chevron_left_outlined,
                  color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900,
                ),),
              title: Text(
                "Travel Preference".tr,
                style: TextStyle(color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800, fontFamily: AppThemeData.bold, fontSize: 18),
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
            body: controller.isLoading.value
                ? Constant.loader()
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Plan Your Dream Trip".tr,
                            style: TextStyle(color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800, fontFamily: AppThemeData.bold, fontSize: 20),
                          ),
                          Text(
                            "Tell us what makes your wanderlust ignite and we'll find the perfect adventure for you.".tr,
                            style: TextStyle(color: themeChange.getThem() ? AppThemeData.grey200 : AppThemeData.grey700, fontFamily: AppThemeData.regular),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Chattiness".tr,
                            style: TextStyle(color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900, fontFamily: AppThemeData.bold, fontSize: 16),
                          ),
                          ListView.builder(
                            itemCount: Constant.chattiness.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Obx(
                                () => InkWell(
                                  onTap: () {
                                    controller.chattiness.value = Constant.chattiness[index];
                                  },
                                  child: Row(
                                    children: [
                                      index == 2 ? SvgPicture.asset("assets/icons/ic_quites.svg") : SvgPicture.asset("assets/icons/ic_love_chat.svg"),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                          child: Text(
                                        Constant.chattiness[index],
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900,
                                          fontFamily: AppThemeData.medium,
                                        ),
                                      )),
                                      Radio(
                                        value: Constant.chattiness[index],
                                        groupValue: controller.chattiness.value,
                                        activeColor: AppThemeData.primary300,
                                        onChanged: (value) {
                                          controller.chattiness.value = Constant.chattiness[index];
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          const Divider(),
                          Text(
                            "Smoking".tr,
                            style: TextStyle(color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900, fontFamily: AppThemeData.bold, fontSize: 16),
                          ),
                          ListView.builder(
                            itemCount: Constant.smoking.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Obx(
                                () => InkWell(
                                  onTap: () {
                                    controller.smoking.value = Constant.smoking[index];
                                  },
                                  child: Row(
                                    children: [
                                      index == 2 ? SvgPicture.asset("assets/icons/ic_no_smoking.svg") : SvgPicture.asset("assets/icons/ic_smoking.svg"),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                          child: Text(
                                        Constant.smoking[index],
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900,
                                          fontFamily: AppThemeData.medium,
                                        ),
                                      )),
                                      Radio(
                                        value: Constant.smoking[index],
                                        groupValue: controller.smoking.value,
                                        activeColor: AppThemeData.primary300,
                                        onChanged: (value) {
                                          controller.smoking.value = Constant.smoking[index];
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          const Divider(),
                          Text(
                            "Music".tr,
                            style: TextStyle(color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900, fontFamily: AppThemeData.bold, fontSize: 16),
                          ),
                          ListView.builder(
                            itemCount: Constant.music.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Obx(
                                () => InkWell(
                                  onTap: () {
                                    controller.music.value = Constant.music[index];
                                  },
                                  child: Row(
                                    children: [
                                      index == 2 ? SvgPicture.asset("assets/icons/ic_no_music.svg") : SvgPicture.asset("assets/icons/ic_music.svg"),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                          child: Text(
                                        Constant.music[index],
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900,
                                          fontFamily: AppThemeData.medium,
                                        ),
                                      )),
                                      Radio(
                                        value: Constant.music[index],
                                        groupValue: controller.music.value,
                                        activeColor: AppThemeData.primary300,
                                        onChanged: (value) {
                                          controller.music.value = Constant.music[index];
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          const Divider(),
                          Text(
                            "Pets".tr,
                            style: TextStyle(color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900, fontFamily: AppThemeData.bold, fontSize: 16),
                          ),
                          ListView.builder(
                            itemCount: Constant.pets.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Obx(
                                () => InkWell(
                                  onTap: () {
                                    controller.pets.value = Constant.pets[index];
                                  },
                                  child: Row(
                                    children: [
                                      index == 2 ? SvgPicture.asset("assets/icons/pet.svg") : SvgPicture.asset("assets/icons/pet.svg"),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                          child: Text(
                                        Constant.pets[index],
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900,
                                          fontFamily: AppThemeData.medium,
                                        ),
                                      )),
                                      Radio(
                                        value: Constant.pets[index],
                                        groupValue: controller.pets.value,
                                        activeColor: AppThemeData.primary300,
                                        onChanged: (value) {
                                          controller.pets.value = Constant.pets[index];
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ),
            bottomNavigationBar: SafeBottomWidget(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PreferredSize(
                    preferredSize: const Size.fromHeight(4.0),
                    child: Container(
                      color: themeChange.getThem() ? AppThemeData.grey700 : AppThemeData.grey200,
                      height: 4.0,
                    ),
                  ),
                  const SizedBox(height: 10),
                  RoundedButtonFill(
                    title: "Save".tr,
                    color: AppThemeData.primary300,
                    textColor: AppThemeData.grey50,
                    onPress: () async {
                      controller.saveData();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
