import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:wevoride/app/payment/force_payment_screen.dart';
import 'package:wevoride/constant/constant.dart';
import 'package:wevoride/constant/send_notification.dart';
import 'package:wevoride/constant/show_toast_dialog.dart';
import 'package:wevoride/model/booking_model.dart';
import 'package:wevoride/model/user_model.dart';
import 'package:wevoride/model/wallet_transaction_model.dart';
import 'package:wevoride/utils/fire_store_utils.dart';
import 'package:get/get.dart';

import '../constant/collection_name.dart';
import '../model/review_model.dart';

class BookedDetailsController extends GetxController {
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    getArgument();
    super.onInit();
  }

  Rx<BookingModel> bookingModel = BookingModel().obs;
  Rx<BookedUserModel> bookingUserModel = BookedUserModel().obs;
  Rx<String> paymentType = "".obs;
  Rx<UserModel> userModel = UserModel().obs;
  Rx<UserModel> publisherUserModel = UserModel().obs;

  Rx<ReviewModel> reviewModel = ReviewModel().obs;

  getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      bookingModel.value = argumentData['bookingModel'];
      bookingUserModel.value = argumentData['bookingUserModel'];
    }
    await FireStoreUtils.getUserProfile(FireStoreUtils.getCurrentUid())
        .then((value) {
      userModel.value = value!;
    });
    FireStoreUtils.fireStore
        .collection(CollectionName.booking)
        .doc(bookingModel.value.id)
        .snapshots()
        .listen(
      (event) async {
        bookingModel.value = BookingModel.fromJson(event.data()!);
        // Check if payment is required when status changes
        await checkPaymentRequired();
      },
    );
    await getUserData();
    await getReview();
    isLoading.value = false;

    // Check if payment is required on initial load
    await checkPaymentRequired();
  }

  /// Check if payment is required and show force payment screen
  /// Only shows when trip status is "completed" (when driver clicks "Reached")
  Future<void> checkPaymentRequired() async {
    try {
      // Refresh booked user data
      var updatedBookedUser =
          await FireStoreUtils.getMyBookingUser(bookingModel.value);
      if (updatedBookedUser != null) {
        bookingUserModel.value = updatedBookedUser;
      }

      // Check if payment is required - only for completed trips (when driver clicks "Reached")
      if (bookingModel.value.status == Constant.completed &&
          bookingUserModel.value.paymentStatus == false) {
        // Small delay to ensure screen is ready
        await Future.delayed(const Duration(milliseconds: 500));

        // Show force payment screen
        Get.to(
          () => ForcePaymentScreen(
            bookingModel: bookingModel.value,
            bookedUserModel: bookingUserModel.value,
          ),
        );
      }
    } catch (e) {
      print("Error checking payment required: $e");
    }
  }

  getReview() async {
    await FireStoreUtils.getReview(
            bookingId: bookingModel.value.id ?? "",
            senderId: FireStoreUtils.getCurrentUid())
        .then((value) {
      if (value != null) {
        reviewModel.value = value;
      }
    });
  }

  getUserData() async {
    await FireStoreUtils.getUserProfile(bookingModel.value.createdBy.toString())
        .then((value) {
      publisherUserModel.value = value!;
    });
  }

  double calculateAmount() {
    RxString taxAmount = "0.0".obs;
    if (bookingUserModel.value.taxList != null) {
      for (var element in bookingUserModel.value.taxList!) {
        taxAmount.value = (double.parse(taxAmount.value) +
                Constant().calculateTax(
                    amount: bookingUserModel.value.subTotal.toString(),
                    taxModel: element))
            .toStringAsFixed(Constant.currencyModel!.decimalDigits!);
      }
    }
    return (double.parse(bookingUserModel.value.subTotal.toString())) +
        double.parse(taxAmount.value);
  }

  paymentCompleted() async {
    ShowToastDialog.showLoader("Please wait..");
    bookingUserModel.value.paymentStatus = true;
    bookingUserModel.value.paymentType = paymentType.value;

    if (paymentType.value.toLowerCase() != "cash") {
      WalletTransactionModel transactionModel = WalletTransactionModel(
          id: Constant.getUuid(),
          amount: calculateAmount().toString(),
          createdDate: Timestamp.now(),
          paymentType: paymentType.value,
          transactionId: bookingModel.value.id,
          isCredit: true,
          type: "publisher",
          userId: bookingModel.value.createdBy.toString(),
          note: "Amount credited for ${userModel.value.fullName()} ride");

      await FireStoreUtils.setWalletTransaction(transactionModel)
          .then((value) async {
        if (value == true) {
          await FireStoreUtils.updateOtherUserWallet(
              amount: calculateAmount().toString(),
              id: bookingModel.value.createdBy.toString());
        }
      });
    }

    if (bookingUserModel.value.adminCommission != null &&
        bookingUserModel.value.adminCommission!.enable == true) {
      WalletTransactionModel adminCommissionWallet = WalletTransactionModel(
          id: Constant.getUuid(),
          amount:
              "-${Constant.calculateOrderAdminCommission(amount: double.parse(bookingUserModel.value.subTotal.toString()).toString(), adminCommission: bookingUserModel.value.adminCommission)}",
          createdDate: Timestamp.now(),
          paymentType: "wallet",
          isCredit: false,
          type: "publisher",
          transactionId: bookingModel.value.id,
          userId: bookingModel.value.createdBy.toString(),
          note: "Admin commission debited for  ${userModel.value.fullName()}");

      await FireStoreUtils.setWalletTransaction(adminCommissionWallet)
          .then((value) async {
        if (value == true) {
          await FireStoreUtils.updateOtherUserWallet(
              amount:
                  "-${Constant.calculateOrderAdminCommission(amount: bookingUserModel.value.subTotal.toString(), adminCommission: bookingUserModel.value.adminCommission)}",
              id: bookingModel.value.createdBy.toString());
        }
      });
    }

    await FireStoreUtils.setUserBooking(
        bookingModel.value, bookingUserModel.value);
    await SendNotification.sendOneNotification(
        type: Constant.payment_successful,
        token: publisherUserModel.value.fcmToken.toString(),
        payload: {});

    await FireStoreUtils.setBooking(bookingModel.value).then((value) {
      ShowToastDialog.closeLoader();
      // Try to go back - if we're in force payment screen, this might not work
      // but the caller (force payment screen) will handle navigation with Get.offAll()
      try {
        Get.back(result: true);
      } catch (e) {
        // If navigation fails (e.g., in force payment screen with PopScope canPop: false),
        // the caller will handle navigation
        print("Navigation will be handled by caller: $e");
      }
    });
  }
}
