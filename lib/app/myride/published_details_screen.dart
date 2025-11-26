import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:wevoride/app/add_vehicle/add_vehicle_screen.dart';
import 'package:wevoride/app/chat/chat_screen.dart';
import 'package:wevoride/app/myride/passenger_details_screen.dart';
import 'package:wevoride/app/rating_view_screen/rating_view_screen.dart';
import 'package:wevoride/app/report_help_screen/report_help_screen.dart';
import 'package:wevoride/app/review/review_screen.dart';
import 'package:wevoride/constant/constant.dart';
import 'package:wevoride/constant/show_toast_dialog.dart';
import 'package:wevoride/controller/add_your_ride_controller.dart';
import 'package:wevoride/controller/published_details_controller.dart';
import 'package:wevoride/model/booking_model.dart';
import 'package:wevoride/model/map/city_list_model.dart';
import 'package:wevoride/model/review_model.dart';
import 'package:wevoride/model/user_model.dart';
import 'package:wevoride/model/vehicle_information_model.dart';
import 'package:wevoride/themes/app_them_data.dart';
import 'package:wevoride/themes/custom_dialog_box.dart';
import 'package:wevoride/themes/responsive.dart';
import 'package:wevoride/themes/round_button_fill.dart';
import 'package:wevoride/utils/dark_theme_provider.dart';
import 'package:wevoride/utils/fire_store_utils.dart';
import 'package:wevoride/utils/network_image_widget.dart';
import 'package:provider/provider.dart';
import 'package:timelines_plus/timelines_plus.dart';
import 'package:wevoride/widgets/custom_scaffold.dart';

class PublishedDetailsScreen extends StatelessWidget {
  const PublishedDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: PublishedDetailsController(),
        builder: (controller) {
          return CustomScaffold(
            backgroundColor: themeChange.getThem() ? AppThemeData.grey800 : AppThemeData.grey100,
            appBar: AppBar(
              backgroundColor: themeChange.getThem() ? AppThemeData.grey900 : AppThemeData.grey50,
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
              title: Text(
                "Ride Details".tr,
                style: TextStyle(color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800, fontFamily: AppThemeData.semiBold, fontSize: 16),
              ),
              elevation: 0,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(4.0),
                child: Container(
                  color: themeChange.getThem() ? AppThemeData.grey700 : AppThemeData.grey200,
                  height: 4.0,
                ),
              ),
              actions: [
                controller.bookingModel.value.status != Constant.placed
                    ? const SizedBox()
                    : Transform.scale(
                        scale: 0.8,
                        child: CupertinoSwitch(
                          value: controller.bookingModel.value.publish ?? false,
                          onChanged: (value) {
                            if (controller.bookingModel.value.publish == true) {
                              controller.bookingModel.value.publish = false;
                            } else {
                              controller.bookingModel.value.publish = true;
                            }
                            controller.publishRide();
                          },
                        ),
                      ),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Trip info".tr,
                                maxLines: 1,
                                style: TextStyle(
                                  color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800,
                                  fontSize: 16,
                                  overflow: TextOverflow.ellipsis,
                                  fontFamily: AppThemeData.bold,
                                ),
                              ),
                            ),
                            controller.bookingModel.value.status != Constant.placed
                                ? const SizedBox()
                                : InkWell(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return CustomDialogBox(
                                              title: "Delete Ride".tr,
                                              descriptions: "Are you sure want to delete ride?".tr,
                                              positiveString: "OK".tr,
                                              negativeString: "Cancel".tr,
                                              positiveClick: () async {
                                                ShowToastDialog.showLoader("Please wait".tr);
                                                await controller.deleteRide();
                                              },
                                              negativeClick: () {
                                                Get.back();
                                              },
                                              img: Image.asset(
                                                'assets/images/ic_delete.png',
                                                height: 40,
                                                width: 40,
                                              ),
                                            );
                                          });
                                    },
                                    child: const Icon(
                                      Icons.delete,
                                      color: AppThemeData.warning300,
                                    ),
                                  )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CustomDialogBox(
                                    title: "Ride ID".tr,
                                    descriptions: controller.bookingModel.value.id.toString(),
                                    positiveString: "Copied".tr,
                                    negativeString: "Cancel".tr,
                                    positiveClick: () async {
                                      Clipboard.setData(ClipboardData(text: controller.bookingModel.value.id.toString())).then((_) {
                                        ShowToastDialog.showToast("Booking id copied");
                                        Get.back(result: true);
                                      });
                                    },
                                    negativeClick: () {
                                      Get.back();
                                    },
                                    img: null,
                                  );
                                });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  "assets/icons/hashtag.svg",
                                  height: 20,
                                  width: 20,
                                  colorFilter: ColorFilter.mode(themeChange.getThem() ? AppThemeData.grey200 : AppThemeData.grey700, BlendMode.srcIn),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  Constant.orderIdwithoutHash(orderId: controller.bookingModel.value.id.toString()),
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: themeChange.getThem() ? AppThemeData.grey200 : AppThemeData.grey700,
                                    fontSize: 16,
                                    overflow: TextOverflow.ellipsis,
                                    fontFamily: AppThemeData.medium,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                "assets/icons/ic_calender.svg",
                                height: 20,
                                width: 20,
                                colorFilter: ColorFilter.mode(themeChange.getThem() ? AppThemeData.grey200 : AppThemeData.grey700, BlendMode.srcIn),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                Constant.timestampToDateTime(controller.bookingModel.value.departureDateTime!),
                                maxLines: 1,
                                style: TextStyle(
                                  color: themeChange.getThem() ? AppThemeData.grey200 : AppThemeData.grey700,
                                  fontSize: 16,
                                  overflow: TextOverflow.ellipsis,
                                  fontFamily: AppThemeData.medium,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                "assets/icons/ic_time.svg",
                                height: 20,
                                width: 20,
                                colorFilter: ColorFilter.mode(themeChange.getThem() ? AppThemeData.grey200 : AppThemeData.grey700, BlendMode.srcIn),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                controller.bookingModel.value.estimatedTime!.toString(),
                                maxLines: 1,
                                style: TextStyle(
                                  color: themeChange.getThem() ? AppThemeData.grey200 : AppThemeData.grey700,
                                  fontSize: 16,
                                  overflow: TextOverflow.ellipsis,
                                  fontFamily: AppThemeData.medium,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                "assets/icons/ic_distance.svg",
                                height: 20,
                                width: 20,
                                colorFilter: ColorFilter.mode(themeChange.getThem() ? AppThemeData.grey200 : AppThemeData.grey700, BlendMode.srcIn),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "${Constant.distanceCalculate(controller.bookingModel.value.distance!.toString())} ${Constant.distanceType}",
                                maxLines: 1,
                                style: TextStyle(
                                  color: themeChange.getThem() ? AppThemeData.grey200 : AppThemeData.grey700,
                                  fontSize: 16,
                                  overflow: TextOverflow.ellipsis,
                                  fontFamily: AppThemeData.medium,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                "assets/icons/ic_luggage.svg",
                                height: 20,
                                width: 20,
                                colorFilter: ColorFilter.mode(themeChange.getThem() ? AppThemeData.grey200 : AppThemeData.grey700, BlendMode.srcIn),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "${controller.bookingModel.value.luggageAllowed!.toString()} luggage",
                                maxLines: 1,
                                style: TextStyle(
                                  color: themeChange.getThem() ? AppThemeData.grey200 : AppThemeData.grey700,
                                  fontSize: 16,
                                  overflow: TextOverflow.ellipsis,
                                  fontFamily: AppThemeData.medium,
                                ),
                              ),
                            ],
                          ),
                        ),
                        controller.bookingModel.value.twoPassengerMaxInBack == false
                            ? const SizedBox()
                            : Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icons/ic_back_two.svg",
                                      height: 20,
                                      width: 20,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "2 Passengers Max in Back Seat",
                                      maxLines: 1,
                                      style: TextStyle(
                                        color: themeChange.getThem() ? AppThemeData.grey200 : AppThemeData.grey700,
                                        fontSize: 16,
                                        overflow: TextOverflow.ellipsis,
                                        fontFamily: AppThemeData.medium,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: Divider(),
                        ),
                        Timeline.tileBuilder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          theme: TimelineThemeData(
                            nodePosition: 0,
                            // indicatorPosition: 0,
                          ),
                          builder: TimelineTileBuilder.connected(
                            contentsAlign: ContentsAlign.basic,
                            indicatorBuilder: (context, index) {
                              return Container(
                                width: 8,
                                height: 8,
                                decoration: ShapeDecoration(
                                  color: index == 0
                                      ? AppThemeData.warning100
                                      : controller.stopOver.length - 1 == index
                                          ? AppThemeData.success100
                                          : AppThemeData.grey100,
                                  shape: const OvalBorder(),
                                  shadows: [
                                    BoxShadow(
                                      color: index == 0
                                          ? AppThemeData.warning300
                                          : controller.stopOver.length - 1 == index
                                              ? AppThemeData.success400
                                              : AppThemeData.grey300,
                                      blurRadius: 0,
                                      offset: const Offset(0, 0),
                                      spreadRadius: 2,
                                    )
                                  ],
                                ),
                              );
                            },
                            connectorBuilder: (context, index, connectorType) {
                              return const DashedLineConnector(
                                color: AppThemeData.grey300,
                                gap: 4,
                              );
                            },
                            contentsBuilder: (context, index) {
                              CityModel cityModel = controller.stopOver[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Constant.getCityName(themeChange, cityModel.geometry!.location!,
                                          style: index == 0
                                              ? TextStyle(color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800, fontFamily: AppThemeData.bold, fontSize: 14)
                                              : index == controller.stopOver.length - 1
                                                  ? TextStyle(color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800, fontFamily: AppThemeData.bold, fontSize: 14)
                                                  : TextStyle(color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800, fontFamily: AppThemeData.regular, fontSize: 14)),
                                    ),
                                    RoundedButtonFill(
                                      title: index == 0
                                          ? "Start"
                                          : index == controller.stopOver.length - 1
                                              ? "Reached"
                                              : "Arrived".tr,
                                      width: 18,
                                      height: 3.5,
                                      color: cityModel.isArrived == true ? AppThemeData.grey300 : AppThemeData.success400,
                                      textColor: cityModel.isArrived == true ? AppThemeData.grey700 : AppThemeData.grey50,
                                      onPress: () async {
                                        await controller.changeStatus(cityModel, index);
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                            itemCount: controller.stopOver.length,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: Divider(),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Booked Seats".tr,
                                maxLines: 1,
                                style: TextStyle(
                                  color: themeChange.getThem() ? AppThemeData.grey200 : AppThemeData.grey700,
                                  fontSize: 16,
                                  overflow: TextOverflow.ellipsis,
                                  fontFamily: AppThemeData.medium,
                                ),
                              ),
                            ),
                            Text(
                              "${controller.bookingModel.value.bookedSeat}",
                              maxLines: 1,
                              style: TextStyle(
                                color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800,
                                fontSize: 16,
                                overflow: TextOverflow.ellipsis,
                                fontFamily: AppThemeData.bold,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Total Amount".tr,
                                maxLines: 1,
                                style: TextStyle(
                                  color: themeChange.getThem() ? AppThemeData.grey200 : AppThemeData.grey700,
                                  fontSize: 16,
                                  overflow: TextOverflow.ellipsis,
                                  fontFamily: AppThemeData.medium,
                                ),
                              ),
                            ),
                            Text(
                              Constant.amountShow(amount: controller.bookingModel.value.pricePerSeat),
                              maxLines: 1,
                              style: TextStyle(
                                color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800,
                                fontSize: 16,
                                overflow: TextOverflow.ellipsis,
                                fontFamily: AppThemeData.bold,
                              ),
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: Divider(),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(60),
                              child: NetworkImageWidget(
                                imageUrl: controller.publisherUserModel.value.profilePic.toString(),
                                height: Responsive.width(14, context),
                                width: Responsive.width(14, context),
                              ),
                            ),
                            Positioned(bottom: 0, right: 0, child: SvgPicture.asset("assets/icons/ic_verify.svg", height: 24, width: 24))
                          ],
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.publisherUserModel.value.fullName().toString(),
                              style: TextStyle(color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800, fontFamily: AppThemeData.bold, fontSize: 16),
                            ),
                            Row(
                              children: [
                                Text(
                                  Constant.calculateReview(reviewCount: controller.publisherUserModel.value.reviewCount, reviewSum: controller.publisherUserModel.value.reviewSum),
                                  style: TextStyle(color: themeChange.getThem() ? AppThemeData.grey200 : AppThemeData.grey700, fontFamily: AppThemeData.medium, fontSize: 14),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons.star,
                                  size: 14,
                                  color: themeChange.getThem() ? AppThemeData.grey200 : AppThemeData.grey700,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "•",
                                  style: TextStyle(color: themeChange.getThem() ? AppThemeData.grey500 : AppThemeData.grey500, fontFamily: AppThemeData.medium, fontSize: 14),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                InkWell(
                                  onTap: () {
                                    Get.to(const RatingViewScreen(), arguments: {"receiverUserId": controller.publisherUserModel.value.id});
                                  },
                                  child: Text(
                                    "${double.parse(controller.publisherUserModel.value.reviewCount ?? "0").toStringAsFixed(0)} Ratings",
                                    style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        decorationColor: AppThemeData.primary300,
                                        color: themeChange.getThem() ? AppThemeData.primary300 : AppThemeData.primary300,
                                        fontFamily: AppThemeData.medium,
                                        fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                "assets/icons/ic_car.svg",
                                colorFilter: ColorFilter.mode(themeChange.getThem() ? AppThemeData.grey300 : AppThemeData.grey600, BlendMode.srcIn),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "${controller.bookingModel.value.vehicleInformation!.vehicleBrand!.name} ${controller.bookingModel.value.vehicleInformation!.vehicleModel!.name} (${controller.bookingModel.value.vehicleInformation!.licensePlatNumber})",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: themeChange.getThem() ? AppThemeData.grey200 : AppThemeData.grey700,
                                  fontFamily: AppThemeData.medium,
                                ),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            addVehicleBuildBottomSheet(context, controller);
                          },
                          child: Text(
                            "Change",
                            style: TextStyle(
                              fontSize: 14,
                              color: themeChange.getThem() ? AppThemeData.primary300 : AppThemeData.primary300,
                              fontFamily: AppThemeData.medium,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  controller.bookingModel.value.travelPreference == null
                      ? const SizedBox()
                      : Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                              child: Divider(),
                            ),
                            controller.bookingModel.value.travelPreference!.chattiness == null || controller.bookingModel.value.travelPreference!.chattiness!.isEmpty
                                ? const SizedBox()
                                : Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                                    child: Row(
                                      children: [
                                        controller.bookingModel.value.travelPreference!.chattiness == "I’m the quite type"
                                            ? SvgPicture.asset("assets/icons/ic_love_chat.svg")
                                            : SvgPicture.asset("assets/icons/ic_quites.svg"),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                            child: Text(
                                          controller.bookingModel.value.travelPreference!.chattiness.toString(),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900,
                                            fontFamily: AppThemeData.medium,
                                          ),
                                        )),
                                      ],
                                    ),
                                  ),
                            controller.bookingModel.value.travelPreference!.smoking == null || controller.bookingModel.value.travelPreference!.smoking!.isEmpty
                                ? const SizedBox()
                                : Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                                    child: Row(
                                      children: [
                                        controller.bookingModel.value.travelPreference!.chattiness == "No smoking, Please"
                                            ? SvgPicture.asset("assets/icons/ic_no_smoking.svg")
                                            : SvgPicture.asset("assets/icons/ic_smoking.svg"),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                            child: Text(
                                          controller.bookingModel.value.travelPreference!.smoking.toString(),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900,
                                            fontFamily: AppThemeData.medium,
                                          ),
                                        )),
                                      ],
                                    ),
                                  ),
                            controller.bookingModel.value.travelPreference!.music == null || controller.bookingModel.value.travelPreference!.music!.isEmpty
                                ? const SizedBox()
                                : Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                                    child: Row(
                                      children: [
                                        controller.bookingModel.value.travelPreference!.music == "Silence is golden"
                                            ? SvgPicture.asset("assets/icons/ic_no_music.svg")
                                            : SvgPicture.asset("assets/icons/ic_music.svg"),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                            child: Text(
                                          controller.bookingModel.value.travelPreference!.music.toString(),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900,
                                            fontFamily: AppThemeData.medium,
                                          ),
                                        )),
                                      ],
                                    ),
                                  ),
                            controller.bookingModel.value.travelPreference!.pets == null || controller.bookingModel.value.travelPreference!.pets!.isEmpty
                                ? const SizedBox()
                                : Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset("assets/icons/pet.svg"),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                            child: Text(
                                          controller.bookingModel.value.travelPreference!.pets.toString(),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900,
                                            fontFamily: AppThemeData.medium,
                                          ),
                                        )),
                                      ],
                                    ),
                                  ),
                          ],
                        ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Divider(),
                  ),
                  controller.bookingUserList.isEmpty
                      ? const SizedBox()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                "Passengers".tr,
                                maxLines: 1,
                                style: TextStyle(
                                  color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800,
                                  fontSize: 16,
                                  overflow: TextOverflow.ellipsis,
                                  fontFamily: AppThemeData.bold,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: controller.bookingUserList.length,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                BookedUserModel bookingUserModel = controller.bookingUserList[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                                  child: FutureBuilder<UserModel?>(
                                      future: FireStoreUtils.getUserProfile(bookingUserModel.id.toString()),
                                      builder: (context, snapshot) {
                                        switch (snapshot.connectionState) {
                                          case ConnectionState.waiting:
                                            return Constant.loader();
                                          case ConnectionState.done:
                                            if (snapshot.hasError) {
                                              return Text(snapshot.error.toString());
                                            } else if (snapshot.data == null) {
                                              return const SizedBox();
                                            } else {
                                              UserModel? userModel = snapshot.data;
                                              return Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius: BorderRadius.circular(60),
                                                        child: NetworkImageWidget(
                                                          imageUrl: userModel!.profilePic.toString(),
                                                          height: Responsive.width(14, context),
                                                          width: Responsive.width(14, context),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            SingleChildScrollView(
                                                              scrollDirection: Axis.horizontal,
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                    userModel.fullName().toString(),
                                                                    style: TextStyle(
                                                                        color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800, fontFamily: AppThemeData.bold, fontSize: 16),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 5,
                                                                  ),
                                                                  Text(
                                                                    Constant.calculateReview(reviewCount: userModel.reviewCount, reviewSum: userModel.reviewSum),
                                                                    style: TextStyle(
                                                                        color: themeChange.getThem() ? AppThemeData.grey200 : AppThemeData.grey700, fontFamily: AppThemeData.medium, fontSize: 14),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 5,
                                                                  ),
                                                                  Icon(
                                                                    Icons.star,
                                                                    size: 14,
                                                                    color: themeChange.getThem() ? AppThemeData.grey200 : AppThemeData.grey700,
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 5,
                                                                  ),
                                                                  Text(
                                                                    "•",
                                                                    style: TextStyle(
                                                                        color: themeChange.getThem() ? AppThemeData.grey500 : AppThemeData.grey500, fontFamily: AppThemeData.medium, fontSize: 14),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 5,
                                                                  ),
                                                                  InkWell(
                                                                    onTap: () {
                                                                      Get.to(const RatingViewScreen(), arguments: {"receiverUserId": userModel.id});
                                                                    },
                                                                    child: Text(
                                                                      "${double.parse(userModel.reviewCount ?? "0").toStringAsFixed(0)} Ratings",
                                                                      style: TextStyle(
                                                                          decoration: TextDecoration.underline,
                                                                          decorationColor: AppThemeData.primary300,
                                                                          color: themeChange.getThem() ? AppThemeData.primary300 : AppThemeData.primary300,
                                                                          fontFamily: AppThemeData.medium,
                                                                          fontSize: 14),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Row(children: [
                                                              Text(
                                                                bookingUserModel.paymentStatus == true ? "Paid" : "UnPaid",
                                                                style: TextStyle(
                                                                    color: bookingUserModel.paymentStatus == true ? AppThemeData.success400 : AppThemeData.warning300,
                                                                    fontFamily: AppThemeData.medium,
                                                                    fontSize: 14),
                                                              ),
                                                              Text(
                                                                " (${bookingUserModel.paymentType})",
                                                                style:
                                                                    TextStyle(color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800, fontFamily: AppThemeData.bold, fontSize: 14),
                                                              ),
                                                            ]),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      InkWell(
                                                        onTap: () async {
                                                          print("===>0");
                                                          await Constant.makePhoneCall("${userModel.countryCode.toString()} ${userModel.phoneNumber.toString()}");
                                                        },
                                                        child: SvgPicture.asset(
                                                          "assets/icons/ic_call.svg",
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          Get.to(const ChatScreen(), arguments: {"receiverModel": userModel});
                                                        },
                                                        child: SvgPicture.asset(
                                                          "assets/icons/ic_chat.svg",
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      RoundedButtonFill(
                                                        title: "Report".tr,
                                                        color: AppThemeData.warning300,
                                                        width: 26,
                                                        height: 4,
                                                        fontSizes: 12,
                                                        textColor: AppThemeData.grey50,
                                                        onPress: () {
                                                          Get.to(const ReportHelpScreen(),
                                                              arguments: {"reportedBy": "publisher", "reportedTo": userModel.id, "bookingId": controller.bookingModel.value.id});
                                                        },
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      RoundedButtonFill(
                                                        title: "View Details".tr,
                                                        color: AppThemeData.primary300,
                                                        width: 26,
                                                        height: 4,
                                                        fontSizes: 12,
                                                        textColor: AppThemeData.grey50,
                                                        onPress: () {
                                                          Get.to(const PassengerDetailsScreen(), arguments: {"bookingModel": controller.bookingModel.value, "bookingUserModel": bookingUserModel});
                                                        },
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      if (bookingUserModel.paymentStatus == true)
                                                        FutureBuilder<ReviewModel?>(
                                                            future: FireStoreUtils.getReviewByReceiverId(bookingId: controller.bookingModel.value.id ?? '', receiverId: userModel.id ?? ''),
                                                            builder: (context, snapshot) {
                                                              switch (snapshot.connectionState) {
                                                                case ConnectionState.waiting:
                                                                  return const SizedBox();
                                                                case ConnectionState.done:
                                                                  if (snapshot.hasError) {
                                                                    return Text(snapshot.error.toString());
                                                                  } else if (snapshot.data == null) {
                                                                    return RoundedButtonFill(
                                                                      title: "Add Review".tr,
                                                                      color: AppThemeData.primary300,
                                                                      width: 26,
                                                                      height: 4,
                                                                      fontSizes: 12,
                                                                      textColor: AppThemeData.grey50,
                                                                      onPress: () {
                                                                        Get.to(() => const ReviewScreen(), arguments: {
                                                                          "bookingModel": controller.bookingModel.value,
                                                                          "senderUserModel": controller.publisherUserModel.value,
                                                                          "reciverUserModel": userModel
                                                                        })!
                                                                            .then(
                                                                          (value) {
                                                                            if (value == true) {
                                                                              controller.getUserData();
                                                                              controller.getReview();
                                                                            }
                                                                          },
                                                                        );
                                                                      },
                                                                    );
                                                                  } else {
                                                                    ReviewModel? reviewModel = snapshot.data;
                                                                    return RoundedButtonFill(
                                                                      title: reviewModel?.id == null ? "Add Review".tr : "Edit Review".tr,
                                                                      color: AppThemeData.primary300,
                                                                      width: 26,
                                                                      height: 4,
                                                                      fontSizes: 12,
                                                                      textColor: AppThemeData.grey50,
                                                                      onPress: () {
                                                                        Get.to(() => const ReviewScreen(), arguments: {
                                                                          "bookingModel": controller.bookingModel.value,
                                                                          "senderUserModel": controller.publisherUserModel.value,
                                                                          "reciverUserModel": userModel
                                                                        })!
                                                                            .then(
                                                                          (value) {
                                                                            if (value == true) {
                                                                              controller.getUserData();
                                                                              controller.getReview();
                                                                            }
                                                                          },
                                                                        );
                                                                      },
                                                                    );
                                                                  }
                                                                case ConnectionState.none:
                                                                  return SizedBox();
                                                                case ConnectionState.active:
                                                                  return const SizedBox();
                                                              }
                                                            }),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  const Divider(),
                                                ],
                                              );
                                            }
                                          default:
                                            return Text('Error'.tr);
                                        }
                                      }),
                                );
                              },
                            ),
                          ],
                        ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          );
        });
  }

  addVehicleBuildBottomSheet(BuildContext context, PublishedDetailsController publishedDetailsController) {
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
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: Text(
                                "Select a vehicle".tr,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 16, fontFamily: AppThemeData.bold),
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
                      ListView.builder(
                        controller: scrollController,
                        itemCount: controller.userVehicleList.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          VehicleInformationModel vehicleInformationModel = controller.userVehicleList[index];
                          return Obx(
                            () => InkWell(
                              onTap: () {
                                controller.selectedUserVehicle.value = vehicleInformationModel;
                              },
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "${vehicleInformationModel.vehicleBrand!.name} ${vehicleInformationModel.vehicleModel!.name} (${vehicleInformationModel.licensePlatNumber})".tr,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(fontSize: 16, color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800, fontFamily: AppThemeData.medium),
                                        ),
                                      ),
                                      Radio(
                                        value: vehicleInformationModel,
                                        groupValue: controller.selectedUserVehicle.value,
                                        activeColor: AppThemeData.primary300,
                                        onChanged: (value) {
                                          controller.selectedUserVehicle.value = value!;
                                        },
                                      ),
                                    ],
                                  ),
                                  const Divider(),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () async {
                          log("CLICK::4");
                          await Get.to(const AddVehicleScreen())?.then((value) {
                            if (value != null) {
                              controller.getVehicleInformation();
                            }
                          });
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.add,
                              color: AppThemeData.primary300,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Add new vehicle".tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: AppThemeData.primary300,
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      RoundedButtonFill(
                        title: "Change".tr,
                        color: AppThemeData.primary300,
                        textColor: AppThemeData.grey50,
                        onPress: () async {
                          ShowToastDialog.showLoader("Please wait");
                          publishedDetailsController.bookingModel.value.vehicleInformation = controller.selectedUserVehicle.value;
                          await FireStoreUtils.setBooking(publishedDetailsController.bookingModel.value).then(
                            (value) {
                              ShowToastDialog.closeLoader();
                            },
                          );
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
