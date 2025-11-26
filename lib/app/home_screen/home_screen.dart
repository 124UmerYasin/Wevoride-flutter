import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wevoride/app/add_your_ride/add_your_ride_screen.dart';
import 'package:wevoride/app/home_screen/datepicker_screen.dart';
import 'package:wevoride/app/home_screen/view_all_search_screen.dart';
import 'package:wevoride/app/verification_screen/verification_screen.dart';
import 'package:wevoride/constant/constant.dart';
import 'package:wevoride/constant/show_toast_dialog.dart';
import 'package:wevoride/controller/home_controller.dart';
import 'package:wevoride/model/map/place_picker_model.dart';
import 'package:wevoride/model/recent_search_model.dart';
import 'package:wevoride/themes/app_them_data.dart';
import 'package:wevoride/themes/custom_dialog_box.dart';
import 'package:wevoride/themes/responsive.dart';
import 'package:wevoride/themes/round_button_fill.dart';
import 'package:wevoride/utils/dark_theme_provider.dart';
import 'package:wevoride/utils/network_image_widget.dart';
import 'package:wevoride/widgets/custom_scaffold.dart';
import 'package:wevoride/widgets/google_map_search_place.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
      init: HomeController(),
      builder: (controller) {
        return CustomScaffold(
          appBar: controller.bannerList.isNotEmpty
              ? AppBar(
                  backgroundColor: Colors.transparent,
                  title: GestureDetector(
                    onTap: () {},
                    child: Text(
                      "WevoRide".tr,
                      style: TextStyle(
                        color: themeChange.getThem()
                            ? AppThemeData.grey100
                            : AppThemeData.grey800,
                        fontFamily: AppThemeData.semiBold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                )
              : null,
          backgroundColor: themeChange.getThem()
              ? AppThemeData.grey800
              : AppThemeData.grey100,
          body: controller.isLoading.value
              ? Constant.loader()
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Visibility(
                            visible: controller.bannerList.isEmpty,
                            child: NetworkImageWidget(
                              filterQuality: FilterQuality.high,
                              imageUrl: themeChange.getThem()
                                  ? Constant.appBannerImageDark
                                  : Constant.appBannerImageLight,
                              fit: BoxFit.cover,
                              width: Responsive.width(100, context),
                              height: Responsive.height(50, context),
                            ),
                          ),
                          SafeArea(
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: 10,
                              ),
                              child: Column(
                                children: [
                                  Visibility(
                                    visible: !controller.bannerList.isNotEmpty,
                                    child: AppBar(
                                      backgroundColor: Colors.transparent,
                                      title: Text(
                                        "WevoRide".tr,
                                        style: TextStyle(
                                          color: themeChange.getThem()
                                              ? AppThemeData.grey100
                                              : AppThemeData.grey800,
                                          fontFamily: AppThemeData.semiBold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: controller.bannerList.isNotEmpty,
                                    child: CarouselSlider.builder(
                                      itemCount: controller.bannerList.length,
                                      itemBuilder: (BuildContext context,
                                          int index, int realIndex) {
                                        return ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: NetworkImageWidget(
                                            width:
                                                Responsive.width(100, context),
                                            height: 167,
                                            filterQuality: FilterQuality.high,
                                            imageUrl:
                                                controller.bannerList[index],
                                            fit: BoxFit.cover,
                                          ),
                                        );
                                      },
                                      options: CarouselOptions(
                                        enableInfiniteScroll:
                                            controller.bannerList.length == 1
                                                ? false
                                                : true,
                                        height: 167.0,
                                        autoPlay:
                                            controller.bannerList.length == 1
                                                ? false
                                                : true,
                                        autoPlayInterval:
                                            controller.bannerList.length == 1
                                                ? Duration(seconds: 0)
                                                : Duration(seconds: 3),
                                        enlargeCenterPage: true,
                                        viewportFraction: 0.9,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                      top: controller.bannerList.isNotEmpty
                                          ? 24
                                          : MediaQuery.of(context).size.height *
                                              .20,
                                      left: 16,
                                      right: 16,
                                    ),
                                    width: Responsive.width(100, context),
                                    decoration: BoxDecoration(
                                      color: themeChange.getThem()
                                          ? AppThemeData.grey900
                                          : AppThemeData.grey50,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      border: Border.all(
                                        color: themeChange.getThem()
                                            ? AppThemeData.grey700
                                            : AppThemeData.grey200,
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Column(
                                          children: [
                                            InkWell(
                                              onTap: () async {
                                                Get.to(const GoogleMapSearchPlacesApi())!
                                                    .then((value) {
                                                  if (value != null) {
                                                    PlaceDetailsModel
                                                        placeDetailsModel =
                                                        value;
                                                    controller
                                                            .pickUpLocationController
                                                            .value
                                                            .text =
                                                        placeDetailsModel
                                                            .result!
                                                            .formattedAddress
                                                            .toString();
                                                    controller.pickUpLocation
                                                            .value =
                                                        placeDetailsModel
                                                            .result!
                                                            .geometry!
                                                            .location!;
                                                  }
                                                });
                                              },
                                              child: TextFormField(
                                                controller: controller
                                                    .pickUpLocationController
                                                    .value,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: themeChange.getThem()
                                                        ? AppThemeData.grey50
                                                        : AppThemeData.grey900,
                                                    fontFamily:
                                                        AppThemeData.medium),
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText:
                                                      'Enter Pickup Location'
                                                          .tr,
                                                  enabled: false,
                                                  prefixIcon: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            12),
                                                    child: SvgPicture.asset(
                                                        "assets/icons/ic_source.svg"),
                                                  ),
                                                  hintStyle: TextStyle(
                                                    fontSize: 16,
                                                    color: themeChange.getThem()
                                                        ? AppThemeData.grey700
                                                        : AppThemeData.grey700,
                                                    fontFamily:
                                                        AppThemeData.medium,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const Divider(),
                                            InkWell(
                                              onTap: () {
                                                Get.to(const GoogleMapSearchPlacesApi())!
                                                    .then((value) {
                                                  if (value != null) {
                                                    PlaceDetailsModel
                                                        placeDetailsModel =
                                                        value;
                                                    controller
                                                            .dropLocationController
                                                            .value
                                                            .text =
                                                        placeDetailsModel
                                                            .result!
                                                            .formattedAddress
                                                            .toString();
                                                    controller.dropLocation
                                                            .value =
                                                        placeDetailsModel
                                                            .result!
                                                            .geometry!
                                                            .location!;
                                                  }
                                                });
                                              },
                                              child: TextFormField(
                                                controller: controller
                                                    .dropLocationController
                                                    .value,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: themeChange.getThem()
                                                        ? AppThemeData.grey50
                                                        : AppThemeData.grey900,
                                                    fontFamily:
                                                        AppThemeData.medium),
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText:
                                                      'Enter Drop-off Location'
                                                          .tr,
                                                  enabled: false,
                                                  prefixIcon: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            12),
                                                    child: SvgPicture.asset(
                                                        "assets/icons/ic_destination.svg"),
                                                  ),
                                                  hintStyle: TextStyle(
                                                    fontSize: 16,
                                                    color: themeChange.getThem()
                                                        ? AppThemeData.grey700
                                                        : AppThemeData.grey700,
                                                    fontFamily:
                                                        AppThemeData.medium,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const Divider(),
                                            InkWell(
                                              onTap: () {
                                                buildBottomSheet(context);
                                              },
                                              child: TextFormField(
                                                controller: controller
                                                    .personController.value,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: themeChange.getThem()
                                                        ? AppThemeData.grey50
                                                        : AppThemeData.grey900,
                                                    fontFamily:
                                                        AppThemeData.medium),
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: 'Person'.tr,
                                                  enabled: false,
                                                  prefixIcon: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            12),
                                                    child: SvgPicture.asset(
                                                        "assets/icons/ic_user_icon.svg"),
                                                  ),
                                                  hintStyle: TextStyle(
                                                    fontSize: 16,
                                                    color: themeChange.getThem()
                                                        ? AppThemeData.grey700
                                                        : AppThemeData.grey700,
                                                    fontFamily:
                                                        AppThemeData.medium,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const Divider(),
                                            InkWell(
                                              onTap: () async {
                                                await Constant
                                                        .selectFeatureDate(
                                                            context,
                                                            controller
                                                                .selectedDate
                                                                .value)
                                                    .then((value) {
                                                  if (value != null) {
                                                    controller.selectedDate
                                                        .value = value;
                                                    if (Constant
                                                            .dateCustomizationShow(
                                                                controller
                                                                    .selectedDate
                                                                    .value)
                                                        .toString()
                                                        .isNotEmpty) {
                                                      controller.dateController
                                                          .value.text = Constant
                                                              .dateCustomizationShow(
                                                                  controller
                                                                      .selectedDate
                                                                      .value)
                                                          .toString();
                                                    } else {
                                                      controller
                                                          .dateController
                                                          .value
                                                          .text = DateFormat(
                                                              'MMMM dd,yyyy')
                                                          .format(value);
                                                    }
                                                  }
                                                });
                                              },
                                              child: TextFormField(
                                                controller: controller
                                                    .dateController.value,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: themeChange.getThem()
                                                        ? AppThemeData.grey50
                                                        : AppThemeData.grey900,
                                                    fontFamily:
                                                        AppThemeData.medium),
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  enabled: false,
                                                  hintText: 'Select date'.tr,
                                                  prefixIcon: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            12),
                                                    child: SvgPicture.asset(
                                                        "assets/icons/ic_calender.svg"),
                                                  ),
                                                  hintStyle: TextStyle(
                                                    fontSize: 16,
                                                    color: themeChange.getThem()
                                                        ? AppThemeData.grey700
                                                        : AppThemeData.grey700,
                                                    fontFamily:
                                                        AppThemeData.medium,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () async {
                                                if (Constant.verifyBooking ==
                                                    true) {
                                                  if (controller.userModel.value
                                                          .isVerify ==
                                                      true) {
                                                    if (controller
                                                        .pickUpLocationController
                                                        .value
                                                        .text
                                                        .isEmpty) {
                                                      ShowToastDialog.showToast(
                                                          "Please select pickup location"
                                                              .tr);
                                                    } else if (controller
                                                        .dropLocationController
                                                        .value
                                                        .text
                                                        .isEmpty) {
                                                      ShowToastDialog.showToast(
                                                          "Please select pickup location"
                                                              .tr);
                                                    } else {
                                                      controller
                                                          .setSearchHistory();
                                                      controller.searchRide();
                                                    }
                                                  } else {
                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return CustomDialogBox(
                                                            title:
                                                                "Verification Required"
                                                                    .tr,
                                                            descriptions:
                                                                "You need to verify your account to continue. Please complete the verification process to access all features."
                                                                    .tr,
                                                            positiveString:
                                                                "Verify".tr,
                                                            negativeString:
                                                                "Cancel".tr,
                                                            positiveClick:
                                                                () async {
                                                              Get.to(
                                                                  VerificationScreen());
                                                            },
                                                            negativeClick: () {
                                                              Get.back();
                                                            },
                                                            img: Image.asset(
                                                              'assets/images/ic_verify_image.png',
                                                              height: 40,
                                                              width: 40,
                                                            ),
                                                          );
                                                        });
                                                  }
                                                } else {
                                                  if (controller
                                                      .pickUpLocationController
                                                      .value
                                                      .text
                                                      .isEmpty) {
                                                    ShowToastDialog.showToast(
                                                        "Please select pickup location"
                                                            .tr);
                                                  } else if (controller
                                                      .dropLocationController
                                                      .value
                                                      .text
                                                      .isEmpty) {
                                                    ShowToastDialog.showToast(
                                                        "Please select pickup location"
                                                            .tr);
                                                  } else {
                                                    controller
                                                        .setSearchHistory();
                                                    controller.searchRide();
                                                  }
                                                }
                                              },
                                              child: Container(
                                                width: Responsive.width(
                                                    100, context),
                                                decoration: BoxDecoration(
                                                  color:
                                                      AppThemeData.primary300,
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  10),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  10)),
                                                  border: Border.all(
                                                    color: themeChange.getThem()
                                                        ? AppThemeData.grey700
                                                        : AppThemeData.grey200,
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 14),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        "Search Cab".tr,
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color: themeChange
                                                                    .getThem()
                                                                ? AppThemeData
                                                                    .grey50
                                                                : AppThemeData
                                                                    .grey50,
                                                            fontFamily:
                                                                AppThemeData
                                                                    .medium),
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      const Icon(
                                                        Icons
                                                            .arrow_right_alt_sharp,
                                                        color:
                                                            AppThemeData.grey50,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  controller.recentSearch.isEmpty
                                      ? const SizedBox()
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10),
                                              child: Divider(
                                                thickness: 5,
                                                color: themeChange.getThem()
                                                    ? AppThemeData.grey700
                                                    : AppThemeData.grey200,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      "Recent Searches".tr,
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                        color: themeChange
                                                                .getThem()
                                                            ? AppThemeData
                                                                .grey100
                                                            : AppThemeData
                                                                .grey800,
                                                        fontSize: 18,
                                                        fontFamily:
                                                            AppThemeData.medium,
                                                      ),
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      Get.to(const ViewAllSearchScreen())
                                                          ?.then((model) {
                                                        if (model != null) {
                                                          controller
                                                              .setSearchDatatoFields(
                                                            recentSearchModel:
                                                                model[
                                                                    'recentSearchModel'],
                                                            date: model['date'],
                                                          );
                                                        }
                                                      });
                                                    },
                                                    child: Text(
                                                      "View all".tr,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color: themeChange
                                                                .getThem()
                                                            ? AppThemeData
                                                                .grey200
                                                            : AppThemeData
                                                                .grey700,
                                                        fontSize: 14,
                                                        fontFamily:
                                                            AppThemeData.medium,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            ListView.separated(
                                              separatorBuilder: (context,
                                                      index) =>
                                                  const Padding(
                                                      padding: EdgeInsets.only(
                                                          bottom: 10)),
                                              padding: const EdgeInsets.only(
                                                  top: 16),
                                              shrinkWrap: true,
                                              itemCount: controller
                                                          .recentSearch.length >
                                                      10
                                                  ? 10
                                                  : controller
                                                      .recentSearch.length,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemBuilder: (context, index) {
                                                RecentSearchModel
                                                    recentSearchModel =
                                                    controller
                                                        .recentSearch[index];
                                                return Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 16),
                                                  child: InkWell(
                                                      onTap: () {
                                                        if (recentSearchModel
                                                            .bookedDate!
                                                            .toDate()
                                                            .isBefore(DateTime
                                                                    .now()
                                                                .subtract(
                                                                    const Duration(
                                                                        days:
                                                                            1)))) {
                                                          Get.to(const DatepickerScreen(),
                                                                  transition:
                                                                      Transition
                                                                          .downToUp)
                                                              ?.then((date) {
                                                            if (date
                                                                is DateTime) {
                                                              controller.setSearchDatatoFields(
                                                                  recentSearchModel:
                                                                      recentSearchModel,
                                                                  date: date);
                                                            }
                                                          });
                                                        } else {
                                                          controller.setSearchDatatoFields(
                                                              recentSearchModel:
                                                                  recentSearchModel,
                                                              date: recentSearchModel
                                                                  .bookedDate!
                                                                  .toDate());
                                                        }
                                                      },
                                                      child: recentSearchWidget(
                                                          recentSearchModel:
                                                              recentSearchModel,
                                                          themeChange:
                                                              themeChange)),
                                                );
                                              },
                                            )
                                          ],
                                        )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
          floatingActionButton: SizedBox(
            height: 45,
            child: FloatingActionButton.extended(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100)),
              backgroundColor: AppThemeData.primary300,
              onPressed: () async {
                if (Constant.verifyPublish == true) {
                  if (controller.userModel.value.isVerify == true) {
                    controller.getUserProfile().then((user) {
                      ShowToastDialog.closeLoader();
                      if (controller.userModel.value.walletAmount?.isNotEmpty ==
                          true) {
                        if (double.parse(
                                controller.userModel.value.walletAmount ??
                                    "0.0".toString()) <=
                            0.0) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return CustomDialogBox(
                                  title: "InSufficient Wallet Amount".tr,
                                  descriptions:
                                      "You can't publish ride if wallet amount is 0 or less."
                                          .tr,
                                  positiveString: "okay".tr,
                                  negativeString: "",
                                  positiveClick: () async {
                                    Get.back();
                                  },
                                  negativeClick: () {
                                    Get.back();
                                  },
                                  img: Image.asset(
                                    'assets/images/ic_verify_image.png',
                                    height: 40,
                                    width: 40,
                                  ),
                                );
                              });
                        } else {
                          Get.to(const AddYourRideScreen(),
                              transition: Transition.downToUp);
                        }
                      }
                    });
                  } else {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CustomDialogBox(
                            title: "Verification Required".tr,
                            descriptions:
                                "You need to verify your account to continue. Please complete the verification process to access all features."
                                    .tr,
                            positiveString: "Verify".tr,
                            negativeString: "Cancel".tr,
                            positiveClick: () async {
                              Get.to(VerificationScreen());
                            },
                            negativeClick: () {
                              Get.back();
                            },
                            img: Image.asset(
                              'assets/images/ic_verify_image.png',
                              height: 40,
                              width: 40,
                            ),
                          );
                        });
                  }
                } else {
                  controller.getUserProfile().then((user) {
                    ShowToastDialog.closeLoader();
                    if (controller.userModel.value.walletAmount?.isNotEmpty ==
                        true) {
                      if (double.parse(
                              controller.userModel.value.walletAmount ??
                                  "0.0") <=
                          0.0) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CustomDialogBox(
                                title: "InSufficient Wallet Amount".tr,
                                descriptions:
                                    "You can't publish ride if wallet amount is 0 or less."
                                        .tr,
                                positiveString: "okay".tr,
                                negativeString: "cancel".tr,
                                positiveClick: () async {
                                  Get.back();
                                },
                                negativeClick: () {
                                  Get.back();
                                },
                                img: Image.asset(
                                  'assets/images/ic_verify_image.png',
                                  height: 40,
                                  width: 40,
                                ),
                              );
                            });
                      } else {
                        Get.to(const AddYourRideScreen(),
                            transition: Transition.downToUp);
                      }
                    } else {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CustomDialogBox(
                              title: "InSufficient Wallet Amount".tr,
                              descriptions:
                                  "You can't publish ride if wallet amount is 0 or less."
                                      .tr,
                              positiveString: "okay".tr,
                              negativeString: "cancel".tr,
                              positiveClick: () async {
                                Get.back();
                              },
                              negativeClick: () {
                                Get.back();
                              },
                              img: Image.asset(
                                'assets/images/ic_verify_image.png',
                                height: 40,
                                width: 40,
                              ),
                            );
                          });
                    }
                  });
                }
              },
              extendedIconLabelSpacing: 4,
              label: Text(
                "Publish".tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppThemeData.bold,
                  color: themeChange.getThem()
                      ? AppThemeData.grey50
                      : AppThemeData.grey50,
                ),
              ),
              icon: const Icon(
                Icons.add,
                color: AppThemeData.grey50,
              ),
            ),
          ),
        );
      },
    );
  }

  buildBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: true,useSafeArea: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        builder: (context) {
          final themeChange = Provider.of<DarkThemeProvider>(context);
          return GetX(
              init: HomeController(),
              builder: (controller) {
                return SizedBox(
                  height: Responsive.height(34, context),
                  child: Padding(
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
                                  "Select Seats".tr,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
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
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                  onTap: () {
                                    if (controller.numberOfSheet.value > 1) {
                                      controller.numberOfSheet.value -= 1;
                                    }
                                  },
                                  child: Icon(Icons.remove,
                                      color: AppThemeData.primary300)),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "0${controller.numberOfSheet.value}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: themeChange.getThem()
                                      ? AppThemeData.grey100
                                      : AppThemeData.grey800,
                                  fontSize: 62,
                                  fontFamily: AppThemeData.bold,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              InkWell(
                                onTap: () {
                                  if (controller.numberOfSheet.value < 8) {
                                    controller.numberOfSheet.value += 1;
                                  }
                                },
                                child: Icon(
                                  Icons.add,
                                  color: AppThemeData.primary300,
                                ),
                              ),
                            ],
                          ),
                        ),
                        RoundedButtonFill(
                          title: "Confirm Seat".tr,
                          color: AppThemeData.primary300,
                          textColor: AppThemeData.grey50,
                          onPress: () {
                            controller.personController.value.text =
                                controller.numberOfSheet.value.toString();
                            Get.back();
                          },
                        ),
                        const SizedBox(
                          height: 60,
                        ),
                      ],
                    ),
                  ),
                );
              });
        });
  }
}

Widget recentSearchWidget(
    {required RecentSearchModel recentSearchModel,
    required DarkThemeProvider themeChange}) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: ShapeDecoration(
      shape: RoundedRectangleBorder(
        side: BorderSide(
            width: 1,
            color: themeChange.getThem()
                ? AppThemeData.grey700
                : AppThemeData.grey200),
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                '${recentSearchModel.pickUpAddress}',
                maxLines: 1,
                style: TextStyle(
                  color: themeChange.getThem()
                      ? AppThemeData.grey100
                      : AppThemeData.grey800,
                  fontSize: 16,
                  overflow: TextOverflow.ellipsis,
                  fontFamily: AppThemeData.medium,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SvgPicture.asset("assets/icons/ic_right_arrow.svg"),
            ),
            Expanded(
              child: Text(
                '${recentSearchModel.dropAddress}',
                maxLines: 1,
                style: TextStyle(
                  color: themeChange.getThem()
                      ? AppThemeData.grey100
                      : AppThemeData.grey800,
                  fontSize: 16,
                  overflow: TextOverflow.ellipsis,
                  fontFamily: AppThemeData.medium,
                ),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [
              SvgPicture.asset(
                "assets/icons/ic_user_icon.svg",
                width: 20,
                height: 20,
                colorFilter: ColorFilter.mode(
                    themeChange.getThem()
                        ? AppThemeData.grey200
                        : AppThemeData.grey700,
                    BlendMode.srcIn),
              ),
              const SizedBox(width: 5),
              Text(
                recentSearchModel.person?.padLeft(2, '0') ?? '0',
                maxLines: 1,
                style: TextStyle(
                  color: themeChange.getThem()
                      ? AppThemeData.grey200
                      : AppThemeData.grey700,
                  fontSize: 12,
                  overflow: TextOverflow.ellipsis,
                  fontFamily: AppThemeData.regular,
                ),
              ),
            ]),
            Visibility(
              visible: recentSearchModel.bookedDate!
                  .toDate()
                  .isAfter(DateTime.now().subtract(const Duration(days: 1))),
              child: Text(
                Constant.dateCustomizationShow(
                    recentSearchModel.bookedDate!.toDate()),
                maxLines: 1,
                style: TextStyle(
                  color: themeChange.getThem()
                      ? AppThemeData.grey200
                      : AppThemeData.grey700,
                  fontSize: 12,
                  overflow: TextOverflow.ellipsis,
                  fontFamily: AppThemeData.regular,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
