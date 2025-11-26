class VehicleBrandModel {
  bool? enable;
  String? id;
  String? name;

  VehicleBrandModel({this.id, this.name, this.enable});

  VehicleBrandModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    enable = json['enable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['enable'] = enable;
    return data;
  }
}
