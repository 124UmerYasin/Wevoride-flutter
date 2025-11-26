import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:wevoride/app/add_your_ride/step_three_stop_over_details_screen.dart';
import 'package:wevoride/constant/constant.dart';
import 'package:wevoride/controller/add_your_ride_controller.dart';
import 'package:wevoride/model/map/city_list_model.dart';
import 'package:wevoride/model/map/geometry.dart';
import 'package:wevoride/model/map/place_picker_model.dart';
import 'package:wevoride/themes/app_them_data.dart';
import 'package:wevoride/themes/round_button_fill.dart';
import 'package:wevoride/utils/dark_theme_provider.dart';
import 'package:wevoride/widgets/custom_scaffold.dart';
import 'package:wevoride/widgets/google_map_search_place.dart';
import 'package:wevoride/widgets/safe_bottom_widget.dart';
import 'package:provider/provider.dart';

class StepTwoStopOverScreen extends StatelessWidget {
  const StepTwoStopOverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
      init: AddYourRideController(),
      builder: (controller) {
        return CustomScaffold(
            backgroundColor: themeChange.getThem() ? AppThemeData.grey800 : AppThemeData.grey50,
            appBar: AppBar(
              backgroundColor: themeChange.getThem() ? AppThemeData.grey900 : AppThemeData.grey100,
              centerTitle: false,
              titleSpacing: 0,
              leading: InkWell(
                onTap: () {
                  Get.back();
                },
                child: Icon(
                  Icons.chevron_left_outlined,
                  color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900,
                ),
              ),
              elevation: 0,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(4.0),
                child: Container(
                  color: themeChange.getThem() ? AppThemeData.grey700 : AppThemeData.grey200,
                  height: 4.0,
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "Add a stopover and find extra passengers on the way",
                      style: TextStyle(color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900, fontFamily: AppThemeData.bold, fontSize: 20),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: controller.cityList.length,
                            itemBuilder: (context, index) {
                              CityModel cityModel = controller.cityList[index];
                              return Obx(
                                () => GestureDetector(
                                  onTap: () {
                                    if (controller.selectedCityList.where((p0) => p0.name == cityModel.name).isNotEmpty) {
                                      controller.selectedCityList.remove(cityModel);
                                    } else {
                                      controller.selectedCityList.add(cityModel);
                                    }
                                  },
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              cityModel.name.toString(),
                                              style: TextStyle(color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800, fontFamily: AppThemeData.bold, fontSize: 14),
                                            ),
                                          ),
                                          Checkbox(
                                            activeColor: AppThemeData.primary300,
                                            value: controller.selectedCityList.where((p0) => p0.name == cityModel.name).isNotEmpty,
                                            onChanged: (val) {
                                              if (controller.selectedCityList.where((p0) => p0.name == cityModel.name).isNotEmpty) {
                                                controller.selectedCityList.remove(cityModel);
                                              } else {
                                                controller.selectedCityList.add(cityModel);
                                              }
                                            },
                                          )
                                        ],
                                      ),
                                      const Divider(),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          InkWell(
                            onTap: () {
                              Get.to(const GoogleMapSearchPlacesApi())!.then((value) async {
                                if (value != null) {
                                  PlaceDetailsModel placeDetailsModel = value;
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Theme(
                                        data: Theme.of(context).brightness == Brightness.dark
                                            ? ThemeData.dark().copyWith(
                                                primaryColor: AppThemeData.primary300,
                                                scaffoldBackgroundColor: AppThemeData.grey900,
                                              )
                                            : ThemeData.light().copyWith(
                                                primaryColor: AppThemeData.primary300,
                                                scaffoldBackgroundColor: AppThemeData.grey50,
                                              ),
                                        child: PlacePicker(
                                          apiKey: Constant.mapAPIKey,
                                          onPlacePicked: (result) {
                                            Get.back();
                                            CityModel cityModel = CityModel();
                                            cityModel.name = placeDetailsModel.result!.formattedAddress;
                                            cityModel.geometry = Geometry(location: Location.fromJson(result.geometry!.location.toJson()));
                                            cityModel.placeId = result.placeId;
                                            controller.cityList.add(cityModel);
                                          },
                                          initialPosition: LatLng(placeDetailsModel.result!.geometry!.location!.lat!, placeDetailsModel.result!.geometry!.location!.lng!),
                                          useCurrentLocation: false,
                                          selectInitialPosition: true,
                                          usePinPointingSearch: true,
                                          usePlaceDetailSearch: true,
                                          zoomGesturesEnabled: true,
                                          zoomControlsEnabled: true,
                                          resizeToAvoidBottomInset: false, // only works in page mode, less flickery, remove if wrong offsets
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                "Add City".tr,
                                textAlign: TextAlign.start,
                                style: TextStyle(color: themeChange.getThem() ? AppThemeData.primary300 : AppThemeData.primary300, fontFamily: AppThemeData.bold, fontSize: 14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: SafeBottomWidget(
              child: RoundedButtonFill(
                title: "Next".tr,
                color: AppThemeData.primary300,
                textColor: AppThemeData.grey50,
                onPress: () {
                  controller.wayPointFilter();
                  Get.to(const StepThreeStopOverDetailsScreen());
                },
              ),
            ));
      },
    );
  }
}
