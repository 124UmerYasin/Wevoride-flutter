import 'package:get/get.dart';
import 'package:wevoride/constant/constant.dart';
import 'package:wevoride/model/language_model.dart';
import 'package:wevoride/utils/fire_store_utils.dart';
import 'package:wevoride/utils/preferences.dart';

class AccessibilityController extends GetxController {
  Rx<LanguageModel> selectedLanguage = LanguageModel().obs;
  RxList<LanguageModel> languageList = <LanguageModel>[].obs;
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getThem();
    getLanguage();

    super.onInit();
  }

  RxString isDarkMode = "Light".obs;
  RxBool isDarkModeSwitch = false.obs;

  getThem() {
    isDarkMode.value = Preferences.getString(Preferences.themKey);
    if (isDarkMode.value == "Dark") {
      isDarkModeSwitch.value = true;
    } else if (isDarkMode.value == "Light") {
      isDarkModeSwitch.value = false;
    } else {
      isDarkModeSwitch.value = false;
    }
    selectedLanguage.value = Constant.getLanguage();
  }

  getLanguage() async {
    await FireStoreUtils.getLanguage().then((value) {
      if (value != null) {
        languageList.value = value;
        if (Preferences.getString(Preferences.languageCodeKey).toString().isNotEmpty) {
          LanguageModel pref = Constant.getLanguage();

          for (var element in languageList) {
            if (element.id == pref.id) {
              selectedLanguage.value = element;
            }
          }
        }
      }
    });
    isLoading.value = false;
  }
}
