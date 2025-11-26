import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? firstName;
  String? lastName;
  String? bio;
  String? id;
  String? email;
  String? loginType;
  String? profilePic;
  String? dateOfBirth;
  String? fcmToken;
  String? countryCode;
  String? phoneNumber;
  String? walletAmount;
  String? gender;
  bool? isActive;
  bool? isVerify;
  TravelPreferenceModel? travelPreference;
  Timestamp? createdAt;
  String? reviewCount;
  String? reviewSum;

  UserModel({
    this.id,
    this.firstName,
    this.lastName,
    this.isActive,
    this.dateOfBirth,
    this.email,
    this.loginType,
    this.profilePic,
    this.fcmToken,
    this.countryCode,
    this.phoneNumber,
    this.walletAmount,
    this.createdAt,
    this.gender,
    this.travelPreference,
    this.bio,
    this.reviewSum,
    this.reviewCount,
  });

  fullName() {
    return "${firstName ?? ''} ${lastName ?? ''}";
  }

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    loginType = json['loginType'];
    profilePic = json['profilePic'];
    fcmToken = json['fcmToken'];
    countryCode = json['countryCode'];
    phoneNumber = json['phoneNumber'];
    walletAmount = json['walletAmount'] ?? "0.0";
    createdAt = json['createdAt'];
    gender = json['gender'];
    dateOfBirth = json['dateOfBirth'] ?? '';
    isActive = json['isActive'];
    isVerify = json['isVerify'];
    bio = json['bio'] ?? '';
    travelPreference = json['travelPreference'] != null ? TravelPreferenceModel.fromJson(json['travelPreference']) : null;
    reviewSum = json['reviewSum'] ?? '0.0';
    reviewCount = json['reviewCount']??'0.0';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    if (travelPreference != null) {
      data['travelPreference'] = travelPreference!.toJson();
    }
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['loginType'] = loginType;
    data['profilePic'] = profilePic;
    data['fcmToken'] = fcmToken;
    data['countryCode'] = countryCode;
    data['phoneNumber'] = phoneNumber;
    data['walletAmount'] = walletAmount;
    data['createdAt'] = createdAt;
    data['gender'] = gender;
    data['dateOfBirth'] = dateOfBirth;
    data['isActive'] = isActive;
    data['isVerify'] = isVerify;
    data['bio'] = bio;
    data['reviewSum'] = reviewSum;
    data['reviewCount'] = reviewCount;
    return data;
  }
}

class TravelPreferenceModel {
  String? chattiness;
  String? smoking;
  String? music;
  String? pets;

  TravelPreferenceModel({this.chattiness, this.smoking, this.music, this.pets});

  TravelPreferenceModel.fromJson(Map<String, dynamic> json) {
    chattiness = json['chattiness'];
    smoking = json['smoking'];
    music = json['music'];
    pets = json['pets'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['chattiness'] = chattiness;
    data['smoking'] = smoking;
    data['music'] = music;
    data['pets'] = pets;
    return data;
  }
}
