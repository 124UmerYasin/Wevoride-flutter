import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wevoride/app/home_screen/search_screen.dart';
import 'package:wevoride/constant/collection_name.dart';
import 'package:wevoride/constant/constant.dart';
import 'package:wevoride/constant/show_toast_dialog.dart';
import 'package:wevoride/model/booking_model.dart';
import 'package:wevoride/model/map/direction_api_model.dart';
import 'package:wevoride/model/map/geometry.dart';
import 'package:wevoride/model/recent_search_model.dart';
import 'package:wevoride/model/stop_over_model.dart';
import 'package:wevoride/model/user_model.dart';
import 'package:wevoride/utils/fire_store_utils.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  Rx<TextEditingController> pickUpLocationController =
      TextEditingController().obs;
  Rx<TextEditingController> dropLocationController =
      TextEditingController().obs;
  Rx<TextEditingController> personController =
      TextEditingController(text: "1").obs;
  Rx<TextEditingController> dateController = TextEditingController().obs;

  RxInt numberOfSheet = 1.obs;

  Rx<DateTime> selectedDate = DateTime.now().obs;

  Rx<Location> pickUpLocation = Location().obs;
  Rx<Location> dropLocation = Location().obs;

  RxList<RecentSearchModel> recentSearch = <RecentSearchModel>[].obs;

  RxBool isLoading = true.obs;
  Rx<UserModel> userModel = UserModel().obs;

  RxBool sourceMatched = false.obs;
  RxBool completed = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    dateController.value.text =
        Constant.dateCustomizationShow(selectedDate.value).toString();
    getAdvertisement();
    getSearchHistory();
    addDepartureTime();
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

  RxList<BookingModel> searchedBookingList = <BookingModel>[].obs;

  searchRide() async {
    ShowToastDialog.showLoader("Please wait");
    searchedBookingList.clear();

    if (pickUpLocation.value.lat != null) {
      List<geocoding.Placemark> placeMarks =
          await geocoding.placemarkFromCoordinates(
              pickUpLocation.value.lat!, pickUpLocation.value.lng!);
      Constant.country = placeMarks.first.country;
    }

    await FireStoreUtils().getTaxList().then((value) {
      if (value != null) {
        Constant.taxList = value;
      }
    });
    Timestamp startTime;
    if (Constant.dateCustomizationShow(selectedDate.value) == "Today") {
      startTime = Timestamp.fromDate(DateTime.now());
    } else {
      startTime = Timestamp.fromDate(DateTime(selectedDate.value.year,
          selectedDate.value.month, selectedDate.value.day, 0, 0, 0));
    }
    Timestamp endTime = Timestamp.fromDate(DateTime(selectedDate.value.year,
        selectedDate.value.month, selectedDate.value.day, 23, 59, 0));
    await FireStoreUtils.fireStore
        .collection(CollectionName.booking)
        .where('departureDateTime', isGreaterThanOrEqualTo: startTime)
        .where('departureDateTime', isLessThanOrEqualTo: endTime)
        .where('status', isEqualTo: Constant.placed)
        .where('publish', isEqualTo: true)
        .where('createdBy', isNotEqualTo: FireStoreUtils.getCurrentUid())
        .get()
        .then((value) {
      for (var element in value.docs) {
        BookingModel bookingModel = BookingModel.fromJson(element.data());
        bool isPickupSame = pickupIsSame(bookingModel);

        if (isPickupSame) {
          int bookedSeat =
              (bookingModel.bookedSeat == '' || bookingModel.bookedSeat == null)
                  ? 0
                  : int.parse(bookingModel.bookedSeat!);
          int totalSeat =
              (bookingModel.totalSeat == '' || bookingModel.totalSeat == null)
                  ? 0
                  : int.parse(bookingModel.totalSeat!);
          if (bookedSeat < totalSeat) {
            searchedBookingList.add(bookingModel);
          }
        }
      }
    });

    ShowToastDialog.closeLoader();
    completed.value = false;
    sourceMatched.value = false;
    Get.to(const SearchScreen())?.then((v) async {
      await getSearchHistory();
    });
  }

  bool pickupIsSame(BookingModel bookingModel) {
    bool isPickUp = false;
    bool isDropOff = false;

    for (var element in bookingModel.stopOverList!) {
      double distanceBothLocation =
          Constant.calculateDistance(pickUpLocation.value, dropLocation.value);
      double distancePickup = Constant.calculateDistance(
          Location(
              lat: element.startLocation!.lat, lng: element.startLocation!.lng),
          pickUpLocation.value);
      double distanceDrop = Constant.calculateDistance(
          Location(
              lat: element.endLocation!.lat, lng: element.endLocation!.lng),
          dropLocation.value);

      if (distanceBothLocation <= int.parse(Constant.radius)) {
        return false;
      }

      if (distancePickup <= int.parse(Constant.radius)) {
        isPickUp = true;
      }
      if (distanceDrop <= int.parse(Constant.radius)) {
        isDropOff = true;
      }

      if (isPickUp) {
        if (isDropOff) {
          return true;
        }
      }

      if (isDropOff) {
        if (!isPickUp) {
          return false;
        }
      }
    }

    return false;
  }

  Future<StopOverModel?> getPrice(BookingModel bookingModel) async {
    StopOverModel stopOverModel = StopOverModel();
    List<LocationDistance> pickUpDistanceData = [];
    List<LocationDistance> dropUpDistanceData = [];
    for (var element in bookingModel.stopOverList!) {
      double distancePickup = Constant.calculateDistance(
          Location(
              lat: element.startLocation!.lat, lng: element.startLocation!.lng),
          pickUpLocation.value);
      double distanceDrop = Constant.calculateDistance(
          Location(
              lat: element.endLocation!.lat, lng: element.endLocation!.lng),
          dropLocation.value);
      log("DistanceData :: pickUp :: ${element.startAddress} :: $distancePickup");
      log("DistanceData :: droff ::${element.endAddress} :: $distanceDrop");
      pickUpDistanceData.add(LocationDistance(
          radius: distancePickup,
          location: LatLng(element.startLocation?.lat ?? 0.0,
              element.startLocation?.lng ?? 0.0)));
      dropUpDistanceData.add(LocationDistance(
          radius: distanceDrop,
          location: LatLng(element.endLocation?.lat ?? 0.0,
              element.endLocation?.lng ?? 0.0)));
      if (!completed.value) {
        if (bookingModel.stopOverList?.length == 1) {
          isSameCity(element.startLocation!.lat!, element.startLocation!.lng!,
                  pickUpLocation.value.lat!, pickUpLocation.value.lng!)
              .then(
            (value) {
              if (value) {
                isSameCity(element.endLocation!.lat!, element.endLocation!.lng!,
                        dropLocation.value.lat!, dropLocation.value.lng!)
                    .then(
                  (value) {
                    print("print===>Lenght1");
                    completed.value = true;
                    print("Print===>3");
                    stopOverModel.price = element.price;
                    stopOverModel.recommendedPrice = element.recommendedPrice;
                  },
                );
              }
            },
          );
        } else if (await isSameCity(
                bookingModel.pickupLocation!.geometry!.location!.lat!,
                bookingModel.pickupLocation!.geometry!.location!.lng!,
                pickUpLocation.value.lat!,
                pickUpLocation.value.lng!) &&
            await isSameCity(
                bookingModel.dropLocation!.geometry!.location!.lat!,
                bookingModel.dropLocation!.geometry!.location!.lng!,
                dropLocation.value.lat!,
                dropLocation.value.lng!)) {
          print("print===>SamePick_Drip");
          completed.value = true;
          stopOverModel.price = bookingModel.pricePerSeat;
        } else {
          if (sourceMatched.value) {
            print(
                "print===>sourceMatch==>start==${sourceMatched.value}==${completed.value}");
            isSameCity(element.endLocation!.lat!, element.endLocation!.lng!,
                    dropLocation.value.lat!, dropLocation.value.lng!)
                .then(
              (end) {
                if (end) {
                  completed.value = true;
                  int decimals = (Constant.currencyModel?.decimalDigits ?? 2);
                  if (decimals < 2) decimals = 2;
                  double totalPrice =
                      double.parse(stopOverModel.price.toString()) +
                          double.parse(element.price.toString());
                  stopOverModel.price =
                      totalPrice.toStringAsFixed(decimals).toString();
                  print("print===>price3==${stopOverModel.price}");
                  print("print===>sourceMatch==>end1==${completed.value}");
                } else {
                  print("print===>sourceMatch==>end2==${completed.value}");
                  print(
                      "print===>sourceMatch==>${stopOverModel.price.toString()}");
                  if (!completed.value) {
                    int decimals = (Constant.currencyModel?.decimalDigits ?? 2);
                    if (decimals < 2) decimals = 2;
                    double totalPrice =
                        double.parse(stopOverModel.price.toString()) +
                            double.parse(element.price.toString());
                    stopOverModel.price =
                        totalPrice.toStringAsFixed(decimals).toString();
                    print("print===>price4==${stopOverModel.price}");
                  }
                }
              },
            );
          } else {
            print("print===>sourceMatch==>false==${completed.value}");
            isSameCity(element.startLocation!.lat!, element.startLocation!.lng!,
                    pickUpLocation.value.lat!, pickUpLocation.value.lng!)
                .then(
              (start) {
                if (start) {
                  sourceMatched.value = true;
                  isSameCity(
                          element.endLocation!.lat!,
                          element.endLocation!.lng!,
                          dropLocation.value.lat!,
                          dropLocation.value.lng!)
                      .then(
                    (end) {
                      if (end) {
                        completed.value = true;
                        stopOverModel.price = element.price;
                        stopOverModel.recommendedPrice =
                            element.recommendedPrice;
                        print(
                            "print===>sourceMatch==>false1==${completed.value}");
                      } else {
                        print(
                            "print===>sourceMatch==>false2==${completed.value}");
                        print(
                            "print===>sourceMatch==>${stopOverModel.price.toString()}");
                        if (stopOverModel.price.toString() != null ||
                            stopOverModel.price?.isEmpty == true) {
                          int decimals =
                              (Constant.currencyModel?.decimalDigits ?? 2);
                          if (decimals < 2) decimals = 2;
                          double totalPrice = double.parse("0.0") +
                              double.parse(element.price.toString());
                          stopOverModel.price =
                              totalPrice.toStringAsFixed(decimals).toString();
                          print("print===>price1==${stopOverModel.price}");
                        } else {
                          int decimals =
                              (Constant.currencyModel?.decimalDigits ?? 2);
                          if (decimals < 2) decimals = 2;
                          double totalPrice =
                              double.parse(stopOverModel.price.toString()) +
                                  double.parse(element.price.toString());
                          stopOverModel.price =
                              totalPrice.toStringAsFixed(decimals).toString();
                          print("print===>price2==${stopOverModel.price}");
                        }
                      }
                    },
                  );
                }
              },
            );
          }
        }
      }

      /*isSameCity(element.startLocation!.lat!, element.startLocation!.lng!,
          pickUpLocation.value.lat!, pickUpLocation.value.lng!).then((value) {
            if(value){
              isSameCity(element.endLocation!.lat!, element.endLocation!.lng!,
                  dropLocation.value.lat!, dropLocation.value.lng!).then((value) {

              },);
            }
          },);*/
    }

    pickUpDistanceData.sort((pickUpDistanceItem1, pickUpDistanceItem2) =>
        pickUpDistanceItem1.radius.compareTo(pickUpDistanceItem2.radius));
    dropUpDistanceData.sort((dropUpDistanceData1, dropUpDistanceData2) =>
        dropUpDistanceData1.radius.compareTo(dropUpDistanceData2.radius));

    stopOverModel.startLocation = (Northeast(
        lat: pickUpDistanceData.first.location.latitude,
        lng: pickUpDistanceData.first.location.longitude));
    stopOverModel.endLocation = (Northeast(
        lat: dropUpDistanceData.first.location.latitude,
        lng: dropUpDistanceData.first.location.longitude));
    stopOverModel.startAddress = pickUpLocationController.value.text;
    stopOverModel.endAddress = dropLocationController.value.text;

    return await getStopOverData(
        bookingModel: bookingModel, stopOverModel: stopOverModel);
  }

  Future<bool> isSameCity(
      double lat1, double lon1, double lat2, double lon2) async {
    final placemarks1 = await geocoding.placemarkFromCoordinates(lat1, lon1);
    final placemarks2 = await geocoding.placemarkFromCoordinates(lat2, lon2);

    final city1 = placemarks1.length > 1
        ? placemarks1[1].locality
        : placemarks1.first.locality;
    final city2 = placemarks2.length > 1
        ? placemarks2[1].locality
        : placemarks2.first.locality;

    return city1 != null &&
        city2 != null &&
        city1.toLowerCase() == city2.toLowerCase();
  }

  setSearchHistory({String? serachHistoryId}) async {
    RecentSearchModel recentSearchModel = RecentSearchModel();
    recentSearchModel.pickUpAddress = pickUpLocationController.value.text;
    recentSearchModel.dropAddress = dropLocationController.value.text;
    recentSearchModel.pickUpLocation = pickUpLocation.value;
    recentSearchModel.dropLocation = dropLocation.value;
    recentSearchModel.person = personController.value.text;
    recentSearchModel.bookedDate = Timestamp.fromDate(selectedDate.value);
    recentSearchModel.userId = FireStoreUtils.getCurrentUid();
    recentSearchModel.createdAt = Timestamp.now();
    if (serachHistoryId != null) {
      recentSearchModel.id = serachHistoryId;
    } else {
      recentSearchModel.id = Constant.getUuid();
    }
    await FireStoreUtils.setSearchHistory(recentSearchModel);
  }

  setSearchDatatoFields(
      {required RecentSearchModel recentSearchModel,
      required DateTime? date}) async {
    pickUpLocationController.value.text = recentSearchModel.pickUpAddress ?? '';
    dropLocationController.value.text = recentSearchModel.dropAddress ?? '';
    pickUpLocation.value =
        recentSearchModel.pickUpLocation ?? Location(lat: 0.0, lng: 0.0);
    dropLocation.value =
        recentSearchModel.dropLocation ?? Location(lat: 0.0, lng: 0.0);
    personController.value.text = recentSearchModel.person ?? '0';
    if (date != null) {
      selectedDate.value = date;
      dateController.value.text = Constant.dateCustomizationShow(date);
    } else {
      dateController.value.text = recentSearchModel.bookedDate != null
          ? Constant.dateCustomizationShow(
              recentSearchModel.bookedDate!.toDate())
          : Constant.dateCustomizationShow(DateTime.now());
    }
    setSearchHistory(serachHistoryId: recentSearchModel.id);
    await searchRide();
  }

  RxList<TimeSlot> departureTime = <TimeSlot>[].obs;
  RxList<TimeSlot> selectedDepartureTime = <TimeSlot>[].obs;
  RxBool verifyDriver = false.obs;
  RxBool isWoman = false.obs;

  Rx<RangeValues> currentRangeValues = const RangeValues(1, 10000).obs;
  Rx<TextEditingController> minPriceController =
      TextEditingController(text: "1").obs;
  Rx<TextEditingController> maxPriceController =
      TextEditingController(text: "10000").obs;

  addDepartureTime() {
    departureTime.add(TimeSlot(
        title: "Select All",
        start: DateTime(selectedDate.value.year, selectedDate.value.month,
            selectedDate.value.day, 0, 0, 0),
        end: DateTime(selectedDate.value.year, selectedDate.value.month,
            selectedDate.value.day, 23, 59, 0)));
    departureTime.add(TimeSlot(
        title: "Before 6:00 AM",
        start: DateTime(selectedDate.value.year, selectedDate.value.month,
            selectedDate.value.day, 0, 0, 0),
        end: DateTime(selectedDate.value.year, selectedDate.value.month,
            selectedDate.value.day, 06, 00, 0)));
    departureTime.add(TimeSlot(
        title: "06:00 AM - 12:00 noon",
        start: DateTime(selectedDate.value.year, selectedDate.value.month,
            selectedDate.value.day, 06, 00, 00),
        end: DateTime(selectedDate.value.year, selectedDate.value.month,
            selectedDate.value.day, 11, 59, 00)));
    departureTime.add(TimeSlot(
        title: "12:00 noon - 06:00 PM",
        start: DateTime(selectedDate.value.year, selectedDate.value.month,
            selectedDate.value.day, 12, 01, 00),
        end: DateTime(selectedDate.value.year, selectedDate.value.month,
            selectedDate.value.day, 18, 00, 00)));
    departureTime.add(TimeSlot(
        title: "after 06:00 PM",
        start: DateTime(selectedDate.value.year, selectedDate.value.month,
            selectedDate.value.day, 18, 00, 00),
        end: DateTime(selectedDate.value.year, selectedDate.value.month,
            selectedDate.value.day, 23, 59, 00)));
  }

  filterBookings({
    List<TimeSlot>? timeSlots,
    bool? verifyDrivers,
    bool? womenOnly,
    double? minPrice,
    double? maxPrice,
  }) async {
    print("===> ${searchedBookingList.length}");
    await searchRide();
    List<BookingModel> filterList = searchedBookingList.where((booking) {
      bool matches = true;

      // Filter by multiple time slots
      if (timeSlots != null && timeSlots.isNotEmpty) {
        bool withinTimeSlot = false;
        for (var slot in timeSlots) {
          if (booking.departureDateTime != null &&
              booking.departureDateTime!.toDate().isAfter(slot.start) &&
              booking.departureDateTime!.toDate().isBefore(slot.end)) {
            withinTimeSlot = true;
            break;
          }
        }
        if (!withinTimeSlot) {
          matches = false;
        }
      }

      // Verify drivers (assuming createdBy is not null or meets some criteria)
      if (verifyDrivers != null && verifyDrivers) {
        if (booking.driverVerify != true) {
          matches = false;
        }
      }

      // Filter by women only
      if (womenOnly != null && womenOnly) {
        if (booking.womenOnly != true) {
          matches = false;
        }
      }

      // Filter by price range
      if (minPrice != null || maxPrice != null) {
        double price = double.tryParse(booking.pricePerSeat ?? '0') ?? 0;
        if ((minPrice != null && price < minPrice) ||
            (maxPrice != null && price > maxPrice)) {
          matches = false;
        }
      }
      return matches;
    }).toList();
    searchedBookingList.value = filterList;
    Get.back();
  }

  RxList<String> bannerList = <String>[].obs;

  getAdvertisement() async {
    await FireStoreUtils.getUserProfile(FireStoreUtils.getCurrentUid())
        .then((value) {
      userModel.value = value!;
    });

    await FireStoreUtils.getAdvertiseBannersData().then((modelList) {
      bannerList.value = modelList;
    });
  }

  getUserProfile() async {
    ShowToastDialog.showLoader("Please wait.".tr);
    await FireStoreUtils.getUserProfile(FireStoreUtils.getCurrentUid())
        .then((value) {
      userModel.value = value!;
    });
  }

  Future<StopOverModel?> getStopOverData(
      {required BookingModel bookingModel,
      required StopOverModel stopOverModel}) async {
    final response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json?origin=${stopOverModel.startLocation?.lat},${stopOverModel.startLocation?.lng}&destination=${stopOverModel.endLocation?.lat},${stopOverModel.endLocation?.lng}&alternatives=true&key=${Constant.mapAPIKey}'));
    print("===>${response.request}");
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      DirectionAPIModel directionAPIModel = DirectionAPIModel.fromJson(data);
      Routes route = directionAPIModel.routes!.first;
      String price = (double.parse(Constant.distanceCalculate(
                  route.legs![0].distance!.value.toString())) *
              double.parse(
                  bookingModel.vehicleInformation?.vehicleType?.perKmCharges ??
                      '0'))
          .toString();
      String recommendedPrice = (double.parse(Constant.distanceCalculate(
                  route.legs![0].distance!.value.toString())) *
              double.parse(
                  bookingModel.vehicleInformation?.vehicleType?.perKmCharges ??
                      '0'))
          .toString();
      stopOverModel.distance = route.legs!.first.distance;
      stopOverModel.duration = route.legs!.first.duration;
      if (stopOverModel.recommendedPrice?.isEmpty == true ||
          stopOverModel.recommendedPrice == null) {
        stopOverModel.recommendedPrice = recommendedPrice;
      }
      /*if(bookingModel.stopOverList!.length <= 1){
        stopOverModel.price = bookingModel.pricePerSeat;
        stopOverModel.recommendedPrice = recommendedPrice;
      }*/
      return stopOverModel;
    } else {
      return null;
    }
  }

  Future<StopOverModel?> getPriceFromDB(
    BookingModel bookingModel,
  ) async {
    StopOverModel stopOverModel = StopOverModel();
    List<StopOverModel> stops = bookingModel.stopOverList ?? [];

    // Find nearest start/end stops
    int startIndex = findClosestStopIndex(stops, pickUpLocation.value);
    int endIndex = findClosestStopIndex(stops, dropLocation.value);

    if (startIndex == -1 || endIndex == -1 || startIndex >= endIndex) {
      print("Invalid or unmatched route");
      return null;
    }

    // ✅ Only take stops strictly between start & end
    List<StopOverModel> selectedStops =
        stops.sublist(startIndex + 1, endIndex + 1);

    double totalPrice = 0;
    double totalRecommended = 0;

    for (var s in selectedStops) {
      totalPrice += double.tryParse(s.price ?? "0") ?? 0;
      totalRecommended += double.tryParse(s.recommendedPrice ?? "0") ?? 0;
    }

    stopOverModel.startLocation = stops[startIndex].startLocation;
    stopOverModel.endLocation = stops[endIndex].endLocation;
    stopOverModel.startAddress = stops[startIndex].startAddress;
    stopOverModel.endAddress = stops[endIndex].endAddress;
    stopOverModel.price = totalPrice.toString();
    stopOverModel.recommendedPrice = totalRecommended.toString();

    return stopOverModel;
  }

  int findClosestStopIndex(List<StopOverModel> stops, Location target,
      {double toleranceKm = 0.5}) {
    for (int i = 0; i < stops.length; i++) {
      double startDist = Constant.calculateDistance(
        Location(
            lat: stops[i].startLocation!.lat, lng: stops[i].startLocation!.lng),
        target,
      );

      if (startDist <= toleranceKm) return i;

      double endDist = Constant.calculateDistance(
        Location(
            lat: stops[i].endLocation!.lat, lng: stops[i].endLocation!.lng),
        target,
      );

      if (endDist <= toleranceKm) return i;
    }
    return -1;
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class TimeSlot {
  String title;
  DateTime start;
  DateTime end;

  TimeSlot({required this.title, required this.start, required this.end});
}

class LocationDistance {
  double radius;
  LatLng location;

  LocationDistance({required this.radius, required this.location});
}
