import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:location/location.dart' as loc;
import 'package:wevoride/app/chat/chat_screen.dart';
import 'package:wevoride/app/rating_view_screen/rating_view_screen.dart';
import 'package:wevoride/app/report_help_screen/report_help_screen.dart';
import 'package:wevoride/app/review/review_screen.dart';
import 'package:wevoride/app/wallet_screen/select_payment_method_screen.dart';
import 'package:wevoride/constant/constant.dart';
import 'package:wevoride/constant/show_toast_dialog.dart';
import 'package:wevoride/controller/booked_details_controller.dart';
import 'package:wevoride/model/map/geometry.dart';
import 'package:wevoride/model/sos_model.dart';
import 'package:wevoride/model/tax_model.dart';
import 'package:wevoride/model/wallet_transaction_model.dart';
import 'package:wevoride/themes/app_them_data.dart';
import 'package:wevoride/themes/custom_dialog_box.dart';
import 'package:wevoride/themes/responsive.dart';
import 'package:wevoride/themes/round_button_fill.dart';
import 'package:wevoride/utils/dark_theme_provider.dart';
import 'package:wevoride/utils/fire_store_utils.dart';
import 'package:wevoride/utils/network_image_widget.dart';
import 'package:provider/provider.dart';
import 'package:timelines_plus/timelines_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wevoride/widgets/custom_scaffold.dart';

class BookedDetailsScreen extends StatelessWidget {
  const BookedDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: BookedDetailsController(),
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
                    )),
                title: Text(
                  "Ride Details".tr,
                  style: TextStyle(color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800, fontFamily: AppThemeData.semiBold, fontSize: 16),
                ),
                elevation: 0,
                actions: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: InkWell(
                      onTap: () {
                        Get.to(const ReportHelpScreen(), arguments: {"reportedBy": "customer", "reportedTo": controller.bookingModel.value.createdBy, "bookingId": controller.bookingModel.value.id});
                      },
                      child: Text(
                        "Report Ride".tr,
                        style: TextStyle(color: themeChange.getThem() ? AppThemeData.primary300 : AppThemeData.primary300, fontFamily: AppThemeData.semiBold, fontSize: 16),
                      ),
                    ),
                  )
                ],
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
                  : Stack(
                    children: [
                      SingleChildScrollView(
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
                                          child: Text(
                                            Constant.orderId(orderId: controller.bookingModel.value.id.toString()),
                                            maxLines: 1,
                                            style: TextStyle(
                                              color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800,
                                              fontSize: 14,
                                              overflow: TextOverflow.ellipsis,
                                              fontFamily: AppThemeData.bold,
                                            ),
                                          ),
                                        )
                                      ],
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
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 4),
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                            "assets/icons/ic_wallet.svg",
                                            height: 20,
                                            width: 20,
                                            colorFilter: ColorFilter.mode(themeChange.getThem() ? AppThemeData.grey200 : AppThemeData.grey700, BlendMode.srcIn),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "${controller.bookingUserModel.value.paymentType}",
                                            maxLines: 1,
                                            style: TextStyle(
                                              color: themeChange.getThem() ? AppThemeData.grey200 : AppThemeData.grey700,
                                              fontSize: 16,
                                              overflow: TextOverflow.ellipsis,
                                              fontFamily: AppThemeData.medium,
                                            ),
                                          ),
                                          Text(
                                            " (${controller.bookingUserModel.value.paymentStatus == true ? "Paid" : "UnPaid"})",
                                            style: TextStyle(
                                                color: controller.bookingUserModel.value.paymentStatus == true ? AppThemeData.success400 : AppThemeData.warning300,
                                                fontFamily: AppThemeData.bold,
                                                fontSize: 14),
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
                                                              lat: controller.bookingUserModel.value.stopOver!.startLocation!.lat, lng: controller.bookingUserModel.value.stopOver!.startLocation!.lng),
                                                          style: TextStyle(color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800, fontFamily: AppThemeData.bold, fontSize: 18)),
                                                      Text(
                                                        controller.bookingUserModel.value.stopOver!.startAddress.toString(),
                                                        maxLines: 1,
                                                        style: TextStyle(color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800, fontFamily: AppThemeData.regular, fontSize: 14),
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
                                                      Constant.getCityName(themeChange,
                                                          Location(lat: controller.bookingUserModel.value.stopOver!.endLocation!.lat, lng: controller.bookingUserModel.value.stopOver!.endLocation!.lng),
                                                          style: TextStyle(color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800, fontFamily: AppThemeData.bold, fontSize: 18)),
                                                      Text(
                                                        controller.bookingUserModel.value.stopOver!.endAddress.toString(),
                                                        maxLines: 1,
                                                        style: TextStyle(color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800, fontFamily: AppThemeData.regular, fontSize: 14),
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
                              if (controller.publisherUserModel.value.id != null)
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
                                      Expanded(
                                        child: Column(
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
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          await Constant.makePhoneCall("${controller.publisherUserModel.value.countryCode.toString()} ${controller.publisherUserModel.value.phoneNumber.toString()}");
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
                                          Get.to(const ChatScreen(), arguments: {"receiverModel": controller.publisherUserModel.value});
                                        },
                                        child: SvgPicture.asset(
                                          "assets/icons/ic_chat.svg",
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                              controller.bookingModel.value.travelPreference == null
                                  ? const SizedBox()
                                  : Column(
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.symmetric(vertical: 5),
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
                                    const SizedBox(
                                      height: 100,)
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // PreferredSize(
                    //   preferredSize: const Size.fromHeight(4.0),
                    //   child: Container(
                    //     color: themeChange.getThem() ? AppThemeData.grey700 : AppThemeData.grey200,
                    //     height: 6.0,
                    //   ),
                    // ),
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    controller.publisherUserModel.value.id != null && controller.bookingModel.value.status == Constant.completed && controller.bookingUserModel.value.paymentStatus == true
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: RoundedButtonFill(
                              title: controller.reviewModel.value.id != null ? "Edit Review" : "Add Review".tr,
                              color: AppThemeData.primary300,
                              textColor: AppThemeData.grey50,
                              onPress: () async {
                                Get.to(() => const ReviewScreen(), arguments: {
                                  "bookingModel": controller.bookingModel.value,
                                  "senderUserModel": controller.userModel.value,
                                  "reciverUserModel": controller.publisherUserModel.value
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
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                controller.bookingModel.value.status == Constant.onGoing || controller.bookingModel.value.status == Constant.completed
                                    ? const SizedBox()
                                    : Expanded(
                                        child: RoundedButtonFill(
                                          title: "Cancel Booking".tr,
                                          color: AppThemeData.warning300,
                                          textColor: AppThemeData.grey50,
                                          onPress: () async {
                                            showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return CustomDialogBox(
                                                    title: "Cancel Ride".tr,
                                                    descriptions: "Are you sure want to cancel ride?".tr,
                                                    positiveString: "OK".tr,
                                                    negativeString: "Cancel".tr,
                                                    positiveClick: () async {
                                                      ShowToastDialog.showLoader("Please wait".tr);
                                                      controller.bookingModel.value.bookedSeat =
                                                          (int.parse(controller.bookingModel.value.bookedSeat.toString()) - int.parse(controller.bookingUserModel.value.bookedSeat.toString()))
                                                              .toString();

                                                      controller.bookingModel.value.bookedUserId!.remove(FireStoreUtils.getCurrentUid());
                                                      if (controller.bookingModel.value.cancelledUserId!.contains(FireStoreUtils.getCurrentUid()) == false) {
                                                        controller.bookingModel.value.cancelledUserId!.add(FireStoreUtils.getCurrentUid());
                                                      }

                                                      if (controller.bookingUserModel.value.paymentStatus == true) {
                                                        if (controller.bookingUserModel.value.paymentType!.toLowerCase() != "cash") {
                                                          WalletTransactionModel transactionModel = WalletTransactionModel(
                                                              id: Constant.getUuid(),
                                                              amount: controller.calculateAmount().toString(),
                                                              createdDate: Timestamp.now(),
                                                              paymentType: "Wallet",
                                                              transactionId: controller.bookingModel.value.id,
                                                              isCredit: false,
                                                              type: "publisher",
                                                              userId: controller.bookingModel.value.createdBy.toString(),
                                                              note: "Amount refunded for ${controller.userModel.value.fullName()} ride");

                                                          await FireStoreUtils.setWalletTransaction(transactionModel).then((value) async {
                                                            if (value == true) {
                                                              await FireStoreUtils.updateOtherUserWallet(
                                                                  amount: "-${controller.calculateAmount().toString()}", id: controller.bookingModel.value.createdBy.toString());
                                                            }
                                                          });
                                                          if (controller.bookingUserModel.value.adminCommission != null && controller.bookingUserModel.value.adminCommission!.enable == true) {
                                                            WalletTransactionModel adminCommissionWallet = WalletTransactionModel(
                                                                id: Constant.getUuid(),
                                                                amount:
                                                                    "${Constant.calculateOrderAdminCommission(amount: double.parse(controller.bookingUserModel.value.subTotal.toString()).toString(), adminCommission: controller.bookingUserModel.value.adminCommission)}",
                                                                createdDate: Timestamp.now(),
                                                                paymentType: "Wallet",
                                                                isCredit: true,
                                                                transactionId: controller.bookingModel.value.id,
                                                                type: "publisher",
                                                                userId: controller.bookingModel.value.createdBy.toString(),
                                                                note: "Admin commission credited for  ${controller.userModel.value.fullName()}");

                                                            await FireStoreUtils.setWalletTransaction(adminCommissionWallet).then((value) async {
                                                              if (value == true) {
                                                                await FireStoreUtils.updateOtherUserWallet(
                                                                    amount:
                                                                        "${Constant.calculateOrderAdminCommission(amount: controller.bookingUserModel.value.subTotal.toString(), adminCommission: controller.bookingUserModel.value.adminCommission)}",
                                                                    id: controller.bookingModel.value.createdBy.toString());
                                                              }
                                                            });
                                                          }
                                                        } else {
                                                          if (controller.bookingUserModel.value.adminCommission != null && controller.bookingUserModel.value.adminCommission!.enable == true) {
                                                            WalletTransactionModel adminCommissionWallet = WalletTransactionModel(
                                                                id: Constant.getUuid(),
                                                                amount:
                                                                    "${Constant.calculateOrderAdminCommission(amount: double.parse(controller.bookingUserModel.value.subTotal.toString()).toString(), adminCommission: controller.bookingUserModel.value.adminCommission)}",
                                                                createdDate: Timestamp.now(),
                                                                paymentType: "Wallet",
                                                                isCredit: true,
                                                                transactionId: controller.bookingModel.value.id,
                                                                type: "publisher",
                                                                userId: controller.bookingModel.value.createdBy.toString(),
                                                                note: "Admin commission credited for  ${controller.userModel.value.fullName()}");
                                                            await FireStoreUtils.setWalletTransaction(adminCommissionWallet).then((value) async {
                                                              if (value == true) {
                                                                await FireStoreUtils.updateOtherUserWallet(
                                                                    amount:
                                                                        "-${Constant.calculateOrderAdminCommission(amount: controller.bookingUserModel.value.subTotal.toString(), adminCommission: controller.bookingUserModel.value.adminCommission)}",
                                                                    id: controller.bookingModel.value.createdBy.toString());
                                                              }
                                                            });
                                                          }
                                                        }

                                                        WalletTransactionModel transactionModel = WalletTransactionModel(
                                                            id: Constant.getUuid(),
                                                            amount: controller.calculateAmount().toString(),
                                                            createdDate: Timestamp.now(),
                                                            paymentType: "Wallet",
                                                            transactionId: controller.bookingModel.value.id,
                                                            isCredit: true,
                                                            type: "customer",
                                                            userId: controller.userModel.value.id.toString(),
                                                            note: "Amount refunded for ${controller.publisherUserModel.value.fullName()} ride");

                                                        await FireStoreUtils.setWalletTransaction(transactionModel).then((value) async {
                                                          if (value == true) {
                                                            await FireStoreUtils.updateOtherUserWallet(amount: controller.calculateAmount().toString(), id: controller.userModel.value.id.toString());
                                                          }
                                                        });
                                                      }

                                                      await FireStoreUtils.setCancelledUserBooking(controller.bookingModel.value, controller.bookingUserModel.value);
                                                      await FireStoreUtils.removeUserBooking(controller.bookingModel.value, controller.bookingUserModel.value);

                                                      await FireStoreUtils.setBooking(controller.bookingModel.value).then((value) {
                                                        ShowToastDialog.closeLoader();
                                                        ShowToastDialog.showToast("Booking Cancelled".tr);
                                                        Get.back(result: true);
                                                        Get.back(result: true);
                                                      });
                                                    },
                                                    negativeClick: () {
                                                      Get.back();
                                                    },
                                                    img: Image.asset(
                                                      'assets/icons/ic_cancel.svg',
                                                      height: 40,
                                                      width: 40,
                                                    ),
                                                  );
                                                });
                                          },
                                        ),
                                      ),
                                const SizedBox(
                                  width: 10,
                                ),
                                controller.bookingModel.value.status != Constant.placed
                                    ? Expanded(
                                        child: Row(
                                          children: [
                                            if (controller.bookingModel.value.status == Constant.onGoing)
                                              Expanded(
                                                child: RoundedButtonFill(
                                                  title: "SOS".tr,
                                                  color: AppThemeData.primary300,
                                                  textColor: AppThemeData.grey50,
                                                  onPress: () async {
                                                    ShowToastDialog.showLoader("Please wait".tr);
                                                    loc.LocationData? position = await Constant.getCurrentLocation();
                                                    if (position?.latitude == null) {
                                                      ShowToastDialog.closeLoader();
                                                      ShowToastDialog.showToast("Please enable GPS to use the SOS emergency feature.".tr);
                                                      return;
                                                    }
                                                    String customerId = FireStoreUtils.getCurrentUid();
                                                    await FireStoreUtils.getSOS(
                                                            bookingId: controller.bookingModel.value.id.toString(), driverId: controller.bookingModel.value.createdBy!, customerId: customerId)
                                                        .then((value) async {
                                                      if (value != null) {
                                                        ShowToastDialog.closeLoader();
                                                        ShowToastDialog.showToast("Your SOS request is already submitted.".tr);
                                                      } else {
                                                        SosModel sosModel = SosModel();
                                                        sosModel.id = Constant.getUuid();
                                                        sosModel.bookingId = controller.bookingModel.value.id;
                                                        sosModel.driverId = controller.bookingModel.value.createdBy;
                                                        sosModel.customerId = customerId;
                                                        sosModel.sosLocation = SOSLocation(latitude: position!.latitude!, longitude: position.longitude!);
                                                        sosModel.status = "Initiated";
                                                        await FireStoreUtils.setSOS(sosModel);
                                                        ShowToastDialog.closeLoader();
                                                        ShowToastDialog.showToast("Your SOS request has been submitted to admin.".tr);
                                                      }
                                                    });
                                                  },
                                                ),
                                              ),
                                            if (controller.bookingModel.value.status == Constant.onGoing && controller.bookingUserModel.value.paymentStatus == false) SizedBox(width: 20),
                                            if (controller.bookingUserModel.value.paymentStatus == false)
                                              Expanded(
                                                child: RoundedButtonFill(
                                                  title: "Pay Now".tr,
                                                  color: AppThemeData.primary300,
                                                  textColor: AppThemeData.grey50,
                                                  onPress: () async {
                                                    Get.to(const SelectPaymentMethodScreen(), arguments: {
                                                      "type": "booking",
                                                      "amount": controller.calculateAmount().toString(),
                                                      "selectedPaymentMethod": controller.bookingUserModel.value.paymentType.toString(),
                                                      "bookingId": controller.bookingModel.value.id.toString()
                                                    })!
                                                        .then(
                                                      (value) {
                                                        controller.paymentType.value = value['paymentType'];
                                                        controller.paymentCompleted();
                                                      },
                                                    );
                                                  },
                                                ),
                                              ),
                                          ],
                                        ),
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                          ),
                    // const SizedBox(
                    //   height: 10,
                    // ),
                  ],
                ),
              ),
                        )
                    ],
                  ),
);
        });
  }
}
