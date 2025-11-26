class DocumentModel {
  bool? backSide;
  bool? enable;
  String? id;
  bool? frontSide;
  String? title;

  DocumentModel({this.backSide, this.enable, this.id, this.frontSide, this.title});

  DocumentModel.fromJson(Map<String, dynamic> json) {
    backSide = json['backSide'];
    enable = json['enable'];
    id = json['id'];
    frontSide = json['frontSide'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['backSide'] = backSide;
    data['enable'] = enable;
    data['id'] = id;
    data['frontSide'] = frontSide;
    data['title'] = title;
    return data;
  }
}
