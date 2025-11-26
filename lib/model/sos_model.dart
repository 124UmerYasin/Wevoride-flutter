class SosModel {
  String? id;
  String? bookingId;
  String? status;
  String? customerId;
  String? driverId;
  SOSLocation? sosLocation;

  SosModel({this.id, this.bookingId, this.status, this.customerId, this.driverId, this.sosLocation});

  SosModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookingId = json['bookingId'];
    status = json['status'];
    customerId = json['customerId'];
    driverId = json['driverId'];
    sosLocation = json['sosLocation'] != null ? SOSLocation.fromJson(json['sosLocation']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['bookingId'] = bookingId;
    data['status'] = status;
    data['customerId'] = customerId;
    data['driverId'] = driverId;
    data['sosLocation'] = sosLocation?.toJson();
    return data;
  }
}

class SOSLocation {
  double latitude;
  double longitude;

  SOSLocation({this.latitude = 0.01, this.longitude = 0.01});

  factory SOSLocation.fromJson(Map<dynamic, dynamic> parsedJson) {
    return SOSLocation(
      latitude: parsedJson['latitude'] ?? 00.1,
      longitude: parsedJson['longitude'] ?? 00.1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
