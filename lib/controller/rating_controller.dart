import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wevoride/model/booking_model.dart';
import 'package:wevoride/model/review_model.dart';
import 'package:wevoride/model/user_model.dart';
import 'package:wevoride/utils/fire_store_utils.dart';

class RatingController extends GetxController {
  RxBool isLoading = true.obs;
  RxDouble rating = 0.0.obs;
  Rx<TextEditingController> commentController = TextEditingController().obs;

  Rx<ReviewModel> reviewModel = ReviewModel().obs;

  Rx<BookingModel> bookingModel = BookingModel().obs;
  Rx<UserModel> senderUserModel = UserModel().obs;
  Rx<UserModel> reciverUserModel = UserModel().obs;

  @override
  void onInit() {
    super.onInit();
    getArgument();
  }

  getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      bookingModel.value = argumentData['bookingModel'];
      senderUserModel.value = argumentData['senderUserModel'];
      reciverUserModel.value = argumentData['reciverUserModel'];
    }
    log("senderUserModel :: ${senderUserModel.value.id}");
    log("reciverUserModel :: ${reciverUserModel.value.id}");
    await FireStoreUtils.getUserProfile(senderUserModel.value.toString()).then((value) {
      if (value != null) {
        senderUserModel.value = value;
      }
    });

    await FireStoreUtils.getReviewByReceiverId(bookingId: bookingModel.value.id ?? '', receiverId: reciverUserModel.value.id ?? '').then((value) {
      if (value != null) {
        reviewModel.value = value;
        rating.value = double.parse(reviewModel.value.rating.toString());
        commentController.value.text = reviewModel.value.comment.toString();
      }
    });
    isLoading.value = false;
    update();
  }
}
