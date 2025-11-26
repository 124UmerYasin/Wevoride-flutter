import 'package:wevoride/model/map/geometry.dart';

class CityModel {
  Geometry? geometry;
  String? name;
  String? placeId;
  bool? isArrived;

  CityModel({this.geometry, this.name, this.placeId,this.isArrived});

  CityModel.fromJson(Map<String, dynamic> json) {
    geometry = json['geometry'] != null ? Geometry.fromJson(json['geometry']) : null;
    name = json['name'];
    placeId = json['place_id'];
    isArrived = json['isArrived'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (geometry != null) {
      data['geometry'] = geometry!.toJson();
    }
    data['name'] = name;
    data['place_id'] = placeId;
    data['isArrived'] = isArrived;
    return data;
  }
}
