import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:wevoride/app/home_screen/booking_details_screen.dart';
import 'package:wevoride/app/rating_view_screen/rating_view_screen.dart';
import 'package:wevoride/constant/constant.dart';
import 'package:wevoride/controller/home_controller.dart';
import 'package:wevoride/model/booking_model.dart';
import 'package:wevoride/model/map/geometry.dart';
import 'package:wevoride/model/stop_over_model.dart';
import 'package:wevoride/model/user_model.dart';
import 'package:wevoride/themes/app_them_data.dart';
import 'package:wevoride/themes/responsive.dart';
import 'package:wevoride/themes/round_button_fill.dart';
import 'package:wevoride/utils/dark_theme_provider.dart';
import 'package:wevoride/utils/fire_store_utils.dart';
import 'package:wevoride/utils/network_image_widget.dart';
import 'package:wevoride/widgets/custom_scaffold.dart';
import 'package:wevoride/widgets/safe_bottom_widget.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: HomeController(),
        builder: (controller) {
          return CustomScaffold(
            backgroundColor: themeChange.getThem() ? AppThemeData.grey800 : AppThemeData.grey100,
            appBar: AppBar(
              backgroundColor: themeChange.getThem() ? AppThemeData.primary300 : AppThemeData.primary300,
              centerTitle: false,
              titleSpacing: 0,
              leading: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(
                    Icons.chevron_left_outlined,
                    color: Colors.white,
                  )),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          controller.pickUpLocationController.value.text,
                          maxLines: 1,
                          style: TextStyle(
                            color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey50,
                            fontSize: 16,
                            overflow: TextOverflow.ellipsis,
                            fontFamily: AppThemeData.medium,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: SvgPicture.asset(
                          "assets/icons/ic_right_arrow.svg",
                          colorFilter: const ColorFilter.mode(AppThemeData.grey50, BlendMode.srcIn),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          controller.dropLocationController.value.text,
                          maxLines: 1,
                          style: TextStyle(
                            color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey50,
                            fontSize: 16,
                            overflow: TextOverflow.ellipsis,
                            fontFamily: AppThemeData.medium,
                          ),
                        ),
                      )
                    ],
                  ),
                  Text(
                    controller.dateController.value.text,
                    maxLines: 1,
                    style: TextStyle(
                      color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey50,
                      fontSize: 12,
                      overflow: TextOverflow.ellipsis,
                      fontFamily: AppThemeData.medium,
                    ),
                  )
                ],
              ),
              elevation: 0,
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Showing ${controller.searchedBookingList.length} Rides",
                    maxLines: 1,
                    style: TextStyle(
                      color: themeChange.getThem() ? AppThemeData.grey300 : AppThemeData.grey600,
                      fontSize: 16,
                      overflow: TextOverflow.ellipsis,
                      fontFamily: AppThemeData.medium,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: controller.searchedBookingList.length,
                      itemBuilder: (context, index) {
                        BookingModel bookingModel = controller.searchedBookingList[index];

                        return FutureBuilder<StopOverModel?>(
                            future: controller.getPrice(bookingModel),
                            builder: (context, snapshot) {
                              switch (snapshot.connectionState) {
                                case ConnectionState.waiting:
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 60),
                                    child: Constant.loader(),
                                  );
                                case ConnectionState.done:
                                  if (snapshot.hasError) {
                                    return Text(snapshot.error.toString());
                                  } else if (snapshot.data == null) {
                                    return SizedBox();
                                  } else {
                                    StopOverModel stopOverModel = snapshot.data!;
                                    print("Price==>${stopOverModel.price}");
                                    return InkWell(
                                      onTap: () {
                                        Get.to(const BookingDetailsScreen(), arguments: {"bookingModel": bookingModel, "stopOverModel": stopOverModel});
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 5),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: themeChange.getThem() ? AppThemeData.grey900 : AppThemeData.grey50,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(20),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: RichText(
                                                        text: TextSpan(
                                                          style: Theme.of(context).textTheme.bodyLarge,
                                                          children: [
                                                            WidgetSpan(
                                                                child: Constant.getCityName(
                                                                    themeChange, Location(lat: stopOverModel.startLocation!.lat, lng: stopOverModel.startLocation!.lng))),
                                                            WidgetSpan(
                                                              child: Padding(
                                                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                                                child: SvgPicture.asset("assets/icons/ic_right_arrow.svg"),
                                                              ),
                                                            ),
                                                            WidgetSpan(
                                                                child: Constant.getCityName(
                                                                    themeChange, Location(lat: stopOverModel.endLocation!.lat, lng: stopOverModel.endLocation!.lng)))
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      Constant.amountShow(amount: stopOverModel.price),
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
                                                Text(
                                                  Constant.timestampToDateTime(bookingModel.departureDateTime!),
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                    color: themeChange.getThem() ? AppThemeData.grey200 : AppThemeData.grey700,
                                                    fontSize: 12,
                                                    overflow: TextOverflow.ellipsis,
                                                    fontFamily: AppThemeData.regular,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                      "assets/icons/ic_walk.svg",
                                                      colorFilter: const ColorFilter.mode(AppThemeData.secondary300, BlendMode.srcIn),
                                                    ),
                                                    Text(
                                                      "${Constant.calculateDistance(Location(lat: stopOverModel.startLocation!.lat, lng: stopOverModel.startLocation!.lng), controller.pickUpLocation.value).toStringAsFixed(2)} ${Constant.distanceType}",
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                        color: themeChange.getThem() ? AppThemeData.grey200 : AppThemeData.grey700,
                                                        overflow: TextOverflow.ellipsis,
                                                        fontFamily: AppThemeData.regular,
                                                      ),
                                                    ),
                                                    const Icon(
                                                      Icons.chevron_right_outlined,
                                                      color: AppThemeData.grey700,
                                                    ),
                                                    SvgPicture.asset(
                                                      "assets/icons/ic_car.svg",
                                                      colorFilter: ColorFilter.mode(themeChange.getThem() ? AppThemeData.grey300 : AppThemeData.grey600, BlendMode.srcIn),
                                                    ),
                                                    const Icon(
                                                      Icons.chevron_right_outlined,
                                                      color: AppThemeData.grey700,
                                                    ),
                                                    SvgPicture.asset(
                                                      "assets/icons/ic_walk.svg",
                                                      colorFilter: const ColorFilter.mode(AppThemeData.success400, BlendMode.srcIn),
                                                    ),
                                                    Text(
                                                      "${Constant.calculateDistance(Location(lat: stopOverModel.endLocation!.lat, lng: stopOverModel.endLocation!.lng), controller.dropLocation.value).toStringAsFixed(2)} ${Constant.distanceType}",
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                        color: themeChange.getThem() ? AppThemeData.grey200 : AppThemeData.grey700,
                                                        overflow: TextOverflow.ellipsis,
                                                        fontFamily: AppThemeData.regular,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const Padding(
                                                  padding: EdgeInsets.symmetric(vertical: 10),
                                                  child: Divider(),
                                                ),
                                                FutureBuilder<UserModel?>(
                                                    future: FireStoreUtils.getUserProfile(bookingModel.createdBy.toString()),
                                                    builder: (context, snapshot) {
                                                      switch (snapshot.connectionState) {
                                                        case ConnectionState.waiting:
                                                          return Constant.loader();
                                                        case ConnectionState.done:
                                                          if (snapshot.hasError) {
                                                            return Text(snapshot.error.toString());
                                                          } else {
                                                            UserModel? userModel = snapshot.data;
                                                            return userModel?.id == null
                                                                ? Padding(
                                                                    padding: const EdgeInsets.symmetric(vertical: 4),
                                                                    child: Center(
                                                                      child: Text(
                                                                        'Driver is not available'.tr,
                                                                        style: TextStyle(
                                                                          color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800,
                                                                          fontFamily: AppThemeData.medium,
                                                                          fontSize: 16,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )
                                                                : Row(
                                                                    children: [
                                                                      Stack(
                                                                        children: [
                                                                          ClipRRect(
                                                                            borderRadius: BorderRadius.circular(60),
                                                                            child: NetworkImageWidget(
                                                                              fit: BoxFit.cover,
                                                                              imageUrl: userModel!.profilePic.toString(),
                                                                              height: Responsive.width(10, context),
                                                                              width: Responsive.width(10, context),
                                                                            ),
                                                                          ),
                                                                          bookingModel.driverVerify == true
                                                                              ? Positioned(bottom: 0, right: 0, child: SvgPicture.asset("assets/icons/ic_verify.svg"))
                                                                              : const SizedBox()
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        width: 10,
                                                                      ),
                                                                      Expanded(
                                                                        child: Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              userModel.fullName().toString(),
                                                                              style: TextStyle(
                                                                                  color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800,
                                                                                  fontFamily: AppThemeData.medium,
                                                                                  fontSize: 16),
                                                                            ),
                                                                            Row(
                                                                              children: [
                                                                                Text(
                                                                                  Constant.calculateReview(reviewCount: userModel.reviewCount, reviewSum: userModel.reviewSum),
                                                                                  style: TextStyle(
                                                                                      color: themeChange.getThem() ? AppThemeData.grey200 : AppThemeData.grey700,
                                                                                      fontFamily: AppThemeData.medium,
                                                                                      fontSize: 14),
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
                                                                                      color: themeChange.getThem() ? AppThemeData.grey500 : AppThemeData.grey500,
                                                                                      fontFamily: AppThemeData.medium,
                                                                                      fontSize: 14),
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
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      bookingModel.driverVerify == true
                                                                          ? RoundedButtonFill(
                                                                              title: "Safe",
                                                                              color: AppThemeData.info400,
                                                                              textColor: AppThemeData.grey50,
                                                                              width: 14,
                                                                              height: 4,
                                                                              onPress: () {},
                                                                            )
                                                                          : const SizedBox(),
                                                                      const SizedBox(
                                                                        width: 5,
                                                                      ),
                                                                      bookingModel.womenOnly == false
                                                                          ? const SizedBox()
                                                                          : SvgPicture.asset(
                                                                              "assets/icons/ic_woman_icon.svg",
                                                                              colorFilter: ColorFilter.mode(themeChange.getThem() ? Colors.pink : Colors.pink, BlendMode.srcIn),
                                                                            ),
                                                                      const SizedBox(
                                                                        width: 10,
                                                                      ),
                                                                      SvgPicture.asset(
                                                                        "assets/icons/ic_luggage.svg",
                                                                        colorFilter:
                                                                            ColorFilter.mode(themeChange.getThem() ? AppThemeData.grey300 : AppThemeData.grey600, BlendMode.srcIn),
                                                                      )
                                                                    ],
                                                                  );
                                                          }
                                                        default:
                                                          return Text('Error'.tr);
                                                      }
                                                    })
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                default:
                                  return SizedBox();
                              }
                            });
                      },
                    ),
                  )
                ],
              ),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            floatingActionButton: FloatingActionButton.extended(
              isExtended: true,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
              backgroundColor: AppThemeData.primary300,
              onPressed: () async {
                filterBuildBottomSheet(themeChange, context);
              },
              icon: const Icon(Icons.filter_alt_sharp, color: AppThemeData.grey50),
              label: const Text(
                'Filters',
                style: TextStyle(color: AppThemeData.grey50),
              ),
            ),
          );
        });
  }

  filterBuildBottomSheet(themeChange, BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.90,
        minChildSize: 0.50,
        maxChildSize: 0.90,
        expand: false,
        builder: (context, scrollController) {
          final themeChange = Provider.of<DarkThemeProvider>(context);
          return GetX(
              init: HomeController(),
              builder: (controller) {
                return CustomScaffold(
                    body: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 15),
                                    child: Text(
                                      "Filters".tr,
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
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Divider(),
                            ),
                            Text(
                              "Departure time".tr,
                              style: TextStyle(color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800, fontFamily: AppThemeData.bold, fontSize: 16),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: controller.departureTime.length,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Obx(
                                  () => Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          controller.departureTime[index].title,
                                          style:
                                              TextStyle(color: themeChange.getThem() ? AppThemeData.grey200 : AppThemeData.grey700, fontFamily: AppThemeData.medium, fontSize: 14),
                                        ),
                                      ),
                                      Checkbox(
                                        visualDensity: VisualDensity.compact,
                                        activeColor: AppThemeData.primary300,
                                        value: controller.selectedDepartureTime.contains(controller.departureTime[index]),
                                        onChanged: (val) {
                                          if (controller.selectedDepartureTime.contains(controller.departureTime[index])) {
                                            controller.selectedDepartureTime.remove(controller.departureTime[index]);
                                          } else {
                                            controller.selectedDepartureTime.add(controller.departureTime[index]);
                                          }
                                        },
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Divider(),
                            ),
                            Text(
                              "Driver Preferences".tr,
                              style: TextStyle(color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800, fontFamily: AppThemeData.bold, fontSize: 16),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Verify Drivers".tr,
                                    style: TextStyle(color: themeChange.getThem() ? AppThemeData.grey200 : AppThemeData.grey700, fontFamily: AppThemeData.medium, fontSize: 14),
                                  ),
                                ),
                                Transform.scale(
                                  scale: 0.8,
                                  child: CupertinoSwitch(
                                    value: controller.verifyDriver.value,
                                    activeColor: AppThemeData.primary300,
                                    onChanged: (value) {
                                      controller.verifyDriver.value = value;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Woman only".tr,
                                    style: TextStyle(color: themeChange.getThem() ? AppThemeData.grey200 : AppThemeData.grey700, fontFamily: AppThemeData.medium, fontSize: 14),
                                  ),
                                ),
                                Transform.scale(
                                  scale: 0.8,
                                  child: CupertinoSwitch(
                                    value: controller.isWoman.value,
                                    activeColor: AppThemeData.primary300,
                                    onChanged: (value) {
                                      controller.isWoman.value = value;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Divider(),
                            ),
                            Text(
                              "Price Range".tr,
                              style: TextStyle(color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800, fontFamily: AppThemeData.bold, fontSize: 16),
                            ),
                            RangeSlider(
                              values: controller.currentRangeValues.value,
                              max: 10000,
                              divisions: 5000,
                              activeColor: AppThemeData.primary300,
                              labels: RangeLabels(
                                controller.currentRangeValues.value.start.round().toString(),
                                controller.currentRangeValues.value.end.round().toString(),
                              ),
                              onChanged: (RangeValues values) {
                                controller.currentRangeValues.value = values;
                                controller.minPriceController.value.text = controller.currentRangeValues.value.start.round().toString();
                                controller.maxPriceController.value.text = controller.currentRangeValues.value.end.round().toString();
                              },
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Min Price".tr,
                                        style: TextStyle(color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800, fontFamily: AppThemeData.bold, fontSize: 14),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      TextFormField(
                                        keyboardType: TextInputType.text,
                                        textCapitalization: TextCapitalization.sentences,
                                        maxLines: 1,
                                        controller: controller.minPriceController.value,
                                        textInputAction: TextInputAction.done,
                                        style: TextStyle(fontSize: 14, color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900, fontFamily: AppThemeData.medium),
                                        decoration: InputDecoration(
                                          errorStyle: const TextStyle(color: Colors.red),
                                          filled: true,
                                          fillColor: themeChange.getThem() ? AppThemeData.grey800 : AppThemeData.grey100,
                                          prefixIcon: Padding(
                                            padding: const EdgeInsets.all(14),
                                            child: Text(Constant.currencyModel!.symbol.toString()),
                                          ),
                                          disabledBorder: OutlineInputBorder(
                                            borderRadius: const BorderRadius.all(Radius.circular(30)),
                                            borderSide: BorderSide(color: themeChange.getThem() ? AppThemeData.grey200 : AppThemeData.grey700, width: 1),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: const BorderRadius.all(Radius.circular(30)),
                                            borderSide: BorderSide(color: themeChange.getThem() ? AppThemeData.primary300 : AppThemeData.primary300, width: 1),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: const BorderRadius.all(Radius.circular(30)),
                                            borderSide: BorderSide(color: themeChange.getThem() ? AppThemeData.grey200 : AppThemeData.grey700, width: 1),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius: const BorderRadius.all(Radius.circular(30)),
                                            borderSide: BorderSide(color: themeChange.getThem() ? AppThemeData.grey200 : AppThemeData.grey700, width: 1),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: const BorderRadius.all(Radius.circular(30)),
                                            borderSide: BorderSide(color: themeChange.getThem() ? AppThemeData.grey200 : AppThemeData.grey700, width: 1),
                                          ),
                                          hintText: "Min Price".tr,
                                          hintStyle: TextStyle(
                                            fontSize: 14,
                                            color: themeChange.getThem() ? AppThemeData.grey700 : AppThemeData.grey700,
                                            fontFamily: AppThemeData.regular,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Center(
                                    child: Text(
                                      "-",
                                      style: TextStyle(color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800, fontFamily: AppThemeData.medium, fontSize: 30),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Max Price",
                                        style: TextStyle(color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800, fontFamily: AppThemeData.bold, fontSize: 14),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      TextFormField(
                                        textCapitalization: TextCapitalization.sentences,
                                        maxLines: 1,
                                        controller: controller.maxPriceController.value,
                                        textInputAction: TextInputAction.done,
                                        keyboardType: TextInputType.number,
                                        style: TextStyle(fontSize: 14, color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900, fontFamily: AppThemeData.medium),
                                        decoration: InputDecoration(
                                          errorStyle: const TextStyle(color: Colors.red),
                                          filled: true,
                                          fillColor: themeChange.getThem() ? AppThemeData.grey800 : AppThemeData.grey100,
                                          prefixIcon: Padding(
                                            padding: const EdgeInsets.all(14),
                                            child: Text(Constant.currencyModel!.symbol.toString()),
                                          ),
                                          disabledBorder: OutlineInputBorder(
                                            borderRadius: const BorderRadius.all(Radius.circular(30)),
                                            borderSide: BorderSide(color: themeChange.getThem() ? AppThemeData.grey200 : AppThemeData.grey700, width: 1),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: const BorderRadius.all(Radius.circular(30)),
                                            borderSide: BorderSide(color: themeChange.getThem() ? AppThemeData.primary300 : AppThemeData.primary300, width: 1),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: const BorderRadius.all(Radius.circular(30)),
                                            borderSide: BorderSide(color: themeChange.getThem() ? AppThemeData.grey200 : AppThemeData.grey700, width: 1),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius: const BorderRadius.all(Radius.circular(30)),
                                            borderSide: BorderSide(color: themeChange.getThem() ? AppThemeData.grey200 : AppThemeData.grey700, width: 1),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: const BorderRadius.all(Radius.circular(30)),
                                            borderSide: BorderSide(color: themeChange.getThem() ? AppThemeData.grey200 : AppThemeData.grey700, width: 1),
                                          ),
                                          hintText: "Max Price".tr,
                                          hintStyle: TextStyle(
                                            fontSize: 14,
                                            color: themeChange.getThem() ? AppThemeData.grey700 : AppThemeData.grey700,
                                            fontFamily: AppThemeData.regular,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    bottomNavigationBar: SafeBottomWidget(
                      child: Container(
                        color: themeChange.getThem() ? AppThemeData.grey900 : AppThemeData.grey50,
                        child: Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  controller.selectedDepartureTime.clear();
                                  controller.verifyDriver.value = false;
                                  controller.isWoman.value = false;
                                  controller.minPriceController.value.text = "1";
                                  controller.maxPriceController.value.text = "10000";
                                  controller.currentRangeValues = const RangeValues(1, 10000).obs;
                                  controller.searchRide();
                                  Get.back();
                                },
                                child: Text(
                                  "Clear all".tr,
                                  style: TextStyle(color: themeChange.getThem() ? AppThemeData.primary300 : AppThemeData.primary300, fontFamily: AppThemeData.bold, fontSize: 16),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: RoundedButtonFill(
                                title: "Show Results".tr,
                                width: 32,
                                color: AppThemeData.primary300,
                                textColor: AppThemeData.grey50,
                                onPress: () async {
                                  controller.filterBookings(
                                      timeSlots: controller.selectedDepartureTime,
                                      womenOnly: controller.isWoman.value,
                                      verifyDrivers: controller.verifyDriver.value,
                                      maxPrice: double.parse(controller.maxPriceController.value.text),
                                      minPrice: double.parse(controller.minPriceController.value.text));
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ));
              });
        },
      ),
    );
  }
}
