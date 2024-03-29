// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  String? id;
  String? userFirstName;
  String? userLastName;
  String? userEmail;
  String? userPassword;
  String? role;
  int? taskCompleted;
  int? certificateRecieved;
  int? reward;
  DateTime? createdDate;
  List<dynamic>? favoriteItems;
  String? userImage;
  String? userMobileNo;

  User({
    this.id,
    this.userFirstName,
    this.userLastName,
    this.userEmail,
    this.userPassword,
    this.role,
    this.taskCompleted,
    this.certificateRecieved,
    this.reward,
    this.createdDate,
    this.favoriteItems,
    this.userImage,
    this.userMobileNo,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"],
        userFirstName: json["userFirstName"],
        userLastName: json["userLastName"],
        userEmail: json["userEmail"],
        userPassword: json["userPassword"],
        role: json["role"],
        taskCompleted: json["taskCompleted"],
        certificateRecieved: json["certificateRecieved"],
        reward: json["reward"],
        createdDate: json["createdDate"] == null
            ? null
            : DateTime.parse(json["createdDate"]),
        favoriteItems: json["favoriteItems"] == null
            ? []
            : List<dynamic>.from(json["favoriteItems"]!.map((x) => x)),
        userImage: json["userImage"],
        userMobileNo: json["userMobileNo"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "userFirstName": userFirstName,
        "userLastName": userLastName,
        "userEmail": userEmail,
        "userPassword": userPassword,
        "role": role,
        "taskCompleted": taskCompleted,
        "certificateRecieved": certificateRecieved,
        "reward": reward,
        "createdDate": createdDate?.toIso8601String(),
        "favoriteItems": favoriteItems == null
            ? []
            : List<dynamic>.from(favoriteItems!.map((x) => x)),
        "userImage": userImage,
        "userMobileNo": userMobileNo,
      };
}
