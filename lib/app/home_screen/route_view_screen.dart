import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wevoride/constant/constant.dart';
import 'package:wevoride/controller/route_view_controller.dart';
import 'package:wevoride/model/map/city_list_model.dart';
import 'package:wevoride/themes/app_them_data.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as google;
import 'package:wevoride/utils/dark_theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:timelines_plus/timelines_plus.dart';
import 'package:wevoride/widgets/custom_scaffold.dart';

class RouteViewScreen extends StatelessWidget {
  const RouteViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: RouteViewController(),
        builder: (controller) {
          return CustomScaffold(
            appBar: AppBar(
              backgroundColor: themeChange.getThem() ? AppThemeData.grey900 : AppThemeData.grey50,
              centerTitle: false,
              titleSpacing: 0,
              leading: InkWell(
                  onTap: () {
                    Get.back();
                  },
                    child: Icon(
                  Icons.chevron_left_outlined,
                  color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900,
                ),),
              elevation: 0,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(4.0),
                child: Container(
                  color: themeChange.getThem() ? AppThemeData.grey700 : AppThemeData.grey200,
                  height: 4.0,
                ),
              ),
            ),
            body: controller.isLoading.value
                ? Constant.loader()
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Timeline.tileBuilder(
                          shrinkWrap: true,
                          theme: TimelineThemeData(
                            nodePosition: 0,
                            // indicatorPosition: 0,
                          ),
                          builder: TimelineTileBuilder.connected(
                            contentsAlign: ContentsAlign.basic,
                            indicatorBuilder: (context, index) {
                              return Container(
                                width: 8,
                                height: 8,
                                decoration: ShapeDecoration(
                                  color: index == 0
                                      ? AppThemeData.warning100
                                      : controller.allSelectedCityList.length - 1 == index
                                          ? AppThemeData.success100
                                          : AppThemeData.grey100,
                                  shape: const OvalBorder(),
                                  shadows: [
                                    BoxShadow(
                                      color: index == 0
                                          ? AppThemeData.warning300
                                          : controller.allSelectedCityList.length - 1 == index
                                              ? AppThemeData.success400
                                              : AppThemeData.grey300,
                                      blurRadius: 0,
                                      offset: const Offset(0, 0),
                                      spreadRadius: 2,
                                    )
                                  ],
                                ),
                              );
                            },
                            connectorBuilder: (context, index, connectorType) {
                              return const DashedLineConnector(
                                color: AppThemeData.grey300,
                                gap: 2,
                              );
                            },
                            contentsBuilder: (context, index) {
                              CityModel cityModel = controller.allSelectedCityList[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                child: Constant.getCityName(themeChange, cityModel.geometry!.location!,
                                    style: index == 0
                                        ? TextStyle(color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800, fontFamily: AppThemeData.regular, fontSize: 12)
                                        : index == controller.allSelectedCityList.length - 1
                                            ? TextStyle(color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800, fontFamily: AppThemeData.regular, fontSize: 12)
                                            : TextStyle(color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800, fontFamily: AppThemeData.bold, fontSize: 14)),
                              );
                            },
                            itemCount: controller.allSelectedCityList.length,
                          ),
                        ),
                      ),
                      Expanded(
                        child: google.GoogleMap(
                          onMapCreated: controller.setWayMapController,
                          polylines: Set<google.Polyline>.of(controller.wayPointPolyLines),
                          zoomControlsEnabled: true,
                          zoomGesturesEnabled: true,
                          buildingsEnabled: true,
                          initialCameraPosition: google.CameraPosition(
                            target: google.LatLng(
                                controller.bookingModel.value.pickupLocation!.geometry!.location!.lat!, controller.bookingModel.value.pickupLocation!.geometry!.location!.lng!),
                            zoom: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
          );
        });
  }
}
