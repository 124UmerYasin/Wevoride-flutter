import 'dart:convert';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as google_map;
import 'package:wevoride/constant/constant.dart';
import 'package:wevoride/model/booking_model.dart';
import 'package:wevoride/model/map/city_list_model.dart';
import 'package:wevoride/model/map/direction_api_model.dart';
import 'package:wevoride/themes/app_them_data.dart';
import 'package:http/http.dart' as http;

class RouteViewController extends GetxController {
  final RxList<google_map.Polyline> wayPointPolyLines = <google_map.Polyline>[].obs;
  google_map.GoogleMapController? wayPointMapController;

  void setWayMapController(google_map.GoogleMapController controller) {
    wayPointMapController = controller;
  }

  Rx<BookingModel> bookingModel = BookingModel().obs;
  RxList<CityModel> filterSelectedCityList = <CityModel>[].obs;

  RxBool isLoading = true.obs;
  @override
  void onInit() {
    // TODO: implement onInit
    getArgument();
    super.onInit();
  }

  RxList<CityModel> selectedCityList = <CityModel>[].obs;
  RxList<CityModel> allSelectedCityList = <CityModel>[].obs;

  getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      bookingModel.value = argumentData['bookingModel'];
      if (bookingModel.value.stopOver != null) {
        selectedCityList.value = bookingModel.value.stopOver!;
      }
    }
    await wayPointFilter();
  }

  wayPointFilter() async {
    allSelectedCityList.clear();
    wayPointPolyLines.clear();
    final waypointsString = selectedCityList.map((point) => '${point.geometry!.location!.lat},${point.geometry!.location!.lng}').join('|');
    final response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json?origin=${bookingModel.value.pickupLocation!.geometry!.location!.lat},${bookingModel.value.pickupLocation!.geometry!.location!.lng}&destination=${bookingModel.value.dropLocation!.geometry!.location!.lat},${bookingModel.value.dropLocation!.geometry!.location!.lng}&alternatives=true&waypoints=optimize:true|$waypointsString&key=${Constant.mapAPIKey}'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      DirectionAPIModel directionAPIModel = DirectionAPIModel.fromJson(data);

      Routes route = directionAPIModel.routes!.first;

      final overviewPolyline = route.overviewPolyline!.points;
      final polylineCoordinates = Constant.decodePolyline(overviewPolyline!);
      final polyline = google_map.Polyline(
        polylineId: const google_map.PolylineId("0"),
        color: AppThemeData.primary300, // Highlight first route
        points: polylineCoordinates,
        width: 5,
      );

      wayPointPolyLines.add(polyline);
      for (int i = 0; i < selectedCityList.length; i++) {
        filterSelectedCityList.add(selectedCityList[directionAPIModel.routes!.first.waypointOrder![i]]); // 2 replace with waypoint order
      }
    }

    allSelectedCityList.add(bookingModel.value.pickupLocation!);
    allSelectedCityList.addAll(filterSelectedCityList);
    allSelectedCityList.add(bookingModel.value.dropLocation!);
    isLoading.value = false;
  }
}
