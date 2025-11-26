import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  String? comment;
  String? rating;
  String? id;
  String? userId;
  String? receiverId;
  Timestamp? date;
  String? senderId;
  String? bookingId;

  ReviewModel({this.comment, this.rating, this.id, this.date, this.senderId, this.receiverId, this.bookingId});

  ReviewModel.fromJson(Map<String, dynamic> json) {
    comment = json['comment'];
    rating = json['rating'];
    id = json['id'];
    date = json['date'];
    senderId = json['sender_id'];
    receiverId = json['receiver_id'];
    bookingId = json['booking_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['comment'] = comment;
    data['rating'] = rating;
    data['id'] = id;
    data['date'] = date;
    data['sender_id'] = senderId;
    data['receiver_id'] = receiverId;
    data['booking_id'] = bookingId;
    return data;
  }
}
