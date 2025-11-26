import 'package:wevoride/model/map/direction_api_model.dart';

class StopOverModel {
  Distance? distance;
  Distance? duration;
  String? endAddress;
  Northeast? endLocation;
  String? startAddress;
  Northeast? startLocation;
  String? price;
  String? recommendedPrice;

  StopOverModel(
      {this.distance,
        this.duration,
        this.endAddress,
        this.endLocation,
        this.startAddress,
        this.startLocation,
        this.price,
        this.recommendedPrice,
      });

  StopOverModel.fromJson(Map<String, dynamic> json) {
    distance = json['distance'] != null
        ? Distance.fromJson(json['distance'])
        : null;
    duration = json['duration'] != null
        ? Distance.fromJson(json['duration'])
        : null;
    endAddress = json['end_address'];
    endLocation = json['end_location'] != null
        ? Northeast.fromJson(json['end_location'])
        : null;
    startAddress = json['start_address'];
    price = json['price'];
    recommendedPrice = json['recommendedPrice'];
    startLocation = json['start_location'] != null
        ? Northeast.fromJson(json['start_location'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (distance != null) {
      data['distance'] = distance!.toJson();
    }
    if (duration != null) {
      data['duration'] = duration!.toJson();
    }
    data['end_address'] = endAddress;
    if (endLocation != null) {
      data['end_location'] = endLocation!.toJson();
    }
    data['start_address'] = startAddress;
    data['price'] = price;
    data['recommendedPrice'] = recommendedPrice;
    if (startLocation != null) {
      data['start_location'] = startLocation!.toJson();
    }
    return data;
  }
}