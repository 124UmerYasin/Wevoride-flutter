class VehicleModel {
  bool? enable;
  String? id;
  String? brandId;
  String? name;

  VehicleModel({this.id, this.name, this.enable,this.brandId});

  VehicleModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    brandId = json['brandId'];
    name = json['name'];
    enable = json['enable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['brandId'] = brandId;
    data['name'] = name;
    data['enable'] = enable;
    return data;
  }
}
