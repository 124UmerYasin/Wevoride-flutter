import 'package:get/get.dart';
import 'package:wevoride/model/user_model.dart';
import 'package:wevoride/utils/fire_store_utils.dart';

class ProfileController extends GetxController {
  RxBool isLoading = true.obs;
  Rx<UserModel> userModel = UserModel().obs;

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  getData() async {
    await FireStoreUtils.getUserProfile(FireStoreUtils.getCurrentUid()).then((value) {
      if (value != null) {
        userModel.value = value;
      }
    });

    print(userModel.value.toJson());
    isLoading.value = false;
  }
}
