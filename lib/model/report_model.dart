class ReportModel {
  String? description;
  String? id;
  String? bookingId;
  String? title;
  String? reportedTo;
  String? reportedFrom;
  String? status;


  ReportModel({this.description, this.id, this.title,this.status,this.bookingId});

  ReportModel.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    id = json['id'];
    title = json['title'];
    reportedTo = json['reportedTo'];
    reportedFrom = json['reportedFrom'];
    status = json['status'];
    bookingId = json['bookingId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['description'] = description;
    data['id'] = id;
    data['title'] = title;
    data['reportedTo'] = reportedTo;
    data['reportedFrom'] = reportedFrom;
    data['status'] = status;
    data['bookingId'] = bookingId;
    return data;
  }
}
