import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wevoride/constant/constant.dart';
import 'package:wevoride/constant/show_toast_dialog.dart';
import 'package:wevoride/model/vehicle_brand_model.dart';
import 'package:wevoride/model/vehicle_information_model.dart';
import 'package:wevoride/model/vehicle_model.dart';
import 'package:wevoride/model/vehicle_type_model.dart';
import 'package:wevoride/utils/fire_store_utils.dart';

class AddVehicleController extends GetxController {
  Rx<TextEditingController> licensePlatNumberController = TextEditingController().obs;
  Rx<TextEditingController> vehicleRegisterYearController = TextEditingController().obs;

  RxBool isLoading = true.obs;

  @override
  void onInit() {
    log("CLICK::33");
    // TODO: implement onInit
    getVehicleData();
    getArgument();
    super.onInit();
  }

  Rx<VehicleInformationModel> vehicleInformationModel = VehicleInformationModel().obs;

  RxList images = <dynamic>[].obs;

  getArgument() {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      vehicleInformationModel.value = argumentData['vehicleInformationModel'];

      licensePlatNumberController.value.text = vehicleInformationModel.value.licensePlatNumber.toString();
      vehicleRegisterYearController.value.text = vehicleInformationModel.value.vehicleRegistrationYear.toString();
      selectedColor.value = vehicleInformationModel.value.vehicleColor.toString();
      if (vehicleInformationModel.value.vehicleImages != null && vehicleInformationModel.value.vehicleImages!.isNotEmpty) {
        images.value = vehicleInformationModel.value.vehicleImages!;
      }
    }
  }

  getVehicleData() async {
    await FireStoreUtils.getVehicleBrand().then((value) {
      if (value != null) {
        vehicleBrandModelList.value = value;
      }
    });

    await FireStoreUtils.getVehicleType().then((value) {
      if (value != null) {
        vehicleTypeModelList.value = value;
      }
    });

    if (Get.arguments != null) {
      for (var element in vehicleBrandModelList) {
        if (element.id == vehicleInformationModel.value.vehicleBrand!.id.toString()) {
          selectedVehicleBrand.value = element;
        }
      }

      for (var element in vehicleTypeModelList) {
        if (element.id == vehicleInformationModel.value.vehicleType!.id.toString()) {
          selectedVehicleType.value = element;
        }
      }

      await FireStoreUtils.getVehicleModel(selectedVehicleBrand.value.id.toString()).then((value) {
        if (value != null) {
          vehicleModelList.value = value;
          for (var element in vehicleModelList) {
            if (element.id == vehicleInformationModel.value.vehicleModel!.id.toString()) {
              selectedVehicleModel.value = element;
            }
          }
        }
      });
    }
    isLoading.value = false;
  }

  RxList<VehicleBrandModel> vehicleBrandModelList = <VehicleBrandModel>[].obs;
  Rx<VehicleBrandModel> selectedVehicleBrand = VehicleBrandModel().obs;

  RxList<VehicleModel> vehicleModelList = <VehicleModel>[].obs;
  Rx<VehicleModel> selectedVehicleModel = VehicleModel().obs;

  RxList<VehicleTypeModel> vehicleTypeModelList = <VehicleTypeModel>[].obs;
  Rx<VehicleTypeModel> selectedVehicleType = VehicleTypeModel().obs;

  RxList<String> colourList = <String>["Black", "White", "Dark grey", "Grey", "Red", "Dark blue", "Blue", "Dark green", "Green", "Brown", "Beige", "Orange", "Yellow", "Purple", "Pink"].obs;
  RxString selectedColor = "".obs;

  getVehicleModel(String brandId) async {
    selectedVehicleModel.value = VehicleModel();
    await FireStoreUtils.getVehicleModel(brandId).then((value) {
      if (value != null) {
        vehicleModelList.value = value;
      }
    });
  }

  setVehicleInformationData() async {
    ShowToastDialog.showLoader("Please wait..");
    vehicleInformationModel.value.id ??= Constant.getUuid();
    vehicleInformationModel.value.licensePlatNumber = licensePlatNumberController.value.text;
    vehicleInformationModel.value.vehicleRegistrationYear = vehicleRegisterYearController.value.text;
    vehicleInformationModel.value.vehicleBrand = selectedVehicleBrand.value;
    vehicleInformationModel.value.vehicleModel = selectedVehicleModel.value;
    vehicleInformationModel.value.vehicleType = selectedVehicleType.value;
    vehicleInformationModel.value.vehicleColor = selectedColor.value;
    vehicleInformationModel.value.userId = FireStoreUtils.getCurrentUid();
    for (int i = 0; i < images.length; i++) {
      if (images[i].runtimeType == XFile) {
        String url = await Constant.uploadUserImageToFireStorage(
          File(images[i].path),
          "profileImage/${FireStoreUtils.getCurrentUid()}",
          File(images[i].path).path.split('/').last,
        );
        images.removeAt(i);
        images.insert(i, url);
      }
    }
    vehicleInformationModel.value.vehicleImages = images;
    await FireStoreUtils.setUserVehicleInformation(vehicleInformationModel.value);
    ShowToastDialog.closeLoader();
    Get.back(result: vehicleInformationModel.value.id);
  }

  deleteVehicle() async {
    ShowToastDialog.showLoader("Please wait..");
    await FireStoreUtils.deleteVehicleInformation(vehicleInformationModel.value).then(
      (value) {
        ShowToastDialog.showToast("Vehicle delete successfully");
        ShowToastDialog.closeLoader();
        Get.back(result: true);
      },
    );
  }

  final ImagePicker _imagePicker = ImagePicker();

  Future pickFile({required ImageSource source}) async {
    try {
      XFile? image = await _imagePicker.pickImage(source: source);
      if (image == null) return;
      images.add(image);
      Get.back();
    } on PlatformException catch (e) {
      ShowToastDialog.showToast("${"failed_to_pick".tr} : \n $e");
    }
  }
}
