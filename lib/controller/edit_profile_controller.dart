import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wevoride/constant/constant.dart';
import 'package:wevoride/constant/show_toast_dialog.dart';
import 'package:wevoride/model/user_model.dart';
import 'package:wevoride/utils/fire_store_utils.dart';

class EditProfileController extends GetxController {
  RxBool isLoading = true.obs;
  Rx<UserModel> userModel = UserModel().obs;

  Rx<TextEditingController> firstNameController = TextEditingController().obs;
  Rx<TextEditingController> lastNameController = TextEditingController().obs;
  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> phoneNumberController = TextEditingController().obs;
  Rx<TextEditingController> dateOfBirthController = TextEditingController().obs;
  Rx<TextEditingController> bioController = TextEditingController().obs;
  Rx<TextEditingController> countryCodeController = TextEditingController(text: "+962").obs;
  RxString preAddressOfName = "Mr.".obs;

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  getData() async {
    await FireStoreUtils.getUserProfile(FireStoreUtils.getCurrentUid()).then((value) {
      if (value != null) {
        userModel.value = value;
        firstNameController.value.text = userModel.value.firstName.toString();
        lastNameController.value.text = userModel.value.lastName.toString();
        emailController.value.text = userModel.value.email.toString();
        phoneNumberController.value.text = userModel.value.phoneNumber.toString();
        dateOfBirthController.value.text = userModel.value.dateOfBirth.toString();
        bioController.value.text = userModel.value.bio.toString();
        countryCodeController.value.text = userModel.value.countryCode.toString();
        profileImage.value = userModel.value.profilePic.toString();
        preAddressOfName.value = userModel.value.gender.toString();
      }
    });

    isLoading.value = false;
  }

  saveData() async {
    ShowToastDialog.showLoader("Please wait...");
    if (Constant().hasValidUrl(profileImage.value) == false && profileImage.value.isNotEmpty) {
      profileImage.value = await Constant.uploadUserImageToFireStorage(
        File(profileImage.value),
        "profileImage/${FireStoreUtils.getCurrentUid()}",
        File(profileImage.value).path.split('/').last,
      );
    }

    userModel.value.firstName = firstNameController.value.text;
    userModel.value.lastName = lastNameController.value.text;
    userModel.value.dateOfBirth = dateOfBirthController.value.text;
    userModel.value.bio = bioController.value.text;
    userModel.value.profilePic = profileImage.value;
    userModel.value.gender = preAddressOfName.value;

    await FireStoreUtils.updateUser(userModel.value).then((value) {
      ShowToastDialog.closeLoader();
      Get.back(result: true);
    });
  }

  final ImagePicker _imagePicker = ImagePicker();
  RxString profileImage = "".obs;

  Future pickFile({required ImageSource source}) async {
    try {
      XFile? image = await _imagePicker.pickImage(source: source);
      if (image == null) return;
      Get.back();
      profileImage.value = image.path;
    } on PlatformException catch (e) {
      ShowToastDialog.showToast("${"failed_to_pick".tr} : \n $e");
    }
  }
}
