import 'package:cloud_firestore/cloud_firestore.dart';

class ConversationAdminModel {
  String? id;
  String? senderId;
  String? receiverId;
  String? orderId;
  String? message;
  String? messageType;
  String? videoThumbnail;
  Url? url;
  Timestamp? createdAt;
  bool? seen;

  ConversationAdminModel({
    this.id,
    this.senderId,
    this.receiverId,
    this.orderId,
    this.message,
    this.messageType,
    this.videoThumbnail,
    this.url,
    this.createdAt,
    this.seen,
  });

  factory ConversationAdminModel.fromJson(Map<String, dynamic> parsedJson) {
    return ConversationAdminModel(
        id: parsedJson['id'] ?? '',
        senderId: parsedJson['senderId'] ?? '',
        receiverId: parsedJson['receiverId'] ?? '',
        orderId: parsedJson['orderId'] ?? '',
        message: parsedJson['message'] ?? '',
        messageType: parsedJson['messageType'] ?? '',
        videoThumbnail: parsedJson['videoThumbnail'] ?? '',
        url: parsedJson.containsKey('url')
            ? parsedJson['url'] != null
                ? Url.fromJson(parsedJson['url'])
                : null
            : Url(),
        createdAt: parsedJson['createdAt'] ?? Timestamp.now(),
        seen: parsedJson['seen']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      if (orderId != null && orderId != '') 'orderId': orderId,
      'message': message,
      'messageType': messageType,
      'videoThumbnail': videoThumbnail,
      'url': url == null ? null : url!.toJson(),
      'createdAt': createdAt,
      if (seen != null) 'seen': seen
    };
  }
}

class Url {
  String mime;

  String url;

  Url({this.mime = '', this.url = ''});

  factory Url.fromJson(Map<dynamic, dynamic> parsedJson) {
    return Url(mime: parsedJson['mime'] ?? '', url: parsedJson['url'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'mime': mime, 'url': url};
  }
}
