import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wevoride/model/on_boarding_model.dart';
import 'package:wevoride/utils/fire_store_utils.dart';

class OnBoardingController extends GetxController {
  var selectedPageIndex = 0.obs;

  bool get isLastPage => selectedPageIndex.value == onBoardingList.length - 1;
  var pageController = PageController();

  @override
  void onInit() {
    getOnBoardingData();
    super.onInit();
  }

  RxBool isLoading = true.obs;
  RxList<OnBoardingModel> onBoardingList = <OnBoardingModel>[].obs;

  getOnBoardingData() async {
    await FireStoreUtils.getOnBoardingList().then((value) {
      onBoardingList.value = value;
    });

    // onBoardingList.add(OnBoardingModel(
    //   title: "Welcome to JourneyMate",
    //   description: "Your Trusted Companion for Hassle-Free Travel",
    //   id: "xs",
    //   image: "assets/images/onboarding_1.png",
    // ));
    // onBoardingList.add(OnBoardingModel(
    //   title: "Discover Ride sharing",
    //   description: "Find or Offer Rides to Your Destination",
    //   id: "xs",
    //   image: "assets/images/onboarding_2.png",
    // ));
    // onBoardingList.add(OnBoardingModel(
    //   title: "Connect with Fellow Travelers",
    //   description: "Share Your Journey, Share the Fun",
    //   id: "xs",
    //   image: "assets/images/onboarding_3.png",
    // ));
    isLoading.value = false;

    // await FireStoreUtils.getOnBoardingList().then((value) {
    //   onBoardingList.value = value;
    //   isLoading.value = false;
    // });
    update();
  }
}
