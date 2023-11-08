import 'dart:convert';

List<UserModel> userFromJson(String str) =>
    List<UserModel>.from(json.decode(str).map((x) => UserModel.fromJson(x)));

String userToJson(List<UserModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserModel {
  String? username;
  String? phone;
  String? email;
  String? password;
  String? imageUrl;
  String? birthofdate;
  String? address;

  UserModel({
    this.username,
    this.phone,
    this.email,
    this.password,
    this.imageUrl,
    this.birthofdate,
    this.address,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    username: json["username"],
    phone: json["phone"],
    email: json['email'],
    password: json["password"],
    imageUrl: json["imageUrl"],
    birthofdate: json["birth of date"],
    address: json["address"],
  );

  Map<String, dynamic> toJson() => {
    "username": username,
    "phone": phone,
    "email": email,
    "password": password,
    "imageUrl": imageUrl,
    "birth of date": birthofdate,
    "address": address,
  };
}
