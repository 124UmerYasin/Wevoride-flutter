
class UserVerificationModel {
  List<Documents>? documents;
  String? id;

  UserVerificationModel({this.documents, this.id});

  UserVerificationModel.fromJson(Map<String, dynamic> json) {
    if (json['documents'] != null) {
      documents = <Documents>[];
      json['documents'].forEach((v) {
        documents!.add(Documents.fromJson(v));
      });
    }
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (documents != null) {
      data['documents'] = documents!.map((v) => v.toJson()).toList();
    }
    data['id'] = id;
    return data;
  }
}

class Documents {
  String? frontImage;
  String? documentNumber;
  bool? verified;
  String? documentId;
  String? backImage;
  String? status;

  Documents({this.frontImage, this.documentNumber, this.verified, this.documentId, this.backImage,this.status});

  Documents.fromJson(Map<String, dynamic> json) {
    frontImage = json['frontImage'];
    documentNumber = json['documentNumber'];
    verified = json['verified'];
    documentId = json['documentId'];
    backImage = json['backImage'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['frontImage'] = frontImage;
    data['documentNumber'] = documentNumber;
    data['verified'] = verified;
    data['documentId'] = documentId;
    data['backImage'] = backImage;
    data['status'] = status;
    return data;
  }
}
