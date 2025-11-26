import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wevoride/model/booking_model.dart';
import 'package:wevoride/constant/collection_name.dart';
import 'package:wevoride/constant/constant.dart';
import 'package:wevoride/constant/show_toast_dialog.dart';
import 'package:wevoride/model/report_model.dart';
import 'package:wevoride/utils/fire_store_utils.dart';

class ReportHelpController extends GetxController {
  RxBool isLoading = true.obs;

  RxString reportedBy = "".obs;
  RxString reportedTo = "".obs;
  RxString bookingId = "".obs;

  List<dynamic> customerList = <dynamic>[].obs;
  List<dynamic> publisherList = <dynamic>[].obs;

  RxString selectedReasons = "".obs;
  Rx<TextEditingController> descriptionController = TextEditingController().obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getArgument();

    super.onInit();
  }

  getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      reportedBy.value = argumentData['reportedBy'];
      reportedTo.value = argumentData['reportedTo'];
      bookingId.value = argumentData['bookingId'];
    }
    await getReportList();
  }

  getReportList() async {
    await FireStoreUtils.fireStore.collection(CollectionName.settings).doc("reasons").get().then((event) {
      if (event.exists) {
        customerList = event.data()!["customer"];
        publisherList = event.data()!["publisher"];
        update();
      }
    });
    isLoading.value = false;

  }

  publishReport() async {
    ReportModel reportModel = ReportModel();
    reportModel.id = Constant.getUuid();
    reportModel.title = selectedReasons.value;
    reportModel.description = descriptionController.value.text;
    reportModel.reportedFrom = FireStoreUtils.getCurrentUid();
    reportModel.reportedTo = reportedTo.value;
    reportModel.status = "Pending";
    reportModel.bookingId = bookingId.value;

    await FireStoreUtils.setReport(reportModel).then((value) async {
      // Set ride status to completed when user reports the ride
      if (bookingId.value.toString().isNotEmpty) {
        try {
          // Fetch the booking
          DocumentSnapshot bookingDoc = await FireStoreUtils.fireStore.collection(CollectionName.booking).doc(bookingId.value).get();
          if (bookingDoc.exists) {
            BookingModel bookingModel = BookingModel.fromJson(bookingDoc.data() as Map<String, dynamic>);
            bookingModel.status = Constant.completed;
            await FireStoreUtils.setBooking(bookingModel);

            // Mark payment status as paid when report is submitted
            try {
              var bookedUserDoc = await FireStoreUtils.fireStore
                  .collection(CollectionName.booking)
                  .doc(bookingId.value)
                  .collection("bookedUser")
                  .doc(FireStoreUtils.getCurrentUid())
                  .get();

              if (bookedUserDoc.exists) {
                await FireStoreUtils.fireStore
                    .collection(CollectionName.booking)
                    .doc(bookingId.value)
                    .collection("bookedUser")
                    .doc(FireStoreUtils.getCurrentUid())
                    .update({'paymentStatus': true});
                print("✓ Payment status marked as PAID for booking: ${bookingId.value}");
                
                // Wait a moment to ensure Firestore write completes
                await Future.delayed(const Duration(milliseconds: 500));
              } else {
                print("✗ bookedUser document not found for booking: ${bookingId.value}");
              }
            } catch (e) {
              print("✗ Error updating payment status: $e");
            }
          }
        } catch (e) {
          print("✗ Error in publishReport: $e");
        }
      }
      ShowToastDialog.showToast("Report place successfully");
      Get.back();
    }).catchError((error) {
      print("✗ Error setting report: $error");
      ShowToastDialog.showToast("Error submitting report");
    });
  }
}


