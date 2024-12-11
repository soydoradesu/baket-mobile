// To parse this JSON data, do
//
//     final userProfile = userProfileFromJson(jsonString);

import 'dart:convert';

UserProfile userProfileFromJson(String str) => UserProfile.fromJson(json.decode(str));

String userProfileToJson(UserProfile data) => json.encode(data.toJson());

class UserProfile {
  String username;
  String firstName;
  String lastName;
  DateTime birthDate;
  String gender;
  dynamic email;
  dynamic phoneNumber;
  bool isStaff;
  bool isSuperuser;
  String profilePicture;

  UserProfile({
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    required this.gender,
    required this.email,
    required this.phoneNumber,
    required this.isStaff,
    required this.isSuperuser,
    required this.profilePicture,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    username: json["username"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    birthDate: DateTime(
      DateTime.parse(json["birth_date"]).year,
      DateTime.parse(json["birth_date"]).month,
      DateTime.parse(json["birth_date"]).day,
    ),
    gender: json["gender"],
    email: json["email"],
    phoneNumber: json["phone_number"],
    isStaff: json["is_staff"],
    isSuperuser: json["is_superuser"],
    profilePicture: json["profile_picture"],
  );

  Map<String, dynamic> toJson() => {
    "username": username,
    "first_name": firstName,
    "last_name": lastName,
    "birth_date": "${birthDate.year.toString().padLeft(4, '0')}-${birthDate.month.toString().padLeft(2, '0')}-${birthDate.day.toString().padLeft(2, '0')}",
    "gender": gender,
    "email": email,
    "phone_number": phoneNumber,
    "is_staff": isStaff,
    "is_superuser": isSuperuser,
    "profile_picture": profilePicture,
  };
}
