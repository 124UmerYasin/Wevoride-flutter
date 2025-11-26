import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:wevoride/app/home_screen/booking_success_screen.dart';
import 'package:wevoride/constant/collection_name.dart';
import 'package:wevoride/constant/send_notification.dart';
import 'package:wevoride/constant/show_toast_dialog.dart';
import 'package:wevoride/controller/home_controller.dart';
import 'package:wevoride/model/booking_model.dart';
import 'package:wevoride/model/stop_over_model.dart';
import 'package:wevoride/model/user_model.dart';
import 'package:wevoride/utils/fire_store_utils.dart';
import 'package:wevoride/constant/constant.dart';

class BookingDetailsController extends GetxController {
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    getArgument();
    super.onInit();
  }

  HomeController homeController = Get.find<HomeController>();
  Rx<BookingModel> bookingModel = BookingModel().obs;
  Rx<StopOverModel> stopOverModel = StopOverModel().obs;
  Rx<BookedUserModel> bookingUserModel = BookedUserModel().obs;

  Rx<String> paymentType = "".obs;
  Rx<UserModel> publisherUserModel = UserModel().obs;
  Rx<UserModel> userModel = UserModel().obs;

  getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      bookingModel.value = argumentData['bookingModel'];
      stopOverModel.value = argumentData['stopOverModel'];
    }

    FireStoreUtils.fireStore.collection(CollectionName.booking).doc(bookingModel.value.id).snapshots().listen(
      (event) {
        bookingModel.value = BookingModel.fromJson(event.data()!);
      },
    );

    if (bookingModel.value.status == Constant.onGoing) {
      await FireStoreUtils.getMyBookingUser(bookingModel.value).then((value) {
        if (value != null) {
          bookingUserModel.value = value;
        }
      });
    }

    await FireStoreUtils.getUserProfile(bookingModel.value.createdBy.toString()).then((value) {
      publisherUserModel.value = value!;
    });

    await FireStoreUtils.getUserProfile(FireStoreUtils.getCurrentUid()).then((value) {
      userModel.value = value!;
    });
    isLoading.value = false;
  }

  bookingPlace() async {
    if (bookingModel.value.bookedUserId!.contains(FireStoreUtils.getCurrentUid()) == false) {
      bookingModel.value.bookedUserId!.add(FireStoreUtils.getCurrentUid());
    }
    bookingModel.value.bookedSeat = (int.parse(bookingModel.value.bookedSeat.toString()) + int.parse(homeController.numberOfSheet.value.toString())).toString();

    BookedUserModel bookingUserModel = BookedUserModel();
    bookingUserModel.id = FireStoreUtils.getCurrentUid();
    bookingUserModel.bookedSeat = homeController.numberOfSheet.value.toString();
    bookingUserModel.paymentStatus = false;
    bookingUserModel.paymentType = paymentType.value;
    bookingUserModel.stopOver = stopOverModel.value;
    bookingUserModel.createdAt = Timestamp.now();
    bookingUserModel.pickupLocation = homeController.pickUpLocation.value;
    bookingUserModel.dropLocation = homeController.dropLocation.value;
    bookingUserModel.adminCommission = Constant.adminCommission;
    bookingUserModel.taxList = Constant.taxList;
    bookingUserModel.subTotal = (double.parse(stopOverModel.value.price.toString()) * double.parse(homeController.numberOfSheet.value.toString())).toString();

    ShowToastDialog.showLoader("Please wait..");
    await FireStoreUtils.setUserBooking(bookingModel.value, bookingUserModel);
    await SendNotification.sendOneNotification(type: Constant.booking_confirmed, token: publisherUserModel.value.fcmToken.toString(), payload: {});

    await FireStoreUtils.setBooking(bookingModel.value).then((value) {
      ShowToastDialog.closeLoader();
      Get.off(const BookingSuccessScreen());
      clearData();
    });
  }

  clearData() {
    homeController.pickUpLocationController.value.clear();
    homeController.dropLocationController.value.clear();
  }
}
