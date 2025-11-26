import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:wevoride/app/myride/booked_details_screen.dart';
import 'package:wevoride/app/myride/published_details_screen.dart';
import 'package:wevoride/app/rating_view_screen/rating_view_screen.dart';
import 'package:wevoride/constant/constant.dart';
import 'package:wevoride/controller/myride_controller.dart';
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
import 'package:provider/provider.dart';
import 'package:wevoride/widgets/custom_scaffold.dart';

class MyRideScreen extends StatelessWidget {
  const MyRideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: MyRideController(),
        builder: (controller) {
          return controller.isLoading.value
              ? Constant.loader()
              : DefaultTabController(
                  length: 2,
                  child: CustomScaffold(
                    backgroundColor: themeChange.getThem() ? AppThemeData.grey800 : AppThemeData.grey100,
                    appBar: AppBar(
                      backgroundColor: themeChange.getThem() ? AppThemeData.grey900 : AppThemeData.grey50,
                      centerTitle: false,
                      automaticallyImplyLeading: false,
                      title: Text(
                        "My Rides".tr,
                        style: TextStyle(color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800, fontFamily: AppThemeData.bold, fontSize: 18),
                      ),
                      elevation: 0,
                      bottom: TabBar(
                        isScrollable: true,
                        tabAlignment: TabAlignment.start,
                        labelColor: AppThemeData.primary300,
                        indicatorColor: AppThemeData.primary300,
                        unselectedLabelStyle: TextStyle(
                          color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey700,
                        ),
                        tabs: [
                          Tab(
                            text: 'Booked'.tr,
                          ),
                          Tab(
                            text: 'Publishes'.tr,
                          ),
                        ],
                      ),
                    ),
                    body: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: TabBarView(
                        children: [
                          if (controller.myBooking.isEmpty)
                            Constant.showEmptyView(message: "Booking Not found".tr, isDarkMode: themeChange.getThem())
                          else
                            RefreshIndicator(
                              onRefresh: () => controller.getBookedRight(),
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: controller.myBooking.length,
                                itemBuilder: (context, index) {
                                  BookingModel bookingModel = controller.myBooking[index];
                                  return FutureBuilder<BookedUserModel?>(
                                      future: FireStoreUtils.getMyBookingUser(bookingModel),
                                      builder: (context, snapshot) {
                                        switch (snapshot.connectionState) {
                                          case ConnectionState.waiting:
                                            return const SizedBox();
                                          case ConnectionState.done:
                                            if (snapshot.hasError) {
                                              return Text(snapshot.error.toString());
                                            } else {
                                              BookedUserModel? bookingUserModel = snapshot.data;
                                              StopOverModel? stopOverModel = bookingUserModel!.stopOver;
                                              return InkWell(
                                                onTap: () {
                                                  Get.to(const BookedDetailsScreen(), arguments: {"bookingModel": bookingModel, "bookingUserModel": bookingUserModel})!.then(
                                                    (value) {
                                                      controller.getBookedRight();
                                                    },
                                                  );
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
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Expanded(
                                                                    child: Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        RichText(
                                                                          text: TextSpan(
                                                                            style: Theme.of(context).textTheme.bodyLarge,
                                                                            children: [
                                                                              WidgetSpan(
                                                                                  child: Constant.getCityName(
                                                                                      themeChange, Location(lat: stopOverModel!.startLocation!.lat, lng: stopOverModel.startLocation!.lng))),
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
                                                                        Text(
                                                                          Constant.amountShow(amount: stopOverModel.price.toString()),
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
                                                                  ),
                                                                  RoundedButtonFill(
                                                                    title: bookingModel.status == Constant.placed ? "Accepted" : bookingModel.status.toString().toUpperCase(),
                                                                    color: bookingModel.status == Constant.placed ? AppThemeData.secondary300 : AppThemeData.success400,
                                                                    width: 22,
                                                                    height: 4,
                                                                    fontSizes: 12,
                                                                    textColor: bookingModel.status == Constant.placed ? AppThemeData.secondary600 : AppThemeData.grey50,
                                                                    onPress: () {},
                                                                  ),
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                height: 20,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Expanded(
                                                                    child: Row(
                                                                      children: [
                                                                        SvgPicture.asset(
                                                                          "assets/icons/ic_calender.svg",
                                                                          height: 18,
                                                                          width: 18,
                                                                          colorFilter: ColorFilter.mode(themeChange.getThem() ? AppThemeData.grey200 : AppThemeData.grey700, BlendMode.srcIn),
                                                                        ),
                                                                        const SizedBox(
                                                                          width: 10,
                                                                        ),
                                                                        Text(
                                                                          Constant.timestampToDate(bookingModel.departureDateTime!),
                                                                          maxLines: 1,
                                                                          style: TextStyle(
                                                                            color: themeChange.getThem() ? AppThemeData.grey200 : AppThemeData.grey700,
                                                                            fontSize: 14,
                                                                            overflow: TextOverflow.ellipsis,
                                                                            fontFamily: AppThemeData.medium,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Expanded(
                                                                    child: Row(
                                                                      children: [
                                                                        SvgPicture.asset(
                                                                          "assets/icons/ic_time.svg",
                                                                          height: 18,
                                                                          width: 18,
                                                                          colorFilter: ColorFilter.mode(themeChange.getThem() ? AppThemeData.grey200 : AppThemeData.grey700, BlendMode.srcIn),
                                                                        ),
                                                                        const SizedBox(
                                                                          width: 10,
                                                                        ),
                                                                        Text(
                                                                          Constant.timestampToTime(bookingModel.departureDateTime!),
                                                                          maxLines: 1,
                                                                          style: TextStyle(
                                                                            color: themeChange.getThem() ? AppThemeData.grey200 : AppThemeData.grey700,
                                                                            fontSize: 14,
                                                                            overflow: TextOverflow.ellipsis,
                                                                            fontFamily: AppThemeData.medium,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Expanded(
                                                                    child: Row(
                                                                      children: [
                                                                        SvgPicture.asset(
                                                                          "assets/icons/ic_user_icon.svg",
                                                                          height: 18,
                                                                          width: 18,
                                                                          colorFilter: ColorFilter.mode(themeChange.getThem() ? AppThemeData.grey200 : AppThemeData.grey700, BlendMode.srcIn),
                                                                        ),
                                                                        const SizedBox(
                                                                          width: 10,
                                                                        ),
                                                                        Text(
                                                                          "${bookingUserModel.bookedSeat} Passenger",
                                                                          maxLines: 1,
                                                                          style: TextStyle(
                                                                            color: themeChange.getThem() ? AppThemeData.grey200 : AppThemeData.grey700,
                                                                            fontSize: 14,
                                                                            overflow: TextOverflow.ellipsis,
                                                                            fontFamily: AppThemeData.medium,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Expanded(
                                                                    child: SingleChildScrollView(
                                                                      scrollDirection: Axis.horizontal,
                                                                      child: Row(
                                                                        children: [
                                                                          SvgPicture.asset(
                                                                            "assets/icons/ic_wallet.svg",
                                                                            height: 18,
                                                                            width: 18,
                                                                            colorFilter: ColorFilter.mode(themeChange.getThem() ? AppThemeData.grey200 : AppThemeData.grey700, BlendMode.srcIn),
                                                                          ),
                                                                          const SizedBox(
                                                                            width: 10,
                                                                          ),
                                                                          Text(
                                                                            "${bookingUserModel.paymentType}",
                                                                            maxLines: 1,
                                                                            style: TextStyle(
                                                                              color: themeChange.getThem() ? AppThemeData.grey200 : AppThemeData.grey700,
                                                                              fontSize: 14,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              fontFamily: AppThemeData.medium,
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            " (${bookingUserModel.paymentStatus == true ? "Paid" : "UnPaid"})",
                                                                            style: TextStyle(
                                                                                color: bookingUserModel.paymentStatus == true ? AppThemeData.success400 : AppThemeData.warning300,
                                                                                fontFamily: AppThemeData.bold,
                                                                                fontSize: 14),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
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
                                                                    } else if (snapshot.data == null) {
                                                                      return const SizedBox();
                                                                    } else {
                                                                      UserModel? userModel = snapshot.data;

                                                                      return Row(
                                                                        children: [
                                                                          Stack(
                                                                            children: [
                                                                              ClipRRect(
                                                                                borderRadius: BorderRadius.circular(60),
                                                                                child: NetworkImageWidget(
                                                                                  imageUrl: userModel!.profilePic.toString(),
                                                                                  fit: BoxFit.cover,
                                                                                  height: Responsive.width(10, context),
                                                                                  width: Responsive.width(10, context),
                                                                                ),
                                                                              ),
                                                                              Positioned(bottom: 0, right: 0, child: SvgPicture.asset("assets/icons/ic_verify.svg"))
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
                                                                            colorFilter: ColorFilter.mode(themeChange.getThem() ? AppThemeData.grey300 : AppThemeData.grey600, BlendMode.srcIn),
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
                                            return Text('Error'.tr);
                                        }
                                      });
                                },
                              ),
                            ),
                          if (controller.publisherBooking.isEmpty)
                            Constant.showEmptyView(message: "Booking Not found".tr, isDarkMode: themeChange.getThem())
                          else
                            RefreshIndicator(
                              onRefresh: () => controller.getBookedRight(),
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: controller.publisherBooking.length,
                                itemBuilder: (context, index) {
                                  BookingModel bookingModel = controller.publisherBooking[index];
                                  return InkWell(
                                    onTap: () {
                                      Get.to(const PublishedDetailsScreen(), arguments: {"bookingModel": bookingModel})!.then(
                                        (value) {
                                          if (value == true) {
                                            controller.getBookedRight();
                                          }
                                        },
                                      );
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
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  RichText(
                                                    text: TextSpan(
                                                      style: Theme.of(context).textTheme.bodyLarge,
                                                      children: [
                                                        WidgetSpan(
                                                            child: Constant.getCityName(themeChange,
                                                                Location(lat: bookingModel.pickupLocation!.geometry!.location!.lat, lng: bookingModel.pickupLocation!.geometry!.location!.lng))),
                                                        WidgetSpan(
                                                          child: Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 10),
                                                            child: SvgPicture.asset("assets/icons/ic_right_arrow.svg"),
                                                          ),
                                                        ),
                                                        WidgetSpan(
                                                            child: Constant.getCityName(themeChange,
                                                                Location(lat: bookingModel.dropLocation!.geometry!.location!.lat, lng: bookingModel.dropLocation!.geometry!.location!.lng)))
                                                      ],
                                                    ),
                                                  ),
                                                  Text(
                                                    Constant.amountShow(amount: bookingModel.pricePerSeat.toString()),
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
                                                height: 5,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 4),
                                                child: Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                      "assets/icons/ic_calender.svg",
                                                      height: 18,
                                                      width: 18,
                                                      colorFilter: ColorFilter.mode(themeChange.getThem() ? AppThemeData.grey200 : AppThemeData.grey700, BlendMode.srcIn),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      Constant.timestampToDate(bookingModel.departureDateTime!),
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                        color: themeChange.getThem() ? AppThemeData.grey200 : AppThemeData.grey700,
                                                        fontSize: 14,
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
                                                      height: 18,
                                                      width: 18,
                                                      colorFilter: ColorFilter.mode(themeChange.getThem() ? AppThemeData.grey200 : AppThemeData.grey700, BlendMode.srcIn),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      Constant.timestampToTime(bookingModel.departureDateTime!),
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                        color: themeChange.getThem() ? AppThemeData.grey200 : AppThemeData.grey700,
                                                        fontSize: 14,
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
                                                      "assets/icons/ic_user_icon.svg",
                                                      height: 18,
                                                      width: 18,
                                                      colorFilter: ColorFilter.mode(themeChange.getThem() ? AppThemeData.grey200 : AppThemeData.grey700, BlendMode.srcIn),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      "${bookingModel.bookedSeat} Seats Booked".tr,
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                        color: themeChange.getThem() ? AppThemeData.grey200 : AppThemeData.grey700,
                                                        fontSize: 14,
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
                                                      bookingModel.publish == true ? "assets/icons/ic_check.svg" : "assets/icons/ic_uncheck.svg",
                                                      height: 18,
                                                      width: 18,
                                                      colorFilter: ColorFilter.mode(bookingModel.publish == true ? AppThemeData.success400 : AppThemeData.warning300, BlendMode.srcIn),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      bookingModel.publish == true ? "Published" : "UnPublished",
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                        color: bookingModel.publish == true ? AppThemeData.success400 : AppThemeData.warning300,
                                                        fontSize: 14,
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
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      "Publish on : ${Constant.timestampToDateTime(bookingModel.createdAt!)}",
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                        color: themeChange.getThem() ? AppThemeData.grey200 : AppThemeData.grey700,
                                                        overflow: TextOverflow.ellipsis,
                                                        fontFamily: AppThemeData.regular,
                                                      ),
                                                    ),
                                                  ),
                                                  // RoundedButtonFill(
                                                  //   title: bookingModel.status == Constant.onGoing
                                                  //       ? "Complete"
                                                  //       : bookingModel.status == Constant.completed
                                                  //           ? "Completed"
                                                  //           : "OnGoing",
                                                  //   color: bookingModel.status == Constant.onGoing
                                                  //       ? AppThemeData.primary300
                                                  //       : bookingModel.status == Constant.completed
                                                  //           ? AppThemeData.success500
                                                  //           : AppThemeData.secondary400,
                                                  //   width: 20,
                                                  //   height: 4,
                                                  //   fontSizes: 12,
                                                  //   textColor: AppThemeData.grey50,
                                                  //   onPress: () async {
                                                  //     if (bookingModel.status != Constant.completed) {
                                                  //       if (bookingModel.status == Constant.placed) {
                                                  //         if (bookingModel.departureDateTime!.toDate().isAfter(DateTime.now())) {
                                                  //           ShowToastDialog.showToast(
                                                  //               "You will ride departure time is ${Constant.timestampToDateTime(bookingModel.departureDateTime!)}");
                                                  //         } else {
                                                  //           bookingModel.status = Constant.onGoing;
                                                  //           await FireStoreUtils.setBooking(bookingModel).then(
                                                  //             (value) {
                                                  //               ShowToastDialog.showToast("Status change successfully".tr);
                                                  //               controller.getBookedRight();
                                                  //             },
                                                  //           );
                                                  //         }
                                                  //       } else if (bookingModel.status == Constant.onGoing) {
                                                  //         bookingModel.status = Constant.completed;
                                                  //
                                                  //         bookingModel.bookedUserId!.forEach(
                                                  //           (element) async {
                                                  //             await FireStoreUtils.getUserProfile(element.toString()).then(
                                                  //               (value) {
                                                  //                 SendNotification.sendOneNotification(
                                                  //                     type: Constant.ride_completed, token: value!.fcmToken.toString(), payload: {});
                                                  //                 SendNotification.sendOneNotification(type: Constant.feedback, token: value.fcmToken.toString(), payload: {});
                                                  //               },
                                                  //             );
                                                  //           },
                                                  //         );
                                                  //         await FireStoreUtils.setBooking(bookingModel).then(
                                                  //           (value) {
                                                  //             ShowToastDialog.showToast("Status change successfully".tr);
                                                  //             controller.getBookedRight();
                                                  //           },
                                                  //         );
                                                  //       }
                                                  //     }
                                                  //   },
                                                  // ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
        });
  }
}
