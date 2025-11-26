import 'package:get/get.dart';
import 'package:wevoride/model/recent_search_model.dart';
import 'package:wevoride/utils/fire_store_utils.dart';

class ViewAllSearchController extends GetxController {
  RxBool isLoading = true.obs;
  RxList<RecentSearchModel> recentSearch = <RecentSearchModel>[].obs;

  @override
  void onInit() {
    getSearchHistory();
    super.onInit();
  }

  getSearchHistory() async {
    await FireStoreUtils.getSearchHistory().then((value) {
      if (value != null) {
        recentSearch.value = value;
      }
    });
    isLoading.value = false;
  }
}
