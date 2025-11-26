import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:wevoride/app/chat/chat_screen.dart';
import 'package:wevoride/app/home_screen/image_view_screen.dart';
import 'package:wevoride/app/home_screen/route_view_screen.dart';
import 'package:wevoride/app/rating_view_screen/rating_view_screen.dart';
import 'package:wevoride/app/wallet_screen/select_payment_method_screen.dart';
import 'package:wevoride/constant/constant.dart';
import 'package:wevoride/constant/show_toast_dialog.dart';
import 'package:wevoride/controller/booking_deatils_controller.dart';
import 'package:wevoride/model/map/geometry.dart';
import 'package:wevoride/themes/app_them_data.dart';
import 'package:wevoride/themes/responsive.dart';
import 'package:wevoride/themes/round_button_fill.dart';
import 'package:wevoride/utils/dark_theme_provider.dart';
import 'package:wevoride/utils/network_image_widget.dart';
import 'package:wevoride/widgets/custom_scaffold.dart';
import 'package:wevoride/widgets/safe_bottom_widget.dart';
import 'package:provider/provider.dart';
import 'package:timelines_plus/timelines_plus.dart';

class BookingDetailsScreen extends StatelessWidget {
  const BookingDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: BookingDetailsController(),
        builder: (controller) {
          return CustomScaffold(
              backgroundColor: themeChange.getThem()
                  ? AppThemeData.grey800
                  : AppThemeData.grey100,
              appBar: AppBar(
                backgroundColor: themeChange.getThem()
                    ? AppThemeData.grey900
                    : AppThemeData.grey50,
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
                title: Text(
                  "Ride Details".tr,
                  style: TextStyle(
                      color: themeChange.getThem()
                          ? AppThemeData.grey100
                          : AppThemeData.grey800,
                      fontFamily: AppThemeData.semiBold,
                      fontSize: 16),
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
              body: controller.isLoading.value
                  ? Constant.loader()
                  : SingleChildScrollView(
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
                                Text(
                                  "Trip info".tr,
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: themeChange.getThem()
                                        ? AppThemeData.grey100
                                        : AppThemeData.grey800,
                                    fontSize: 16,
                                    overflow: TextOverflow.ellipsis,
                                    fontFamily: AppThemeData.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        "assets/icons/ic_calender.svg",
                                        height: 20,
                                        width: 20,
                                        colorFilter: ColorFilter.mode(
                                            themeChange.getThem()
                                                ? AppThemeData.grey200
                                                : AppThemeData.grey700,
                                            BlendMode.srcIn),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        Constant.timestampToDateTime(controller
                                            .bookingModel
                                            .value
                                            .departureDateTime!),
                                        maxLines: 1,
                                        style: TextStyle(
                                          color: themeChange.getThem()
                                              ? AppThemeData.grey200
                                              : AppThemeData.grey700,
                                          fontSize: 16,
                                          overflow: TextOverflow.ellipsis,
                                          fontFamily: AppThemeData.medium,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        "assets/icons/ic_time.svg",
                                        height: 20,
                                        width: 20,
                                        colorFilter: ColorFilter.mode(
                                            themeChange.getThem()
                                                ? AppThemeData.grey200
                                                : AppThemeData.grey700,
                                            BlendMode.srcIn),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        controller
                                            .stopOverModel.value.duration!.text
                                            .toString(),
                                        maxLines: 1,
                                        style: TextStyle(
                                          color: themeChange.getThem()
                                              ? AppThemeData.grey200
                                              : AppThemeData.grey700,
                                          fontSize: 16,
                                          overflow: TextOverflow.ellipsis,
                                          fontFamily: AppThemeData.medium,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        "assets/icons/ic_distance.svg",
                                        height: 20,
                                        width: 20,
                                        colorFilter: ColorFilter.mode(
                                            themeChange.getThem()
                                                ? AppThemeData.grey200
                                                : AppThemeData.grey700,
                                            BlendMode.srcIn),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "${Constant.distanceCalculate(controller.stopOverModel.value.distance!.value.toString())} ${Constant.distanceType}",
                                        maxLines: 1,
                                        style: TextStyle(
                                          color: themeChange.getThem()
                                              ? AppThemeData.grey200
                                              : AppThemeData.grey700,
                                          fontSize: 16,
                                          overflow: TextOverflow.ellipsis,
                                          fontFamily: AppThemeData.medium,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        "assets/icons/ic_luggage.svg",
                                        height: 20,
                                        width: 20,
                                        colorFilter: ColorFilter.mode(
                                            themeChange.getThem()
                                                ? AppThemeData.grey200
                                                : AppThemeData.grey700,
                                            BlendMode.srcIn),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "${controller.bookingModel.value.luggageAllowed!.toString()} luggage",
                                        maxLines: 1,
                                        style: TextStyle(
                                          color: themeChange.getThem()
                                              ? AppThemeData.grey200
                                              : AppThemeData.grey700,
                                          fontSize: 16,
                                          overflow: TextOverflow.ellipsis,
                                          fontFamily: AppThemeData.medium,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                controller.bookingModel.value
                                            .twoPassengerMaxInBack ==
                                        false
                                    ? const SizedBox()
                                    : Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4),
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
                                                color: themeChange.getThem()
                                                    ? AppThemeData.grey200
                                                    : AppThemeData.grey700,
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
                                  theme: TimelineThemeData(
                                    nodePosition: 0,
                                  ),
                                  builder: TimelineTileBuilder.connected(
                                    contentsAlign: ContentsAlign.basic,
                                    indicatorBuilder: (context, index) {
                                      return Container(
                                        width: 8,
                                        height: 8,
                                        decoration: ShapeDecoration(
                                          color: index == 0
                                              ? AppThemeData.warning50
                                              : AppThemeData.success100,
                                          shape: const OvalBorder(),
                                          shadows: [
                                            BoxShadow(
                                              color: index == 0
                                                  ? AppThemeData.warning200
                                                  : AppThemeData.success400,
                                              blurRadius: 0,
                                              offset: const Offset(0, 0),
                                              spreadRadius: 2,
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                    connectorBuilder:
                                        (context, index, connectorType) {
                                      return const DashedLineConnector(
                                        color: AppThemeData.grey300,
                                        gap: 2,
                                      );
                                    },
                                    contentsBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 14, vertical: 14),
                                        child: index == 0
                                            ? Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Constant.getCityName(
                                                      themeChange,
                                                      Location(
                                                          lat: controller
                                                              .stopOverModel
                                                              .value
                                                              .startLocation!
                                                              .lat,
                                                          lng: controller
                                                              .stopOverModel
                                                              .value
                                                              .startLocation!
                                                              .lng),
                                                      style: TextStyle(
                                                          color: themeChange
                                                                  .getThem()
                                                              ? AppThemeData
                                                                  .grey100
                                                              : AppThemeData
                                                                  .grey800,
                                                          fontFamily:
                                                              AppThemeData.bold,
                                                          fontSize: 18)),
                                                  Text(
                                                    controller.stopOverModel
                                                        .value.startAddress
                                                        .toString(),
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                        color: themeChange
                                                                .getThem()
                                                            ? AppThemeData
                                                                .grey100
                                                            : AppThemeData
                                                                .grey800,
                                                        fontFamily: AppThemeData
                                                            .regular,
                                                        fontSize: 14),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    children: [
                                                      SvgPicture.asset(
                                                        "assets/icons/ic_walk.svg",
                                                        colorFilter:
                                                            const ColorFilter
                                                                .mode(
                                                                AppThemeData
                                                                    .secondary300,
                                                                BlendMode
                                                                    .srcIn),
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        "${Constant.calculateDistance(Location(lat: controller.stopOverModel.value.startLocation!.lat, lng: controller.stopOverModel.value.startLocation!.lng), controller.homeController.pickUpLocation.value).toStringAsFixed(2)} ${Constant.distanceType} from your pickup location",
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                          color: themeChange
                                                                  .getThem()
                                                              ? AppThemeData
                                                                  .grey200
                                                              : AppThemeData
                                                                  .grey700,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          fontFamily:
                                                              AppThemeData
                                                                  .regular,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              )
                                            : Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Constant.getCityName(
                                                      themeChange,
                                                      Location(
                                                          lat: controller
                                                              .stopOverModel
                                                              .value
                                                              .endLocation!
                                                              .lat,
                                                          lng: controller
                                                              .stopOverModel
                                                              .value
                                                              .endLocation!
                                                              .lng),
                                                      style: TextStyle(
                                                          color: themeChange
                                                                  .getThem()
                                                              ? AppThemeData
                                                                  .grey100
                                                              : AppThemeData
                                                                  .grey800,
                                                          fontFamily:
                                                              AppThemeData.bold,
                                                          fontSize: 18)),
                                                  Text(
                                                    controller.stopOverModel
                                                        .value.endAddress
                                                        .toString(),
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                        color: themeChange
                                                                .getThem()
                                                            ? AppThemeData
                                                                .grey100
                                                            : AppThemeData
                                                                .grey800,
                                                        fontFamily: AppThemeData
                                                            .regular,
                                                        fontSize: 14),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    children: [
                                                      SvgPicture.asset(
                                                        "assets/icons/ic_walk.svg",
                                                        colorFilter:
                                                            const ColorFilter
                                                                .mode(
                                                                AppThemeData
                                                                    .success400,
                                                                BlendMode
                                                                    .srcIn),
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        "${Constant.calculateDistance(Location(lat: controller.stopOverModel.value.endLocation!.lat, lng: controller.stopOverModel.value.endLocation!.lng), controller.homeController.dropLocation.value).toStringAsFixed(2)} ${Constant.distanceType} from your drop location",
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                          color: themeChange
                                                                  .getThem()
                                                              ? AppThemeData
                                                                  .grey200
                                                              : AppThemeData
                                                                  .grey700,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          fontFamily:
                                                              AppThemeData
                                                                  .regular,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                      );
                                    },
                                    itemCount: 2,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Get.to(const RouteViewScreen(), arguments: {
                                      "bookingModel":
                                          controller.bookingModel.value
                                    });
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Icon(
                                        Icons.map_outlined,
                                        color: AppThemeData.primary300,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "View Route".tr,
                                        maxLines: 1,
                                        style: TextStyle(
                                          color: themeChange.getThem()
                                              ? AppThemeData.primary300
                                              : AppThemeData.primary300,
                                          fontSize: 16,
                                          overflow: TextOverflow.ellipsis,
                                          fontFamily: AppThemeData.bold,
                                        ),
                                      ),
                                    ],
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
                                        "Seats Available".tr,
                                        maxLines: 1,
                                        style: TextStyle(
                                          color: themeChange.getThem()
                                              ? AppThemeData.grey200
                                              : AppThemeData.grey700,
                                          fontSize: 16,
                                          overflow: TextOverflow.ellipsis,
                                          fontFamily: AppThemeData.medium,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "${int.parse(controller.bookingModel.value.totalSeat.toString()) - int.parse(controller.bookingModel.value.bookedSeat.toString())}",
                                      maxLines: 1,
                                      style: TextStyle(
                                        color: themeChange.getThem()
                                            ? AppThemeData.grey100
                                            : AppThemeData.grey800,
                                        fontSize: 16,
                                        overflow: TextOverflow.ellipsis,
                                        fontFamily: AppThemeData.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "Price for one seat".tr,
                                        maxLines: 1,
                                        style: TextStyle(
                                          color: themeChange.getThem()
                                              ? AppThemeData.grey200
                                              : AppThemeData.grey700,
                                          fontSize: 16,
                                          overflow: TextOverflow.ellipsis,
                                          fontFamily: AppThemeData.medium,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      Constant.amountShow(
                                          amount: controller
                                              .stopOverModel.value.price),
                                      maxLines: 1,
                                      style: TextStyle(
                                        color: themeChange.getThem()
                                            ? AppThemeData.grey100
                                            : AppThemeData.grey800,
                                        fontSize: 16,
                                        overflow: TextOverflow.ellipsis,
                                        fontFamily: AppThemeData.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: PreferredSize(
                              preferredSize: const Size.fromHeight(4.0),
                              child: Container(
                                color: themeChange.getThem()
                                    ? AppThemeData.grey800
                                    : AppThemeData.grey100,
                                height: 8.0,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 5),
                            child: Row(
                              children: [
                                Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(60),
                                      child: NetworkImageWidget(
                                        imageUrl: controller
                                            .publisherUserModel.value.profilePic
                                            .toString(),
                                        height: Responsive.width(14, context),
                                        width: Responsive.width(14, context),
                                      ),
                                    ),
                                    Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: SvgPicture.asset(
                                            "assets/icons/ic_verify.svg",
                                            height: 24,
                                            width: 24))
                                  ],
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        controller.publisherUserModel.value
                                            .fullName()
                                            .toString(),
                                        style: TextStyle(
                                            color: themeChange.getThem()
                                                ? AppThemeData.grey100
                                                : AppThemeData.grey800,
                                            fontFamily: AppThemeData.bold,
                                            fontSize: 16),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            Constant.calculateReview(
                                                reviewCount: controller
                                                    .publisherUserModel
                                                    .value
                                                    .reviewCount,
                                                reviewSum: controller
                                                    .publisherUserModel
                                                    .value
                                                    .reviewSum),
                                            style: TextStyle(
                                                color: themeChange.getThem()
                                                    ? AppThemeData.grey200
                                                    : AppThemeData.grey700,
                                                fontFamily: AppThemeData.medium,
                                                fontSize: 14),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Icon(
                                            Icons.star,
                                            size: 14,
                                            color: themeChange.getThem()
                                                ? AppThemeData.grey200
                                                : AppThemeData.grey700,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            "•",
                                            style: TextStyle(
                                                color: themeChange.getThem()
                                                    ? AppThemeData.grey500
                                                    : AppThemeData.grey500,
                                                fontFamily: AppThemeData.medium,
                                                fontSize: 14),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Get.to(const RatingViewScreen(),
                                                  arguments: {
                                                    "receiverUserId": controller
                                                        .publisherUserModel
                                                        .value
                                                        .id
                                                  });
                                            },
                                            child: Text(
                                              "${double.parse(controller.publisherUserModel.value.reviewCount ?? "0").toStringAsFixed(0)} Ratings",
                                              style: TextStyle(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  decorationColor:
                                                      AppThemeData.primary300,
                                                  color: themeChange.getThem()
                                                      ? AppThemeData.primary300
                                                      : AppThemeData.primary300,
                                                  fontFamily:
                                                      AppThemeData.medium,
                                                  fontSize: 14),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                InkWell(
                                  onTap: () async {
                                    await Constant.makePhoneCall(
                                        "${controller.publisherUserModel.value.countryCode.toString()} ${controller.publisherUserModel.value.phoneNumber.toString()}");
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
                                    Get.to(const ChatScreen(), arguments: {
                                      "receiverModel":
                                          controller.publisherUserModel.value
                                    });
                                  },
                                  child: SvgPicture.asset(
                                    "assets/icons/ic_chat.svg",
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  "assets/icons/ic_car.svg",
                                  colorFilter: ColorFilter.mode(
                                      themeChange.getThem()
                                          ? AppThemeData.grey300
                                          : AppThemeData.grey600,
                                      BlendMode.srcIn),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "${controller.bookingModel.value.vehicleInformation!.vehicleBrand!.name} ${controller.bookingModel.value.vehicleInformation!.vehicleModel!.name} (${controller.bookingModel.value.vehicleInformation!.licensePlatNumber})",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: themeChange.getThem()
                                        ? AppThemeData.grey200
                                        : AppThemeData.grey700,
                                    fontFamily: AppThemeData.medium,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          controller.bookingModel.value.travelPreference == null
                              ? const SizedBox()
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 5),
                                      child: Divider(),
                                    ),
                                    controller
                                                    .bookingModel
                                                    .value
                                                    .travelPreference!
                                                    .chattiness ==
                                                null ||
                                            controller
                                                .bookingModel
                                                .value
                                                .travelPreference!
                                                .chattiness!
                                                .isEmpty
                                        ? const SizedBox()
                                        : Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 5),
                                            child: Row(
                                              children: [
                                                controller
                                                            .bookingModel
                                                            .value
                                                            .travelPreference!
                                                            .chattiness ==
                                                        "I’m the quite type"
                                                    ? SvgPicture.asset(
                                                        "assets/icons/ic_love_chat.svg")
                                                    : SvgPicture.asset(
                                                        "assets/icons/ic_quites.svg"),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                    child: Text(
                                                  controller
                                                      .bookingModel
                                                      .value
                                                      .travelPreference!
                                                      .chattiness
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: themeChange.getThem()
                                                        ? AppThemeData.grey50
                                                        : AppThemeData.grey900,
                                                    fontFamily:
                                                        AppThemeData.medium,
                                                  ),
                                                )),
                                              ],
                                            ),
                                          ),
                                    controller
                                                    .bookingModel
                                                    .value
                                                    .travelPreference!
                                                    .smoking ==
                                                null ||
                                            controller
                                                .bookingModel
                                                .value
                                                .travelPreference!
                                                .smoking!
                                                .isEmpty
                                        ? const SizedBox()
                                        : Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 5),
                                            child: Row(
                                              children: [
                                                controller
                                                            .bookingModel
                                                            .value
                                                            .travelPreference!
                                                            .chattiness ==
                                                        "No smoking, Please"
                                                    ? SvgPicture.asset(
                                                        "assets/icons/ic_no_smoking.svg")
                                                    : SvgPicture.asset(
                                                        "assets/icons/ic_smoking.svg"),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                    child: Text(
                                                  controller.bookingModel.value
                                                      .travelPreference!.smoking
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: themeChange.getThem()
                                                        ? AppThemeData.grey50
                                                        : AppThemeData.grey900,
                                                    fontFamily:
                                                        AppThemeData.medium,
                                                  ),
                                                )),
                                              ],
                                            ),
                                          ),
                                    controller.bookingModel.value
                                                    .travelPreference!.music ==
                                                null ||
                                            controller
                                                .bookingModel
                                                .value
                                                .travelPreference!
                                                .music!
                                                .isEmpty
                                        ? const SizedBox()
                                        : Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 5),
                                            child: Row(
                                              children: [
                                                controller
                                                            .bookingModel
                                                            .value
                                                            .travelPreference!
                                                            .music ==
                                                        "Silence is golden"
                                                    ? SvgPicture.asset(
                                                        "assets/icons/ic_no_music.svg")
                                                    : SvgPicture.asset(
                                                        "assets/icons/ic_music.svg"),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                    child: Text(
                                                  controller.bookingModel.value
                                                      .travelPreference!.music
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: themeChange.getThem()
                                                        ? AppThemeData.grey50
                                                        : AppThemeData.grey900,
                                                    fontFamily:
                                                        AppThemeData.medium,
                                                  ),
                                                )),
                                              ],
                                            ),
                                          ),
                                    controller.bookingModel.value
                                                    .travelPreference!.pets ==
                                                null ||
                                            controller.bookingModel.value
                                                .travelPreference!.pets!.isEmpty
                                        ? const SizedBox()
                                        : Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 5),
                                            child: Row(
                                              children: [
                                                SvgPicture.asset(
                                                    "assets/icons/pet.svg"),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                    child: Text(
                                                  controller.bookingModel.value
                                                      .travelPreference!.pets
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: themeChange.getThem()
                                                        ? AppThemeData.grey50
                                                        : AppThemeData.grey900,
                                                    fontFamily:
                                                        AppThemeData.medium,
                                                  ),
                                                )),
                                              ],
                                            ),
                                          ),
                                  ],
                                ),
                          if (controller.bookingModel.value.vehicleInformation!
                                  .vehicleImages ==
                              null)
                            const SizedBox()
                          else
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: SizedBox(
                                height: 100,
                                child: ListView.builder(
                                  itemCount: controller
                                      .bookingModel
                                      .value
                                      .vehicleInformation!
                                      .vehicleImages!
                                      .length,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        Get.to(ImageViewScreen(
                                          imageUrl: controller
                                              .bookingModel
                                              .value
                                              .vehicleInformation!
                                              .vehicleImages![index],
                                        ));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10)),
                                          child: NetworkImageWidget(
                                            imageUrl: controller
                                                .bookingModel
                                                .value
                                                .vehicleInformation!
                                                .vehicleImages![index],
                                            fit: BoxFit.cover,
                                            width: 100,
                                            height: 100.0,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
              bottomNavigationBar: SafeBottomWidget(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    PreferredSize(
                      preferredSize: const Size.fromHeight(4.0),
                      child: Container(
                        color: themeChange.getThem()
                            ? AppThemeData.grey700
                            : AppThemeData.grey200,
                        height: 6.0,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Payment Method".tr,
                                  style: TextStyle(
                                      color: themeChange.getThem()
                                          ? AppThemeData.grey300
                                          : AppThemeData.grey600,
                                      fontFamily: AppThemeData.medium,
                                      fontSize: 12),
                                ),
                                Text(
                                  controller.paymentType.value.isNotEmpty
                                      ? controller.paymentType.value
                                      : "You will be charge after ride",
                                  style: TextStyle(
                                      color: themeChange.getThem()
                                          ? AppThemeData.grey100
                                          : AppThemeData.grey800,
                                      fontFamily: AppThemeData.medium,
                                      fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                              onTap: () {
                                Get.to(const SelectPaymentMethodScreen(),
                                        arguments: {
                                      "type": "bookingSelect",
                                      "amount": ""
                                    })!
                                    .then(
                                  (value) {
                                    if (value != null) {
                                      controller.paymentType.value =
                                          value['paymentType'];
                                    }
                                  },
                                );
                              },
                              child: Icon(Icons.chevron_right_outlined,
                                  color: AppThemeData.primary300))
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: RoundedButtonFill(
                        title: "Confirm Ride".tr,
                        color: AppThemeData.primary300,
                        textColor: AppThemeData.grey50,
                        onPress: () async {
                          if ((int.parse(controller.bookingModel.value.totalSeat
                                      .toString()) -
                                  int.parse(controller
                                      .bookingModel.value.bookedSeat
                                      .toString())) <
                              controller.homeController.numberOfSheet.value) {
                            ShowToastDialog.showToast("Seats not available".tr);
                          } else if (controller.paymentType.value.isEmpty) {
                            ShowToastDialog.showToast(
                                "Please select payment method".tr);
                          } else {
                            bool isWoman =
                                controller.userModel.value.gender == "Ms./Mrs.";
                            if (isWoman &&
                                controller.bookingModel.value.womenOnly ==
                                    true) {
                              controller.bookingPlace();
                            } else if (controller
                                    .bookingModel.value.womenOnly ==
                                false) {
                              controller.bookingPlace();
                            } else {
                              ShowToastDialog.showToast(
                                  "This ride book only for woman");
                            }
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ));
        });
  }
}
