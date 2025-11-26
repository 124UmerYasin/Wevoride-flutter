import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wevoride/model/payment_method_model.dart';
import 'package:wevoride/model/withdraw_method_model.dart';
import 'package:wevoride/utils/fire_store_utils.dart';

class PaymentSetupController extends GetxController {
  final accountNumberFlutterWave = TextEditingController().obs;
  final bankCodeFlutterWave = TextEditingController().obs;

  final emailPaypal = TextEditingController().obs;

  final accountIdRazorPay = TextEditingController().obs;

  final accountIdStripe = TextEditingController().obs;

  final bankName = TextEditingController().obs;
  final branchName = TextEditingController().obs;
  final holderName = TextEditingController().obs;
  final accountNumber = TextEditingController().obs;
  final otherDetails = TextEditingController().obs;

  RxBool isLoading = true.obs;
  Rx<WithdrawMethodModel> withdrawMethodModel = WithdrawMethodModel().obs;
  Rx<PaymentModel> paymentModel = PaymentModel().obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getPaymentSetting();
    getPaymentMethod();
    super.onInit();
  }

  getPaymentSetting() async {
    await FireStoreUtils().getPayment().then((value) {
      if (value != null) {
        paymentModel.value = value;
      }
    });
  }
  getPaymentMethod() async {
    accountNumberFlutterWave.value.clear();
    bankCodeFlutterWave.value.clear();
    emailPaypal.value.clear();
    accountIdRazorPay.value.clear();
    accountIdStripe.value.clear();

    await FireStoreUtils.getWithdrawMethod().then(
      (value) {
        if (value != null) {
          withdrawMethodModel.value = value;

          if (withdrawMethodModel.value.flutterWave != null) {
            accountNumberFlutterWave.value.text = withdrawMethodModel.value.flutterWave!.accountNumber.toString();
            bankCodeFlutterWave.value.text = withdrawMethodModel.value.flutterWave!.bankCode.toString();
          }

          if (withdrawMethodModel.value.paypal != null) {
            emailPaypal.value.text = withdrawMethodModel.value.paypal!.email.toString();
          }

          if (withdrawMethodModel.value.razorpay != null) {
            accountIdRazorPay.value.text = withdrawMethodModel.value.razorpay!.accountId.toString();
          }
          if (withdrawMethodModel.value.stripe != null) {
            accountIdStripe.value.text = withdrawMethodModel.value.stripe!.accountId.toString();
          }

          if (withdrawMethodModel.value.bank != null) {
            bankName.value.text = withdrawMethodModel.value.bank!.bankName.toString();
            branchName.value.text = withdrawMethodModel.value.bank!.branchName.toString();
            holderName.value.text = withdrawMethodModel.value.bank!.holderName.toString();
            accountNumber.value.text = withdrawMethodModel.value.bank!.accountNumber.toString();
            otherDetails.value.text = withdrawMethodModel.value.bank!.otherDetails.toString();
          }
        }
      },
    );
    isLoading.value = false;
  }
}
