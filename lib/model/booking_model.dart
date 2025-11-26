import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wevoride/model/admin_commission.dart';
import 'package:wevoride/model/map/city_list_model.dart';
import 'package:wevoride/model/map/geometry.dart';
import 'package:wevoride/model/stop_over_model.dart';
import 'package:wevoride/model/tax_model.dart';
import 'package:wevoride/model/user_model.dart';
import 'package:wevoride/model/vehicle_information_model.dart';

class BookingModel {
  String? id;
  String? status;
  String? createdBy;
  String? totalSeat;
  String? bookedSeat;
  String? distance;
  String? estimatedTime;
  String? pricePerSeat;
  String? luggageAllowed;
  String? pickUpAddress;
  String? dropAddress;
  CityModel? pickupLocation;
  CityModel? dropLocation;
  List<dynamic>? bookedUserId;
  List<dynamic>? cancelledUserId;
  List<CityModel>? stopOver;
  List<StopOverModel>? stopOverList;
  VehicleInformationModel? vehicleInformation;
  TravelPreferenceModel? travelPreference;
  Timestamp? departureDateTime;
  Timestamp? createdAt;
  bool? womenOnly;
  bool? driverVerify;
  bool? twoPassengerMaxInBack;
  bool? publish;

  BookingModel({
    this.id,
    this.status,
    this.createdBy,
    this.totalSeat,
    this.bookedSeat,
    this.distance,
    this.estimatedTime,
    this.pricePerSeat,
    this.luggageAllowed,
    this.pickUpAddress,
    this.dropAddress,
    this.pickupLocation,
    this.dropLocation,
    this.stopOver,
    this.stopOverList,
    this.vehicleInformation,
    this.departureDateTime,
    this.createdAt,
    this.bookedUserId,
    this.cancelledUserId,
    this.womenOnly,
    this.driverVerify,
    this.twoPassengerMaxInBack,
    this.travelPreference,
    this.publish,
  });

  BookingModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    createdBy = json['createdBy'];
    totalSeat = json['totalSeat'];
    bookedSeat = json['bookedSeat'] ?? "0";
    pricePerSeat = json['pricePerSeat'];
    luggageAllowed = json['luggageAllowed'];
    distance = json['distance'];
    estimatedTime = json['estimatedTime'];
    pickUpAddress = json['pickUpAddress'];
    dropAddress = json['dropAddress'];
    pickupLocation = json['pickupLocation'] != null ? CityModel.fromJson(json['pickupLocation']) : null;
    dropLocation = json['dropLocation'] != null ? CityModel.fromJson(json['dropLocation']) : null;
    vehicleInformation = json['vehicleInformation'] != null ? VehicleInformationModel.fromJson(json['vehicleInformation']) : null;
    if (json['stopOver'] != null) {
      stopOver = <CityModel>[];
      json['stopOver'].forEach((v) {
        stopOver!.add(CityModel.fromJson(v));
      });
    }
    if (json['stopOverList'] != null) {
      stopOverList = <StopOverModel>[];
      json['stopOverList'].forEach((v) {
        stopOverList!.add(StopOverModel.fromJson(v));
      });
    }
    departureDateTime = json['departureDateTime'];
    createdAt = json['createdAt'];
    bookedUserId = json['bookedUserId'] ?? [];
    cancelledUserId = json['cancelledUserId'] ?? [];
    womenOnly = json['womenOnly'];
    driverVerify = json['driverVerify'];
    twoPassengerMaxInBack = json['twoPassengerMaxInBack'];
    publish = json['publish'];
    travelPreference = json['travelPreference'] != null ? TravelPreferenceModel.fromJson(json['travelPreference']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['status'] = status;
    data['createdBy'] = createdBy;
    data['totalSeat'] = totalSeat;
    data['bookedSeat'] = bookedSeat;
    data['pricePerSeat'] = pricePerSeat;
    data['luggageAllowed'] = luggageAllowed;
    data['distance'] = distance;
    data['estimatedTime'] = estimatedTime;
    data['pickUpAddress'] = pickUpAddress;
    data['dropAddress'] = dropAddress;
    data['stopOver'] = stopOver;
    if (stopOver != null) {
      data['stopOver'] = stopOver!.map((v) => v.toJson()).toList();
    }
    if (stopOverList != null) {
      data['stopOverList'] = stopOverList!.map((v) => v.toJson()).toList();
    }
    if (vehicleInformation != null) {
      data['vehicleInformation'] = vehicleInformation!.toJson();
    }
    if (pickupLocation != null) {
      data['pickupLocation'] = pickupLocation!.toJson();
    }
    if (dropLocation != null) {
      data['dropLocation'] = dropLocation!.toJson();
    }
    data['departureDateTime'] = departureDateTime;
    data['createdAt'] = createdAt;
    data['bookedUserId'] = bookedUserId;
    data['cancelledUserId'] = cancelledUserId;
    data['womenOnly'] = womenOnly;
    data['driverVerify'] = driverVerify;
    data['twoPassengerMaxInBack'] = twoPassengerMaxInBack;
    data['publish'] = publish;
    if (travelPreference != null) {
      data['travelPreference'] = travelPreference!.toJson();
    }
    return data;
  }
}

class BookedUserModel {
  Timestamp? createdAt;
  String? id;
  String? bookedSeat;
  String? subTotal;
  bool? paymentStatus;
  String? paymentType;
  StopOverModel? stopOver;
  Location? pickupLocation;
  Location? dropLocation;
  List<TaxModel>? taxList;
  AdminCommission? adminCommission;

  BookedUserModel({
    this.createdAt,
    this.id,
    this.bookedSeat,
    this.paymentStatus,
    this.stopOver,
    this.paymentType,
    this.pickupLocation,
    this.dropLocation,
    this.taxList,
    this.adminCommission,
  });

  BookedUserModel.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'];
    id = json['id'];
    bookedSeat = json['bookedSeat'];
    subTotal = json['subTotal'];
    paymentStatus = json['paymentStatus'];
    paymentType = json['paymentType'];
    stopOver = json['stopOver'] != null ? StopOverModel.fromJson(json['stopOver']) : null;
    pickupLocation = json['pickupLocation'] != null ? Location.fromJson(json['pickupLocation']) : null;
    dropLocation = json['dropLocation'] != null ? Location.fromJson(json['dropLocation']) : null;
    if (json['taxList'] != null) {
      taxList = <TaxModel>[];
      json['taxList'].forEach((v) {
        taxList!.add(TaxModel.fromJson(v));
      });
    }
    adminCommission = json['adminCommission'] != null ? AdminCommission.fromJson(json['adminCommission']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['createdAt'] = createdAt;
    data['id'] = id;
    data['bookedSeat'] = bookedSeat;
    data['subTotal'] = subTotal;
    data['paymentStatus'] = paymentStatus;
    data['paymentType'] = paymentType;
    if (stopOver != null) {
      data['stopOver'] = stopOver!.toJson();
    }
    if (pickupLocation != null) {
      data['pickupLocation'] = pickupLocation!.toJson();
    }
    if (dropLocation != null) {
      data['dropLocation'] = dropLocation!.toJson();
    }
    if (taxList != null) {
      data['taxList'] = taxList!.map((v) => v.toJson()).toList();
    }
    if (adminCommission != null) {
      data['adminCommission'] = adminCommission!.toJson();
    }
    return data;
  }
}
