import 'package:wevoride/model/vehicle_brand_model.dart';
import 'package:wevoride/model/vehicle_model.dart';
import 'package:wevoride/model/vehicle_type_model.dart';

class VehicleInformationModel {
  String? id;
  String? userId;
  String? licensePlatNumber;
  String? vehicleColor;
  String? vehicleRegistrationYear;
  VehicleBrandModel? vehicleBrand;
  VehicleModel? vehicleModel;
  VehicleTypeModel? vehicleType;
  List<dynamic>? vehicleImages;

  VehicleInformationModel({
    this.id,
    this.userId,
    this.licensePlatNumber,
    this.vehicleColor,
    this.vehicleRegistrationYear,
    this.vehicleBrand,
    this.vehicleModel,
    this.vehicleType,
    this.vehicleImages,
  });

  VehicleInformationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    licensePlatNumber = json['licensePlatNumber'];
    vehicleColor = json['vehicleColor'];
    vehicleRegistrationYear = json['vehicleRegistrationYear'];
    vehicleImages = json['vehicleImages'];

    vehicleBrand = json['vehicleBrand'] != null ? VehicleBrandModel.fromJson(json['vehicleBrand']) : null;
    vehicleModel = json['vehicleModel'] != null ? VehicleModel.fromJson(json['vehicleModel']) : null;
    vehicleType = json['vehicleType'] != null ? VehicleTypeModel.fromJson(json['vehicleType']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['licensePlatNumber'] = licensePlatNumber;
    data['vehicleColor'] = vehicleColor;
    data['vehicleRegistrationYear'] = vehicleRegistrationYear;
    data['vehicleImages'] = vehicleImages;
    if (vehicleBrand != null) {
      data['vehicleBrand'] = vehicleBrand!.toJson();
    }
    if (vehicleModel != null) {
      data['vehicleModel'] = vehicleModel!.toJson();
    }
    if (vehicleType != null) {
      data['vehicleType'] = vehicleType!.toJson();
    }
    return data;
  }
}
