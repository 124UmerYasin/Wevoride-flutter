import 'package:cloud_firestore/cloud_firestore.dart';

class InboxAdminModel {
  String? adminId;
  String? adminName;
  String? userName;
  String? userId;
  String? userProfileImage;
  String? lastMessage;
  String? lastSenderId;
  Timestamp? createdAt;
  String? chatType;
  String? type;

  InboxAdminModel({
    this.adminId,
    this.adminName,
    this.userName,
    this.userId,
    this.userProfileImage,
    this.lastMessage,
    this.lastSenderId,
    this.createdAt,
    this.chatType,
    this.type,
  });

  factory InboxAdminModel.fromJson(Map<String, dynamic> parsedJson) {
    return InboxAdminModel(
      adminId: parsedJson['adminId'] ?? '',
      adminName: parsedJson['adminName'],
      userName: parsedJson['userName'] ?? '',
      userProfileImage: parsedJson['userProfileImage'] ?? '',
      lastMessage: parsedJson['lastMessage'],
      lastSenderId: parsedJson['lastSenderId'] ?? '',
      createdAt: parsedJson['createdAt'] ?? '',
      chatType: parsedJson['chatType'] ?? '',
      type: parsedJson['type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'adminId': adminId,
      'adminName': adminName,
      'userName': userName,
      'userProfileImage': userProfileImage,
      'lastMessage': lastMessage,
      'lastSenderId': lastSenderId,
      'createdAt': createdAt,
      'chatType': chatType,
      'type': type
    };
  }
}
