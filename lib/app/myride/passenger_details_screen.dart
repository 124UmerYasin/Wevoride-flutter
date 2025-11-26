import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:wevoride/constant/constant.dart';
import 'package:wevoride/controller/passenger_details_controller.dart';
import 'package:wevoride/model/map/geometry.dart';
import 'package:wevoride/model/tax_model.dart';
import 'package:wevoride/themes/app_them_data.dart';
import 'package:wevoride/themes/responsive.dart';
import 'package:wevoride/utils/dark_theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:timelines_plus/timelines_plus.dart';
import 'package:wevoride/widgets/custom_scaffold.dart';

class PassengerDetailsScreen extends StatelessWidget {
  const PassengerDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: PassengerDetailsController(),
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
                "Passenger Details".tr,
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
            ),
            body: controller.isLoading.value
                ? Constant.loader()
                : SingleChildScrollView(
                    child: Column(
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
                                  color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800,
                                  fontSize: 16,
                                  overflow: TextOverflow.ellipsis,
                                  fontFamily: AppThemeData.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
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
                                      Constant.timestampToDate(controller.bookingModel.value.departureDateTime!),
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
                                      controller.bookingUserModel.value.stopOver!.duration!.text.toString(),
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
                                      "${Constant.distanceCalculate(controller.bookingUserModel.value.stopOver!.distance!.value.toString())} ${Constant.distanceType}",
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
                                      decoration: const ShapeDecoration(
                                        color: Color(0xFFF5F7F8),
                                        shape: OvalBorder(),
                                        shadows: [
                                          BoxShadow(
                                            color: Color(0xFFC1CED6),
                                            blurRadius: 0,
                                            offset: Offset(0, 0),
                                            spreadRadius: 2,
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                  connectorBuilder: (context, index, connectorType) {
                                    return const DashedLineConnector(
                                      color: AppThemeData.grey300,
                                      gap: 2,
                                    );
                                  },
                                  contentsBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                                      child: index == 0
                                          ? Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Constant.getCityName(
                                                    themeChange,
                                                    Location(
                                                        lat: controller.bookingUserModel.value.stopOver!.startLocation!.lat,
                                                        lng: controller.bookingUserModel.value.stopOver!.startLocation!.lng),
                                                    style: TextStyle(
                                                        color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800, fontFamily: AppThemeData.bold, fontSize: 18)),
                                                Text(
                                                  controller.bookingUserModel.value.stopOver!.startAddress.toString(),
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                      color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800, fontFamily: AppThemeData.regular, fontSize: 14),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                      "assets/icons/ic_walk.svg",
                                                      colorFilter: const ColorFilter.mode(AppThemeData.secondary300, BlendMode.srcIn),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      "${Constant.calculateDistance(Location(lat: controller.bookingUserModel.value.stopOver!.startLocation!.lat, lng: controller.bookingUserModel.value.stopOver!.startLocation!.lng), controller.bookingUserModel.value.pickupLocation!).toStringAsFixed(2)} ${Constant.distanceType} from your pickup location",
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                        color: themeChange.getThem() ? AppThemeData.grey200 : AppThemeData.grey700,
                                                        overflow: TextOverflow.ellipsis,
                                                        fontFamily: AppThemeData.regular,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            )
                                          : Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Constant.getCityName(
                                                    themeChange,
                                                    Location(
                                                        lat: controller.bookingUserModel.value.stopOver!.endLocation!.lat,
                                                        lng: controller.bookingUserModel.value.stopOver!.endLocation!.lng),
                                                    style: TextStyle(
                                                        color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800, fontFamily: AppThemeData.bold, fontSize: 18)),
                                                Text(
                                                  controller.bookingUserModel.value.stopOver!.endAddress.toString(),
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                      color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800, fontFamily: AppThemeData.regular, fontSize: 14),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                      "assets/icons/ic_walk.svg",
                                                      colorFilter: const ColorFilter.mode(AppThemeData.success400, BlendMode.srcIn),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      "${Constant.calculateDistance(Location(lat: controller.bookingUserModel.value.stopOver!.endLocation!.lat, lng: controller.bookingUserModel.value.stopOver!.endLocation!.lng), controller.bookingUserModel.value.dropLocation!).toStringAsFixed(2)} ${Constant.distanceType} from your drop location",
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                        color: themeChange.getThem() ? AppThemeData.grey200 : AppThemeData.grey700,
                                                        overflow: TextOverflow.ellipsis,
                                                        fontFamily: AppThemeData.regular,
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
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                child: Divider(),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Seats Booked".tr,
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
                                    "x ${controller.bookingUserModel.value.bookedSeat.toString()}",
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
                                        color: themeChange.getThem() ? AppThemeData.grey200 : AppThemeData.grey700,
                                        fontSize: 16,
                                        overflow: TextOverflow.ellipsis,
                                        fontFamily: AppThemeData.medium,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    Constant.amountShow(amount: controller.bookingUserModel.value.stopOver!.price),
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
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Subtotal".tr,
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
                                    Constant.amountShow(amount: controller.bookingUserModel.value.subTotal),
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
                              const SizedBox(
                                height: 5,
                              ),
                              controller.bookingUserModel.value.taxList == null
                                  ? const SizedBox()
                                  : ListView.builder(
                                      padding: EdgeInsets.zero,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: controller.bookingUserModel.value.taxList!.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        TaxModel taxModel = controller.bookingUserModel.value.taxList![index];
                                        return Column(
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    "${taxModel.title.toString()} (${taxModel.type == "fix" ? Constant.amountShow(amount: taxModel.tax) : "${taxModel.tax}%"})",
                                                    style: TextStyle(
                                                      color: themeChange.getThem() ? AppThemeData.grey200 : AppThemeData.grey700,
                                                      fontSize: 16,
                                                      overflow: TextOverflow.ellipsis,
                                                      fontFamily: AppThemeData.medium,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  "${Constant.amountShow(amount: Constant().calculateTax(amount: controller.bookingUserModel.value.subTotal.toString(), taxModel: taxModel).toStringAsFixed(Constant.currencyModel!.decimalDigits!).toString())} ",
                                                  style: TextStyle(
                                                    color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800,
                                                    fontSize: 16,
                                                    overflow: TextOverflow.ellipsis,
                                                    fontFamily: AppThemeData.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const Divider(
                                              thickness: 1,
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Total".tr,
                                      style: TextStyle(
                                        color: themeChange.getThem() ? AppThemeData.grey200 : AppThemeData.grey700,
                                        fontSize: 16,
                                        overflow: TextOverflow.ellipsis,
                                        fontFamily: AppThemeData.medium,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "${Constant.amountShow(amount: controller.calculateAmount().toString())} ",
                                    style: TextStyle(
                                      color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800,
                                      fontSize: 16,
                                      overflow: TextOverflow.ellipsis,
                                      fontFamily: AppThemeData.bold,
                                    ),
                                  ),
                                ],
                              ),
                              controller.reviewModel.value.id == null
                                  ? const SizedBox()
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      child: Container(
                                        width: Responsive.width(100, context),
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                        decoration: BoxDecoration(
                                            color: themeChange.getThem() ? AppThemeData.grey800 : AppThemeData.grey100, borderRadius: const BorderRadius.all(Radius.circular(10))),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            RatingBar.builder(
                                              initialRating: double.parse(controller.reviewModel.value.rating.toString()),
                                              minRating: 0,
                                              ignoreGestures: true,
                                              direction: Axis.horizontal,
                                              itemCount: 5,
                                              itemSize: 22,
                                              itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                                              itemBuilder: (context, _) => const Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                              onRatingUpdate: (double value) {},
                                            ),
                                            const SizedBox(
                                              height: 12,
                                            ),
                                            Text(
                                              "${controller.reviewModel.value.comment}".tr,
                                              style: TextStyle(
                                                  color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800, fontFamily: AppThemeData.medium, fontSize: 16),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: PreferredSize(
                            preferredSize: const Size.fromHeight(4.0),
                            child: Container(
                              color: themeChange.getThem() ? AppThemeData.grey800 : AppThemeData.grey100,
                              height: 8.0,
                            ),
                          ),
                        ),
                        controller.bookingUserModel.value.adminCommission?.enable == false
                            ? const SizedBox()
                            : Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "Admin commission".tr,
                                            style: TextStyle(
                                              color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900,
                                              fontSize: 16,
                                              overflow: TextOverflow.ellipsis,
                                              fontFamily: AppThemeData.bold,
                                            ),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "(-${Constant.amountShow(amount: Constant.calculateAdminCommission(amount: controller.bookingUserModel.value.subTotal.toString(), adminCommission: controller.bookingUserModel.value.adminCommission).toString())})",
                                              style: TextStyle(
                                                color: themeChange.getThem() ? AppThemeData.warning300 : AppThemeData.warning300,
                                                fontSize: 16,
                                                overflow: TextOverflow.ellipsis,
                                                fontFamily: AppThemeData.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Note : Admin commission will be debited from your wallet balance. \n Admin commission will apply on Ride Amount.".tr,
                                      maxLines: 6,
                                      style: TextStyle(
                                        color: themeChange.getThem() ? AppThemeData.warning300 : AppThemeData.warning300,
                                        overflow: TextOverflow.ellipsis,
                                        fontFamily: AppThemeData.bold,
                                      ),
                                    )
                                  ],
                                ),
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
}
