import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wevoride/constant/constant.dart';
import 'package:wevoride/constant/show_toast_dialog.dart';
import 'package:wevoride/controller/payment_setup_controller.dart';
import 'package:wevoride/model/withdraw_method_model.dart';
import 'package:wevoride/themes/app_them_data.dart';
import 'package:wevoride/themes/responsive.dart';
import 'package:wevoride/themes/text_field_widget.dart';
import 'package:wevoride/utils/dark_theme_provider.dart';
import 'package:wevoride/utils/fire_store_utils.dart';
import 'package:provider/provider.dart';
import 'package:wevoride/widgets/custom_scaffold.dart';

class PaymentSetupScreen extends StatelessWidget {
  const PaymentSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: PaymentSetupController(),
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
                ),
              ),
              title: Text(
                "Withdraw method setup".tr,
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
                        children: [
                          controller.paymentModel.value.strip != null && controller.paymentModel.value.strip!.isWithdrawEnabled == false
                              ? const SizedBox()
                              : Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: themeChange.getThem() ? AppThemeData.grey900 : AppThemeData.grey50,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Image.asset(
                                                  "assets/images/stripe.png",
                                                  width: 80,
                                                  height: 40,
                                                  color: themeChange.getThem() ? AppThemeData.grey50 : null,
                                                ),
                                                const Expanded(
                                                  child: SizedBox(
                                                    height: 10,
                                                  ),
                                                ),
                                                controller.withdrawMethodModel.value.stripe == null
                                                    ? const SizedBox()
                                                    : Row(
                                                        children: [
                                                          InkWell(
                                                              onTap: () {
                                                                showDialog(
                                                                    context: context,
                                                                    builder: (BuildContext context) {
                                                                      return editStripe(themeChange, context, controller);
                                                                    });
                                                              },
                                                              child: Icon(
                                                                Icons.edit,
                                                                color: AppThemeData.primary300,
                                                              )),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          InkWell(
                                                              onTap: () async {
                                                                ShowToastDialog.showLoader("Please wait..");
                                                                controller.withdrawMethodModel.value.stripe = null;
                                                                await FireStoreUtils.setWithdrawMethod(controller.withdrawMethodModel.value).then(
                                                                  (value) async {
                                                                    await controller.getPaymentMethod();
                                                                    ShowToastDialog.closeLoader();
                                                                    ShowToastDialog.showToast("Payment Method remove successfully");
                                                                  },
                                                                );
                                                              },
                                                              child: const Icon(
                                                                Icons.delete,
                                                                color: AppThemeData.warning400,
                                                              )),
                                                        ],
                                                      )
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 5),
                                              child: controller.withdrawMethodModel.value.stripe != null
                                                  ? const Text(
                                                      "Setup was Done",
                                                      style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Poppinsl", color: Colors.green),
                                                    )
                                                  : Row(
                                                      children: [
                                                        Text(
                                                          "Setup is Pending.".tr,
                                                          style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: "Poppinsl", color: Colors.orange),
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            showDialog(
                                                                context: context,
                                                                builder: (BuildContext context) {
                                                                  return editStripe(themeChange, context, controller);
                                                                });
                                                          },
                                                          child: Text(
                                                            "Setup Now".tr,
                                                            style: TextStyle(
                                                                decorationColor: AppThemeData.primary300,
                                                                fontWeight: FontWeight.bold,
                                                                decoration: TextDecoration.underline,
                                                                fontFamily: "Poppinsl",
                                                                color: AppThemeData.primary300),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                          controller.paymentModel.value.paypal != null && controller.paymentModel.value.paypal!.isWithdrawEnabled == false
                              ? const SizedBox()
                              : Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: themeChange.getThem() ? AppThemeData.grey900 : AppThemeData.grey50,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Image.asset(
                                                  "assets/images/paypal.png",
                                                  width: 80,
                                                  height: 40,
                                                  color: themeChange.getThem() ? AppThemeData.grey50 : null,
                                                ),
                                                const Expanded(
                                                  child: SizedBox(
                                                    height: 10,
                                                  ),
                                                ),
                                                controller.withdrawMethodModel.value.paypal == null
                                                    ? const SizedBox()
                                                    : Row(
                                                        children: [
                                                          InkWell(
                                                              onTap: () {
                                                                showDialog(
                                                                    context: context,
                                                                    builder: (BuildContext context) {
                                                                      return editPaypal(themeChange, context, controller);
                                                                    });
                                                              },
                                                              child: Icon(
                                                                Icons.edit,
                                                                color: AppThemeData.primary300,
                                                              )),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          InkWell(
                                                              onTap: () async {
                                                                ShowToastDialog.showLoader("Please wait..");
                                                                controller.withdrawMethodModel.value.paypal = null;
                                                                await FireStoreUtils.setWithdrawMethod(controller.withdrawMethodModel.value).then(
                                                                  (value) async {
                                                                    await controller.getPaymentMethod();
                                                                    ShowToastDialog.closeLoader();
                                                                    ShowToastDialog.showToast("Payment Method remove successfully");
                                                                  },
                                                                );
                                                              },
                                                              child: const Icon(
                                                                Icons.delete,
                                                                color: AppThemeData.warning400,
                                                              )),
                                                        ],
                                                      )
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 5),
                                              child: controller.withdrawMethodModel.value.paypal != null
                                                  ? const Text(
                                                      "Setup was Done",
                                                      style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Poppinsl", color: Colors.green),
                                                    )
                                                  : Row(
                                                      children: [
                                                        Text(
                                                          "Setup is Pending.".tr,
                                                          style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: "Poppinsl", color: Colors.orange),
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            showDialog(
                                                                context: context,
                                                                builder: (BuildContext context) {
                                                                  return editPaypal(themeChange, context, controller);
                                                                });
                                                          },
                                                          child: Text(
                                                            "Setup Now".tr,
                                                            style: TextStyle(
                                                                decorationColor: AppThemeData.primary300,
                                                                fontWeight: FontWeight.bold,
                                                                decoration: TextDecoration.underline,
                                                                fontFamily: "Poppinsl",
                                                                color: AppThemeData.primary300),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                          controller.paymentModel.value.razorpay != null && controller.paymentModel.value.razorpay!.isWithdrawEnabled == false
                              ? const SizedBox()
                              : Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: themeChange.getThem() ? AppThemeData.grey900 : AppThemeData.grey50,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Image.asset(
                                                  "assets/images/razorpay.png",
                                                  width: 80,
                                                  height: 40,
                                                  color: themeChange.getThem() ? AppThemeData.grey50 : null,
                                                ),
                                                const Expanded(
                                                  child: SizedBox(
                                                    height: 10,
                                                  ),
                                                ),
                                                controller.withdrawMethodModel.value.razorpay == null
                                                    ? const SizedBox()
                                                    : Row(
                                                        children: [
                                                          InkWell(
                                                              onTap: () {
                                                                showDialog(
                                                                    context: context,
                                                                    builder: (BuildContext context) {
                                                                      return editRazorPay(themeChange, context, controller);
                                                                    });
                                                              },
                                                              child: Icon(
                                                                Icons.edit,
                                                                color: AppThemeData.primary300,
                                                              )),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          InkWell(
                                                              onTap: () async {
                                                                ShowToastDialog.showLoader("Please wait..");
                                                                controller.withdrawMethodModel.value.razorpay = null;
                                                                await FireStoreUtils.setWithdrawMethod(controller.withdrawMethodModel.value).then(
                                                                  (value) async {
                                                                    await controller.getPaymentMethod();
                                                                    ShowToastDialog.closeLoader();
                                                                    ShowToastDialog.showToast("Payment Method remove successfully");
                                                                  },
                                                                );
                                                              },
                                                              child: const Icon(
                                                                Icons.delete,
                                                                color: AppThemeData.warning400,
                                                              )),
                                                        ],
                                                      )
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 5),
                                              child: controller.withdrawMethodModel.value.razorpay != null
                                                  ? const Text(
                                                      "Setup was Done",
                                                      style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Poppinsl", color: Colors.green),
                                                    )
                                                  : Row(
                                                      children: [
                                                        Text(
                                                          "Setup is Pending.".tr,
                                                          style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: "Poppinsl", color: Colors.orange),
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            showDialog(
                                                                context: context,
                                                                builder: (BuildContext context) {
                                                                  return editRazorPay(themeChange, context, controller);
                                                                });
                                                          },
                                                          child: Text(
                                                            "Setup Now".tr,
                                                            style: TextStyle(
                                                                decorationColor: AppThemeData.primary300,
                                                                fontWeight: FontWeight.bold,
                                                                decoration: TextDecoration.underline,
                                                                fontFamily: "Poppinsl",
                                                                color: AppThemeData.primary300),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                          controller.paymentModel.value.flutterWave != null && controller.paymentModel.value.flutterWave!.isWithdrawEnabled == false
                              ? const SizedBox()
                              : Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: themeChange.getThem() ? AppThemeData.grey900 : AppThemeData.grey50,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Image.asset(
                                                  "assets/images/flutterwave_logo.png",
                                                  width: 80,
                                                  height: 40,
                                                  color: themeChange.getThem() ? AppThemeData.grey50 : null,
                                                ),
                                                const Expanded(
                                                  child: SizedBox(
                                                    height: 10,
                                                  ),
                                                ),
                                                controller.withdrawMethodModel.value.flutterWave == null
                                                    ? const SizedBox()
                                                    : Row(
                                                        children: [
                                                          InkWell(
                                                              onTap: () {
                                                                showDialog(
                                                                    context: context,
                                                                    builder: (BuildContext context) {
                                                                      return editFlutterWave(themeChange, context, controller);
                                                                    });
                                                              },
                                                              child: Icon(
                                                                Icons.edit,
                                                                color: AppThemeData.primary300,
                                                              )),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          InkWell(
                                                              onTap: () async {
                                                                ShowToastDialog.showLoader("Please wait..");
                                                                controller.withdrawMethodModel.value.flutterWave = null;
                                                                await FireStoreUtils.setWithdrawMethod(controller.withdrawMethodModel.value).then(
                                                                  (value) async {
                                                                    await controller.getPaymentMethod();
                                                                    ShowToastDialog.closeLoader();
                                                                    ShowToastDialog.showToast("Payment Method remove successfully");
                                                                  },
                                                                );
                                                              },
                                                              child: const Icon(
                                                                Icons.delete,
                                                                color: AppThemeData.warning400,
                                                              )),
                                                        ],
                                                      )
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 5),
                                              child: controller.withdrawMethodModel.value.flutterWave != null
                                                  ? const Text(
                                                      "Setup was Done",
                                                      style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Poppinsl", color: Colors.green),
                                                    )
                                                  : Row(
                                                      children: [
                                                        Text(
                                                          "Setup is Pending.".tr,
                                                          style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: "Poppinsl", color: Colors.orange),
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            showDialog(
                                                                context: context,
                                                                builder: (BuildContext context) {
                                                                  return editFlutterWave(themeChange, context, controller);
                                                                });
                                                          },
                                                          child: Text(
                                                            "Setup Now".tr,
                                                            style: TextStyle(
                                                                decorationColor: AppThemeData.primary300,
                                                                fontWeight: FontWeight.bold,
                                                                decoration: TextDecoration.underline,
                                                                fontFamily: "Poppinsl",
                                                                color: AppThemeData.primary300),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                          Container(
                            decoration: BoxDecoration(
                              color: themeChange.getThem() ? AppThemeData.grey900 : AppThemeData.grey50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(
                                        "assets/images/ic_bank.png",
                                        height: 40,
                                        color: themeChange.getThem() ? AppThemeData.grey50 : null,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Expanded(
                                        child: Text(
                                          "Bank Transfer",
                                          style: TextStyle(fontWeight: FontWeight.bold, color: AppThemeData.grey900),
                                        ),
                                      ),
                      
                                      controller.withdrawMethodModel.value.bank == null
                                          ? const SizedBox()
                                          : Row(
                                              children: [
                                                InkWell(
                                                    onTap: () {
                                                      showDialog(
                                                          context: context,
                                                          builder: (BuildContext context) {
                                                            return editBank(themeChange, context, controller);
                                                          });
                                                    },
                                                    child: Icon(
                                                      Icons.edit,
                                                      color: AppThemeData.primary300,
                                                    )),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                InkWell(
                                                    onTap: () async {
                                                      ShowToastDialog.showLoader("Please wait..");
                                                      controller.withdrawMethodModel.value.bank = null;
                                                      await FireStoreUtils.setWithdrawMethod(controller.withdrawMethodModel.value).then(
                                                        (value) async {
                                                          await controller.getPaymentMethod();
                                                          ShowToastDialog.closeLoader();
                                                          ShowToastDialog.showToast("Payment Method remove successfully");
                                                        },
                                                      );
                                                    },
                                                    child: const Icon(
                                                      Icons.delete,
                                                      color: AppThemeData.warning400,
                                                    )),
                                              ],
                                            )
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 5),
                                    child: controller.withdrawMethodModel.value.bank != null
                                        ? const Text(
                                            "Setup was Done",
                                            style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Poppinsl", color: Colors.green),
                                          )
                                        : Row(
                                            children: [
                                              Text(
                                                "Setup is Pending.".tr,
                                                style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: "Poppinsl", color: Colors.orange),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext context) {
                                                        return editBank(themeChange, context, controller);
                                                      });
                                                },
                                                child: Text(
                                                  "Setup Now".tr,
                                                  style: TextStyle(
                                                      decorationColor: AppThemeData.primary300,
                                                      fontWeight: FontWeight.bold,
                                                      decoration: TextDecoration.underline,
                                                      fontFamily: "Poppinsl",
                                                      color: AppThemeData.primary300),
                                                ),
                                              ),
                                            ],
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          );
        });
  }

  editStripe(themeChange, BuildContext context, PaymentSetupController controller) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: themeChange.getThem() ? AppThemeData.grey900 : AppThemeData.grey50,
      child: Container(
        padding: const EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Stripe",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: themeChange.getThem() ? AppThemeData.primary300 : AppThemeData.primary300,
                fontSize: 20,
                fontFamily: AppThemeData.bold,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFieldWidget(
              title: 'Stripe Account Id'.tr,
              hintText: 'Stripe Account Id'.tr,
              controller: controller.accountIdStripe.value,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Text(
                "Go to your Stripe account settings > Account details > Copy your account ID on the right-hand side. For example, acc_GLGeLkU2JUeyDZ".tr,
                style: TextStyle(fontFamily: AppThemeData.regular, color: themeChange.getThem() ? AppThemeData.grey200 : AppThemeData.grey700),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      width: Responsive.width(100, context),
                      height: Responsive.height(5, context),
                      decoration: ShapeDecoration(
                        color: themeChange.getThem() ? AppThemeData.grey700 : AppThemeData.grey200,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(200),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Cancel",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: AppThemeData.medium,
                              color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey900,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      if (controller.accountIdStripe.value.text.isEmpty) {
                        ShowToastDialog.showToast("Please enter stripe account id.");
                      }else{
                        ShowToastDialog.showLoader("Please wait..");
                        Stripe? stripe = controller.withdrawMethodModel.value.stripe;
                        if (stripe != null) {
                          stripe.accountId = controller.accountIdStripe.value.text;
                        } else {
                          stripe = Stripe(accountId: controller.accountIdStripe.value.text, name: "Stripe");
                        }
                        controller.withdrawMethodModel.value.stripe = stripe;
                        await FireStoreUtils.setWithdrawMethod(controller.withdrawMethodModel.value).then(
                              (value) async {
                            await controller.getPaymentMethod();
                            ShowToastDialog.closeLoader();
                            ShowToastDialog.showToast("Payment Method save successfully");
                            Get.back();
                          },
                        );
                      }

                    },
                    child: Container(
                      width: Responsive.width(100, context),
                      height: Responsive.height(5, context),
                      decoration: ShapeDecoration(
                        color: AppThemeData.primary300,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(200),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Save",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: AppThemeData.medium,
                              color: AppThemeData.grey50,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  editPaypal(themeChange, BuildContext context, PaymentSetupController controller) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: themeChange.getThem() ? AppThemeData.grey900 : AppThemeData.grey50,
      child: Container(
        padding: const EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "PayPal",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: themeChange.getThem() ? AppThemeData.primary300 : AppThemeData.primary300,
                fontSize: 20,
                fontFamily: AppThemeData.bold,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFieldWidget(
              title: 'Paypal email'.tr,
              hintText: 'Enter Paypal email'.tr,
              controller: controller.emailPaypal.value,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Text(
                "Insert your paypal email id".tr,
                style: TextStyle(fontFamily: AppThemeData.regular, color: themeChange.getThem() ? AppThemeData.grey200 : AppThemeData.grey700),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      width: Responsive.width(100, context),
                      height: Responsive.height(5, context),
                      decoration: ShapeDecoration(
                        color: themeChange.getThem() ? AppThemeData.grey700 : AppThemeData.grey200,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(200),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Cancel",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: AppThemeData.medium,
                              color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey900,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      if (controller.emailPaypal.value.text.isEmpty) {
                        ShowToastDialog.showToast("Please enter paypal email Id");
                      } else {
                        ShowToastDialog.showLoader("Please wait..");
                        Paypal? payPal = controller.withdrawMethodModel.value.paypal;
                        if (payPal != null) {
                          payPal.email = controller.emailPaypal.value.text;
                        } else {
                          payPal = Paypal(email: controller.emailPaypal.value.text, name: "PayPal");
                        }
                        controller.withdrawMethodModel.value.paypal = payPal;
                        await FireStoreUtils.setWithdrawMethod(controller.withdrawMethodModel.value).then(
                          (value) async {
                            await controller.getPaymentMethod();
                            ShowToastDialog.closeLoader();
                            ShowToastDialog.showToast("Payment Method save successfully");
                            Get.back();
                          },
                        );
                      }
                    },
                    child: Container(
                      width: Responsive.width(100, context),
                      height: Responsive.height(5, context),
                      decoration: ShapeDecoration(
                        color: AppThemeData.primary300,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(200),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Save",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: AppThemeData.medium,
                              color: AppThemeData.grey50,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  editRazorPay(themeChange, BuildContext context, PaymentSetupController controller) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: themeChange.getThem() ? AppThemeData.grey900 : AppThemeData.grey50,
      child: Container(
        padding: const EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "RazorPay",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: themeChange.getThem() ? AppThemeData.primary300 : AppThemeData.primary300,
                fontSize: 20,
                fontFamily: AppThemeData.bold,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFieldWidget(
              title: 'Razorpay account Id'.tr,
              hintText: 'Razorpay account Id'.tr,
              controller: controller.accountIdRazorPay.value,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Text(
                "Add your Account ID. For example, acc_GLGeLkU2JUeyDZ".tr,
                style: TextStyle(fontFamily: AppThemeData.regular, color: themeChange.getThem() ? AppThemeData.grey200 : AppThemeData.grey700),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      width: Responsive.width(100, context),
                      height: Responsive.height(5, context),
                      decoration: ShapeDecoration(
                        color: themeChange.getThem() ? AppThemeData.grey700 : AppThemeData.grey200,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(200),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Cancel",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: AppThemeData.medium,
                              color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey900,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      if (controller.accountIdRazorPay.value.text.isEmpty) {
                        ShowToastDialog.showToast("Please enter RazorPay Id");
                      } else {
                        ShowToastDialog.showLoader("Please wait..");
                        RazorpayModel? razorPay = controller.withdrawMethodModel.value.razorpay;
                        if (razorPay != null) {
                          razorPay.accountId = controller.accountIdRazorPay.value.text;
                        } else {
                          razorPay = RazorpayModel(accountId: controller.accountIdRazorPay.value.text, name: "RazorPay");
                        }
                        controller.withdrawMethodModel.value.razorpay = razorPay;
                        await FireStoreUtils.setWithdrawMethod(controller.withdrawMethodModel.value).then(
                          (value) async {
                            await controller.getPaymentMethod();
                            ShowToastDialog.closeLoader();
                            ShowToastDialog.showToast("Payment Method save successfully");
                            Get.back();
                          },
                        );
                      }
                    },
                    child: Container(
                      width: Responsive.width(100, context),
                      height: Responsive.height(5, context),
                      decoration: ShapeDecoration(
                        color: AppThemeData.primary300,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(200),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Save",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: AppThemeData.medium,
                              color: AppThemeData.grey50,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  editFlutterWave(themeChange, BuildContext context, PaymentSetupController controller) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: themeChange.getThem() ? AppThemeData.grey900 : AppThemeData.grey50,
      child: Container(
        padding: const EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "FlutterWave",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: themeChange.getThem() ? AppThemeData.primary300 : AppThemeData.primary300,
                fontSize: 20,
                fontFamily: AppThemeData.bold,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFieldWidget(
              title: 'Account Number'.tr,
              hintText: 'Account Number'.tr,
              controller: controller.accountNumberFlutterWave.value,
            ),
            TextFieldWidget(
              title: 'Bank Code'.tr,
              hintText: 'Bank Code'.tr,
              controller: controller.bankCodeFlutterWave.value,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      width: Responsive.width(100, context),
                      height: Responsive.height(5, context),
                      decoration: ShapeDecoration(
                        color: themeChange.getThem() ? AppThemeData.grey700 : AppThemeData.grey200,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(200),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Cancel",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: AppThemeData.medium,
                              color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey900,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      if (controller.accountNumberFlutterWave.value.text.isEmpty) {
                        ShowToastDialog.showToast("Please enter account number");
                      } else if (controller.bankCodeFlutterWave.value.text.isEmpty) {
                        ShowToastDialog.showToast("Please enter bank code");
                      } else {
                        ShowToastDialog.showLoader("Please wait..");
                        FlutterWave? flutterWave = controller.withdrawMethodModel.value.flutterWave;
                        if (flutterWave != null) {
                          flutterWave.accountNumber = controller.accountNumberFlutterWave.value.text;
                          flutterWave.bankCode = controller.bankCodeFlutterWave.value.text;
                        } else {
                          flutterWave =
                              FlutterWave(accountNumber: controller.accountNumberFlutterWave.value.text, bankCode: controller.bankCodeFlutterWave.value.text, name: "FlutterWave");
                        }
                        controller.withdrawMethodModel.value.flutterWave = flutterWave;
                        await FireStoreUtils.setWithdrawMethod(controller.withdrawMethodModel.value).then(
                          (value) async {
                            await controller.getPaymentMethod();
                            ShowToastDialog.closeLoader();
                            ShowToastDialog.showToast("Payment Method save successfully");
                            Get.back();
                          },
                        );
                      }
                    },
                    child: Container(
                      width: Responsive.width(100, context),
                      height: Responsive.height(5, context),
                      decoration: ShapeDecoration(
                        color: AppThemeData.primary300,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(200),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Save",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: AppThemeData.medium,
                              color: AppThemeData.grey50,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  editBank(themeChange, BuildContext context, PaymentSetupController controller) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: themeChange.getThem() ? AppThemeData.grey900 : AppThemeData.grey50,
      child: Container(
        padding: const EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Bank Information",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: themeChange.getThem() ? AppThemeData.primary300 : AppThemeData.primary300,
                  fontSize: 20,
                  fontFamily: AppThemeData.bold,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFieldWidget(
                title: 'Bank Name'.tr,
                hintText: 'Bank Name'.tr,
                controller: controller.bankName.value,
              ),
              TextFieldWidget(
                title: 'Branch Name'.tr,
                hintText: 'Branch Name'.tr,
                controller: controller.branchName.value,
              ),
              TextFieldWidget(
                title: 'Account Holder Name'.tr,
                hintText: 'Account Holder Name'.tr,
                controller: controller.holderName.value,
              ),
              TextFieldWidget(
                title: 'Bank Account Number'.tr,
                hintText: 'Bank Account Number'.tr,
                controller: controller.accountNumber.value,
              ),
              TextFieldWidget(
                title: 'Other Details'.tr,
                hintText: 'Other Details'.tr,
                controller: controller.otherDetails.value,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        width: Responsive.width(100, context),
                        height: Responsive.height(5, context),
                        decoration: ShapeDecoration(
                          color: themeChange.getThem() ? AppThemeData.grey700 : AppThemeData.grey200,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(200),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Cancel",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: AppThemeData.medium,
                                color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey900,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        if (controller.bankName.value.text.isEmpty) {
                          ShowToastDialog.showToast("Please enter bank name");
                        } else if (controller.branchName.value.text.isEmpty) {
                          ShowToastDialog.showToast("Please enter branch name");
                        } else if (controller.holderName.value.text.isEmpty) {
                          ShowToastDialog.showToast("Please enter bank holder name");
                        } else if (controller.accountNumber.value.text.isEmpty) {
                          ShowToastDialog.showToast("Please enter bank account number");
                        } else {
                          ShowToastDialog.showLoader("Please wait..");
                          Bank? bank = controller.withdrawMethodModel.value.bank;
                          if (bank != null) {
                            bank.bankName = controller.bankName.value.text;
                            bank.branchName = controller.branchName.value.text;
                            bank.holderName = controller.holderName.value.text;
                            bank.accountNumber = controller.accountNumber.value.text;
                            bank.otherDetails = controller.otherDetails.value.text;
                          } else {
                            bank = Bank(
                                bankName: controller.bankName.value.text,
                                branchName: controller.branchName.value.text,
                                holderName: controller.holderName.value.text,
                                accountNumber: controller.accountNumber.value.text,
                                otherDetails: controller.otherDetails.value.text,
                                name: "Bank");
                          }
                          controller.withdrawMethodModel.value.bank = bank;
                          await FireStoreUtils.setWithdrawMethod(controller.withdrawMethodModel.value).then(
                            (value) async {
                              await controller.getPaymentMethod();
                              ShowToastDialog.closeLoader();
                              ShowToastDialog.showToast("Payment Method save successfully");
                              Get.back();
                            },
                          );
                        }
                      },
                      child: Container(
                        width: Responsive.width(100, context),
                        height: Responsive.height(5, context),
                        decoration: ShapeDecoration(
                          color: AppThemeData.primary300,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(200),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Save",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: AppThemeData.medium,
                                color: AppThemeData.grey50,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
