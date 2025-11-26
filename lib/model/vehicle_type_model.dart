class VehicleTypeModel {
  bool? enable;
  String? id;
  String? name;
  String? perKmCharges;

  VehicleTypeModel({this.id, this.name, this.enable,this.perKmCharges});

  VehicleTypeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    enable = json['enable'];
    perKmCharges = json['perKmCharges'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['enable'] = enable;
    data['perKmCharges'] = perKmCharges;
    return data;
  }
}
