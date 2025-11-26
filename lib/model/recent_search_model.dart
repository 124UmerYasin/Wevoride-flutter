import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wevoride/model/map/geometry.dart';

class RecentSearchModel {
  String? id;
  String? userId;
  String? pickUpAddress;
  String? dropAddress;
  Location? pickUpLocation;
  Location? dropLocation;
  String? person;
  Timestamp? bookedDate;
  Timestamp? createdAt;

  RecentSearchModel({this.id, this.userId,this.pickUpAddress,this.dropAddress, this.pickUpLocation, this.dropLocation, this.person, this.bookedDate, this.createdAt});

  RecentSearchModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    userId = json['userId'] ?? '';
    pickUpAddress = json['pickUpAddress'] ?? '';
    dropAddress = json['dropAddress'] ?? '';
    pickUpLocation = json['pickUpLocation'] != null ? Location.fromJson(json['pickUpLocation']) : null;
    dropLocation = json['dropLocation'] != null ? Location.fromJson(json['dropLocation']) : null;
    person = json['person'];
    bookedDate = json['bookedDate'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (pickUpLocation != null) {
      data['pickUpLocation'] = pickUpLocation!.toJson();
    }
    if (dropLocation != null) {
      data['dropLocation'] = dropLocation!.toJson();
    }
    data['pickUpAddress'] = pickUpAddress;
    data['dropAddress'] = dropAddress;
    data['person'] = person;
    data['bookedDate'] = bookedDate;
    data['createdAt'] = createdAt;
    data['id'] = id;
    data['userId'] = userId;
    return data;
  }
}
