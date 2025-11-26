import 'package:get/get.dart';
import 'package:wevoride/model/booking_model.dart';
import 'package:wevoride/utils/fire_store_utils.dart';

class MyRideController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    getBookedRight();
    super.onInit();
  }

  RxBool isLoading = true.obs;
  RxList<BookingModel> myBooking = <BookingModel>[].obs;
  RxList<BookingModel> publisherBooking = <BookingModel>[].obs;

  getBookedRight() async {
    await FireStoreUtils.getMyBooking().then((value) {
      if (value != null) {
        myBooking.value = value;
      }
    });

    await FireStoreUtils.getPublishes().then((value) {
      if (value != null) {
        publisherBooking.value = value;
      }
    });
    isLoading.value = false;
  }
}
