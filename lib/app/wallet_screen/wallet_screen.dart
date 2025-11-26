import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:wevoride/app/myride/booked_details_screen.dart';
import 'package:wevoride/app/myride/published_details_screen.dart';
import 'package:wevoride/constant/constant.dart';
import 'package:wevoride/constant/show_toast_dialog.dart';
import 'package:wevoride/controller/wallet_controller.dart';
import 'package:wevoride/model/booking_model.dart';
import 'package:wevoride/model/wallet_transaction_model.dart';
import 'package:wevoride/model/withdraw_model.dart';
import 'package:wevoride/themes/responsive.dart';
import 'package:wevoride/themes/round_button_fill.dart';
import 'package:wevoride/themes/text_field_widget.dart';
import 'package:wevoride/utils/dark_theme_provider.dart';
import 'package:wevoride/utils/fire_store_utils.dart';
import 'package:wevoride/widgets/custom_scaffold.dart';
import 'package:wevoride/widgets/safe_bottom_widget.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../themes/app_them_data.dart';
import 'select_payment_method_screen.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: WalletController(),
        builder: (controller) {
          return CustomScaffold(
            backgroundColor: themeChange.getThem()
                ? AppThemeData.grey800
                : AppThemeData.grey100,
            body: controller.isLoading.value
                ? Constant.loader()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: Responsive.width(100, context),
                        height: Responsive.height(34, context),
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image:
                                    AssetImage("assets/images/ic_wallet.png"),
                                fit: BoxFit.fill)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Total Balance",
                              maxLines: 1,
                              style: TextStyle(
                                color: themeChange.getThem()
                                    ? AppThemeData.primary100
                                    : AppThemeData.primary100,
                                fontSize: 16,
                                overflow: TextOverflow.ellipsis,
                                fontFamily: AppThemeData.regular,
                              ),
                            ),
                            Text(
                              Constant.amountShow(
                                  amount:
                                      controller.userModel.value.walletAmount),
                              maxLines: 1,
                              style: TextStyle(
                                color: themeChange.getThem()
                                    ? AppThemeData.grey50
                                    : AppThemeData.grey50,
                                fontSize: 40,
                                overflow: TextOverflow.ellipsis,
                                fontFamily: AppThemeData.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: RoundedButtonFill(
                                      title: "Top up".tr,
                                      color: AppThemeData.secondary300,
                                      textColor: AppThemeData.grey900,
                                      onPress: () {
                                        Get.to(
                                            const SelectPaymentMethodScreen(),
                                            arguments: {
                                              "type": "wallet"
                                            })?.then(
                                          (value) {
                                            if (value != null) {
                                              controller.amount.value =
                                                  value['amount'];
                                              controller.paymentType.value =
                                                  value['paymentType'];
                                              controller.walletTopUp();
                                            }
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                  // const SizedBox(
                                  //   width: 10,
                                  // ),
                                  // Expanded(
                                  //   child: RoundedButtonFill(
                                  //     title: "Withdrawal".tr,
                                  //     color: themeChange.getThem() ? AppThemeData.grey900 : AppThemeData.grey50,
                                  //     textColor: AppThemeData.primary300,
                                  //     onPress: () {
                                  //       if (double.parse(controller.userModel.value.walletAmount.toString()) <= double.parse(Constant.minimumAmountToWithdrawal.toString())) {
                                  //         ShowToastDialog.showToast("Insufficient balance".tr);
                                  //       } else {
                                  //         withdrawalBottomSheet(context, controller, themeChange);
                                  //       }
                                  //     },
                                  //   ),
                                  // ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: DefaultTabController(
                          length: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TabBar(
                                onTap: (value) {
                                  controller.selectedTabIndex.value = value;
                                },
                                labelStyle: const TextStyle(
                                    fontFamily: AppThemeData.semiBold),
                                labelColor: themeChange.getThem()
                                    ? AppThemeData.grey50
                                    : AppThemeData.grey900,
                                unselectedLabelStyle: const TextStyle(
                                    fontFamily: AppThemeData.medium),
                                unselectedLabelColor: themeChange.getThem()
                                    ? AppThemeData.grey300
                                    : AppThemeData.grey600,
                                indicatorColor: AppThemeData.primary300,
                                indicatorWeight: 1,
                                tabs: [
                                  Tab(
                                    text: "Transaction History".tr,
                                  ),
                                  // Tab(
                                  //   text: "Withdrawal History".tr,
                                  // ),
                                ],
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: TabBarView(
                                    children: [
                                      controller.transactionList.isEmpty
                                          ? Constant.showEmptyView(
                                              message:
                                                  "Transaction not found".tr,
                                              isDarkMode: themeChange.getThem())
                                          : ListView.builder(
                                              padding: const EdgeInsets.only(
                                                  top: 20),
                                              itemCount: controller
                                                  .transactionList.length,
                                              itemBuilder: (context, index) {
                                                WalletTransactionModel
                                                    walletTractionModel =
                                                    controller
                                                        .transactionList[index];
                                                return transactionCard(
                                                    controller,
                                                    themeChange,
                                                    walletTractionModel);
                                              },
                                            ),
                                      // controller.withdrawList.isEmpty
                                      //     ? Constant.showEmptyView(
                                      //         message:
                                      //             "No withdrawal history found"
                                      //                 .tr,
                                      //         isDarkMode: themeChange.getThem())
                                      //     : ListView.builder(
                                      //         itemCount: controller
                                      //             .withdrawList.length,
                                      //         padding: const EdgeInsets.only(
                                      //             top: 20),
                                      //         itemBuilder: (context, index) {
                                      //           WithdrawModel
                                      //               walletTransactionModel =
                                      //               controller
                                      //                   .withdrawList[index];
                                      //           return transactionCardForWithDraw(
                                      //               controller,
                                      //               themeChange,
                                      //               walletTransactionModel);
                                      //         },
                                      //       )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
          );
        });
  }

  transactionCard(WalletController controller, themeChange,
      WalletTransactionModel transactionModel) {
    return Column(
      children: [
        InkWell(
          onTap: () async {
            if (transactionModel.type == "publisher") {
              BookingModel? bookingModel =
                  await FireStoreUtils.getMyBookingNyUserId(
                      transactionModel.transactionId.toString());

              if (bookingModel != null) {
                Get.to(const PublishedDetailsScreen(),
                    arguments: {"bookingModel": bookingModel});
              }
            } else {
              BookingModel? bookingModel =
                  await FireStoreUtils.getMyBookingNyUserId(
                      transactionModel.transactionId.toString());
              if (bookingModel != null) {
                BookedUserModel? bookingUserModel =
                    await FireStoreUtils.getMyBookingUser(bookingModel);
                Get.to(const BookedDetailsScreen(), arguments: {
                  "bookingModel": bookingModel,
                  "bookingUserModel": bookingUserModel
                });
              }
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: [
                transactionModel.isCredit == false
                    ? SvgPicture.asset(
                        "assets/icons/ic_debit.svg",
                        height: 24,
                        width: 24,
                      )
                    : SvgPicture.asset(
                        "assets/icons/ic_credit.svg",
                        height: 24,
                        width: 24,
                      ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              transactionModel.note.toString(),
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: AppThemeData.bold,
                                color: themeChange.getThem()
                                    ? AppThemeData.grey100
                                    : AppThemeData.grey800,
                              ),
                            ),
                          ),
                          Text(
                            Constant.amountShow(
                                amount: transactionModel.amount.toString()),
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: AppThemeData.medium,
                              color: transactionModel.isCredit == true
                                  ? AppThemeData.success400
                                  : AppThemeData.warning300,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        Constant.timestampToDateTime(
                            transactionModel.createdDate!),
                        style: TextStyle(
                            fontSize: 12,
                            fontFamily: AppThemeData.regular,
                            color: themeChange.getThem()
                                ? AppThemeData.grey200
                                : AppThemeData.grey700),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const Divider(),
      ],
    );
  }

  transactionCardForWithDraw(WalletController controller, themeChange,
      WithdrawModel transactionModel) {
    return Column(
      children: [
        InkWell(
          onTap: () async {
            showDialog(
                context: Get.context!,
                builder: (BuildContext context) {
                  return showInformation(
                      themeChange, context, transactionModel);
                });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: [
                SvgPicture.asset(
                  "assets/icons/ic_debit.svg",
                  height: 24,
                  width: 24,
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              transactionModel.withdrawMethod
                                  .toString()
                                  .toUpperCase(),
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: AppThemeData.bold,
                                color: themeChange.getThem()
                                    ? AppThemeData.grey100
                                    : AppThemeData.grey800,
                              ),
                            ),
                          ),
                          Text(
                            Constant.amountShow(
                                amount: transactionModel.amount.toString()),
                            style: const TextStyle(
                              fontSize: 16,
                              fontFamily: AppThemeData.medium,
                              color: AppThemeData.warning300,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              Constant.timestampToDateTime(
                                  transactionModel.createdDate!),
                              style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: AppThemeData.regular,
                                  color: themeChange.getThem()
                                      ? AppThemeData.grey200
                                      : AppThemeData.grey700),
                            ),
                          ),
                          Text(
                            transactionModel.paymentStatus!.toUpperCase(),
                            style: TextStyle(
                                fontSize: 12,
                                fontFamily: AppThemeData.regular,
                                color:
                                    transactionModel.paymentStatus == "pending"
                                        ? AppThemeData.warning300
                                        : AppThemeData.success400),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const Divider(),
      ],
    );
  }

  withdrawalBottomSheet(
      BuildContext context, WalletController controller, themeChange) {
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
        builder: (context) => FractionallySizedBox(
              heightFactor: 0.8,
              child: StatefulBuilder(builder: (context1, setState) {
                return Obx(
                  () => CustomScaffold(
                    body: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Center(
                              child: Container(
                                width: 134,
                                height: 5,
                                margin: const EdgeInsets.only(bottom: 6),
                                decoration: ShapeDecoration(
                                  color: themeChange.getThem()
                                      ? AppThemeData.grey50
                                      : AppThemeData.grey800,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Withdrawal'.tr,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: AppThemeData.medium,
                                      color: themeChange.getThem()
                                          ? AppThemeData.grey50
                                          : AppThemeData.grey900,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Get.back();
                                  },
                                  child: Icon(
                                    Icons.close,
                                    color: themeChange.getThem()
                                        ? AppThemeData.grey50
                                        : AppThemeData.grey900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: TextFieldWidget(
                              title: 'Amount',
                              hintText: 'Enter Amount'.tr,
                              controller:
                                  controller.withdrawalAmountController.value,
                              textInputType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true, signed: true),
                              prefix: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                    Constant.currencyModel!.symbol.toString(),
                                    style: const TextStyle(
                                        fontSize: 20,
                                        color: AppThemeData.grey800)),
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp('[0-9]')),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: TextFieldWidget(
                              title: 'Note'.tr,
                              controller: controller.noteController.value,
                              hintText: 'Enter Note'.tr,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: AppThemeData.primary300,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Minimum withdrawal amount will be a  ${Constant.amountShow(amount: Constant.minimumAmountToWithdrawal.toString())}"
                                      .tr,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: AppThemeData.medium,
                                      color: themeChange.getThem()
                                          ? AppThemeData.primary300
                                          : AppThemeData.primary300),
                                ),
                              ],
                            ),
                          ),
                          controller.withdrawMethodModel.value.bank == null
                              ? const SizedBox()
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 5),
                                  child: InkWell(
                                    onTap: () {
                                      controller.selectedValue.value = 0;
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: themeChange.getThem()
                                            ? AppThemeData.grey800
                                            : AppThemeData.grey100,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              "assets/images/ic_bank.png",
                                              height: 40,
                                              color: themeChange.getThem()
                                                  ? AppThemeData.grey50
                                                  : null,
                                            ),
                                            Expanded(
                                              child: Text(
                                                "Bank Transfer".tr,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily:
                                                        AppThemeData.medium,
                                                    color: themeChange.getThem()
                                                        ? AppThemeData.grey50
                                                        : AppThemeData.grey900),
                                              ),
                                            ),
                                            Radio(
                                              value: 0,
                                              visualDensity:
                                                  const VisualDensity(
                                                      horizontal: VisualDensity
                                                          .minimumDensity,
                                                      vertical: VisualDensity
                                                          .minimumDensity),
                                              groupValue: controller
                                                  .selectedValue.value,
                                              onChanged: (value) {
                                                controller.selectedValue.value =
                                                    value!;
                                              },
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                          controller.withdrawMethodModel.value.stripe == null ||
                                  (controller.paymentModel.value.strip !=
                                          null &&
                                      controller.paymentModel.value.strip!
                                              .isWithdrawEnabled ==
                                          false)
                              ? const SizedBox()
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 5),
                                  child: InkWell(
                                    onTap: () {
                                      controller.selectedValue.value = 1;
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: themeChange.getThem()
                                            ? AppThemeData.grey800
                                            : AppThemeData.grey100,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              "assets/images/stripe.png",
                                              height: 40,
                                              width: 100,
                                              color: themeChange.getThem()
                                                  ? AppThemeData.grey50
                                                  : null,
                                            ),
                                            const Expanded(
                                              child: SizedBox(),
                                            ),
                                            Radio(
                                              value: 1,
                                              visualDensity:
                                                  const VisualDensity(
                                                      horizontal: VisualDensity
                                                          .minimumDensity,
                                                      vertical: VisualDensity
                                                          .minimumDensity),
                                              groupValue: controller
                                                  .selectedValue.value,
                                              onChanged: (value) {
                                                controller.selectedValue.value =
                                                    value!;
                                              },
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                          controller.withdrawMethodModel.value.paypal == null ||
                                  (controller.paymentModel.value.paypal !=
                                          null &&
                                      controller.paymentModel.value.paypal!
                                              .isWithdrawEnabled ==
                                          false)
                              ? const SizedBox()
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 5),
                                  child: InkWell(
                                    onTap: () {
                                      controller.selectedValue.value = 2;
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: themeChange.getThem()
                                            ? AppThemeData.grey800
                                            : AppThemeData.grey100,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              "assets/images/paypal.png",
                                              height: 40,
                                              width: 100,
                                              color: themeChange.getThem()
                                                  ? AppThemeData.grey50
                                                  : null,
                                            ),
                                            const Expanded(
                                              child: SizedBox(),
                                            ),
                                            Radio(
                                              value: 2,
                                              visualDensity:
                                                  const VisualDensity(
                                                      horizontal: VisualDensity
                                                          .minimumDensity,
                                                      vertical: VisualDensity
                                                          .minimumDensity),
                                              groupValue: controller
                                                  .selectedValue.value,
                                              onChanged: (value) {
                                                controller.selectedValue.value =
                                                    value!;
                                              },
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                          controller.withdrawMethodModel.value.razorpay ==
                                      null ||
                                  (controller.paymentModel.value.razorpay !=
                                          null &&
                                      controller.paymentModel.value.razorpay!
                                              .isWithdrawEnabled ==
                                          false)
                              ? const SizedBox()
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 5),
                                  child: InkWell(
                                    onTap: () {
                                      controller.selectedValue.value = 3;
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: themeChange.getThem()
                                            ? AppThemeData.grey800
                                            : AppThemeData.grey100,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              "assets/images/razorpay.png",
                                              height: 40,
                                              width: 100,
                                              color: themeChange.getThem()
                                                  ? AppThemeData.grey50
                                                  : null,
                                            ),
                                            const Expanded(
                                              child: SizedBox(),
                                            ),
                                            Radio(
                                              value: 3,
                                              visualDensity:
                                                  const VisualDensity(
                                                      horizontal: VisualDensity
                                                          .minimumDensity,
                                                      vertical: VisualDensity
                                                          .minimumDensity),
                                              groupValue: controller
                                                  .selectedValue.value,
                                              onChanged: (value) {
                                                controller.selectedValue.value =
                                                    value!;
                                              },
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                          controller.withdrawMethodModel.value.flutterWave ==
                                      null ||
                                  (controller.paymentModel.value.flutterWave !=
                                          null &&
                                      controller.paymentModel.value.flutterWave!
                                              .isWithdrawEnabled ==
                                          false)
                              ? const SizedBox()
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 5),
                                  child: InkWell(
                                    onTap: () {
                                      controller.selectedValue.value = 4;
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: themeChange.getThem()
                                            ? AppThemeData.grey800
                                            : AppThemeData.grey100,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              "assets/images/flutterwave_logo.png",
                                              height: 40,
                                              width: 100,
                                              color: themeChange.getThem()
                                                  ? AppThemeData.grey50
                                                  : null,
                                            ),
                                            const Expanded(
                                              child: SizedBox(),
                                            ),
                                            Radio(
                                              value: 4,
                                              visualDensity:
                                                  const VisualDensity(
                                                      horizontal: VisualDensity
                                                          .minimumDensity,
                                                      vertical: VisualDensity
                                                          .minimumDensity),
                                              groupValue: controller
                                                  .selectedValue.value,
                                              onChanged: (value) {
                                                controller.selectedValue.value =
                                                    value!;
                                              },
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                    bottomNavigationBar: SafeBottomWidget(
                      child: Container(
                        color: themeChange.getThem()
                            ? AppThemeData.grey800
                            : AppThemeData.grey100,
                        child: RoundedButtonFill(
                          title: "Withdraw".tr,
                          height: 5.5,
                          color: AppThemeData.primary300,
                          fontSizes: 16,
                          onPress: () async {
                            if (double.parse(controller
                                    .userModel.value.walletAmount
                                    .toString()) <
                                double.parse(controller
                                    .withdrawalAmountController.value.text)) {
                              ShowToastDialog.showToast(
                                  "Insufficient balance".tr);
                            } else if (double.parse(
                                    Constant.minimumAmountToWithdrawal) >
                                double.parse(controller
                                    .withdrawalAmountController.value.text)) {
                              ShowToastDialog.showToast(
                                  "Withdraw amount must be greater or equal to ${Constant.amountShow(amount: Constant.minimumAmountToWithdrawal.toString())}"
                                      .tr);
                            } else {
                              ShowToastDialog.showLoader("Please wait".tr);
                              WithdrawModel withdrawModel = WithdrawModel();
                              withdrawModel.id = Constant.getUuid();
                              withdrawModel.userId =
                                  FireStoreUtils.getCurrentUid();
                              withdrawModel.paymentStatus = "pending";
                              withdrawModel.amount = controller
                                  .withdrawalAmountController.value.text;
                              withdrawModel.note =
                                  controller.noteController.value.text;
                              withdrawModel.createdDate = Timestamp.now();
                              withdrawModel.withdrawMethod = controller
                                          .selectedValue.value ==
                                      0
                                  ? "bank"
                                  : controller.selectedValue.value == 1
                                      ? "stripe"
                                      : controller.selectedValue.value == 2
                                          ? "paypal"
                                          : controller.selectedValue.value == 3
                                              ? "razorpay"
                                              : "flutterwave";

                              await FireStoreUtils.updateUserWallet(
                                  amount:
                                      "-${controller.withdrawalAmountController.value.text}");

                              await FireStoreUtils.setWithdrawRequest(
                                      withdrawModel)
                                  .then((value) {
                                controller.getTraction();
                                ShowToastDialog.closeLoader();
                                ShowToastDialog.showToast(
                                    "Request sent to admin".tr);
                                Get.back();
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ));
  }

  showInformation(
      themeChange, BuildContext context, WithdrawModel transactionModel) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor:
          themeChange.getThem() ? AppThemeData.grey900 : AppThemeData.grey50,
      child: Container(
        padding:
            const EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Transaction Id",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: themeChange.getThem()
                    ? AppThemeData.grey100
                    : AppThemeData.grey800,
                fontSize: 14,
                fontFamily: AppThemeData.bold,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              transactionModel.id.toString(),
              textAlign: TextAlign.start,
              style: TextStyle(
                color: themeChange.getThem()
                    ? AppThemeData.primary300
                    : AppThemeData.primary300,
                fontSize: 16,
                fontFamily: AppThemeData.bold,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Withdraw method",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: themeChange.getThem()
                    ? AppThemeData.grey100
                    : AppThemeData.grey800,
                fontSize: 14,
                fontFamily: AppThemeData.bold,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              transactionModel.withdrawMethod.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: themeChange.getThem()
                    ? AppThemeData.primary300
                    : AppThemeData.primary300,
                fontSize: 16,
                fontFamily: AppThemeData.bold,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Time",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: themeChange.getThem()
                    ? AppThemeData.grey100
                    : AppThemeData.grey800,
                fontSize: 14,
                fontFamily: AppThemeData.bold,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              Constant.timestampToDateTime(transactionModel.createdDate!),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: themeChange.getThem()
                    ? AppThemeData.primary300
                    : AppThemeData.primary300,
                fontSize: 16,
                fontFamily: AppThemeData.bold,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Status",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: themeChange.getThem()
                    ? AppThemeData.grey100
                    : AppThemeData.grey800,
                fontSize: 14,
                fontFamily: AppThemeData.bold,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              transactionModel.paymentStatus!.toUpperCase(),
              style: TextStyle(
                  fontSize: 16,
                  fontFamily: AppThemeData.bold,
                  color: transactionModel.paymentStatus == "pending"
                      ? AppThemeData.warning300
                      : AppThemeData.success400),
            ),
            const SizedBox(
              height: 20,
            ),
            RoundedButtonFill(
              title: "Close".tr,
              color: themeChange.getThem()
                  ? AppThemeData.primary300
                  : AppThemeData.primary300,
              textColor: AppThemeData.grey50,
              onPress: () {
                Get.back();
              },
            )
          ],
        ),
      ),
    );
  }
}
