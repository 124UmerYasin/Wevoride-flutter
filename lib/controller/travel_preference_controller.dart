import 'package:get/get.dart';
import 'package:wevoride/constant/show_toast_dialog.dart';
import 'package:wevoride/model/user_model.dart';
import 'package:wevoride/utils/fire_store_utils.dart';

class TravelPreferenceController extends GetxController {
  RxString chattiness = "".obs;
  RxString smoking = "".obs;
  RxString music = "".obs;
  RxString pets = "".obs;

  Rx<UserModel> userModel = UserModel().obs;
  RxBool isLoading = true.obs;

  Rx<TravelPreferenceModel> travelPreferenceModel = TravelPreferenceModel().obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getData();
    super.onInit();
  }

  getData() async {
    await FireStoreUtils.getUserProfile(FireStoreUtils.getCurrentUid()).then((value) {
      if (value != null) {
        userModel.value = value;
        if (userModel.value.travelPreference != null) {
          travelPreferenceModel.value = userModel.value.travelPreference!;
          chattiness.value = travelPreferenceModel.value.chattiness.toString();
          smoking.value = travelPreferenceModel.value.smoking.toString();
          music.value = travelPreferenceModel.value.music.toString();
          pets.value = travelPreferenceModel.value.pets.toString();
        }
      }
    });
    isLoading.value = false;
  }

  saveData() async {
    ShowToastDialog.showLoader("Please wait");
    travelPreferenceModel.value.chattiness = chattiness.value;
    travelPreferenceModel.value.smoking = smoking.value;
    travelPreferenceModel.value.music = music.value;
    travelPreferenceModel.value.pets = pets.value;
    userModel.value.travelPreference = travelPreferenceModel.value;
    await FireStoreUtils.updateUser(userModel.value).then((value) {
      ShowToastDialog.closeLoader();
      Get.back(result: true);
    });
  }
}
