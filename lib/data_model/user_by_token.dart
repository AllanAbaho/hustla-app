// To parse this JSON data, do
//
//     final userByTokenResponse = userByTokenResponseFromJson(jsonString);

import 'dart:convert';

UserByTokenResponse userByTokenResponseFromJson(String str) =>
    UserByTokenResponse.fromJson(json.decode(str));

String userByTokenResponseToJson(UserByTokenResponse data) =>
    json.encode(data.toJson());

class UserByTokenResponse {
  UserByTokenResponse({
    this.result,
    this.id,
    this.name,
    this.email,
    this.avatar,
    this.avatar_original,
    this.phone,
    this.account_number,
    this.account_balance,
    this.sacco_name,
    this.sacco_balance,
  });

  bool result;
  int id;
  String name;
  String email;
  String avatar;
  String avatar_original;
  String phone;
  String account_number;
  String account_balance;
  String sacco_name;
  String sacco_balance;

  factory UserByTokenResponse.fromJson(Map<String, dynamic> json) =>
      UserByTokenResponse(
        result: json["result"] == null ? null : json["result"],
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        email: json["email"] == null ? null : json["email"],
        avatar: json["avatar"] == null ? null : json["avatar"],
        avatar_original:
            json["avatar_original"] == null ? null : json["avatar_original"],
        phone: json["phone"] == null ? null : json["phone"],
        account_number:
            json["account_number"] == null ? null : json["account_number"],
        account_balance:
            json["account_balance"] == null ? null : json["account_balance"],
        sacco_name: json["sacco_name"] == null ? null : json["sacco_name"],
        sacco_balance:
            json["sacco_balance"] == null ? null : json["sacco_balance"],
      );

  Map<String, dynamic> toJson() => {
        "result": result == null ? null : result,
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "email": email == null ? null : email,
        "avatar": avatar == null ? null : avatar,
        "avatar_original": avatar_original == null ? null : avatar_original,
        "phone": phone == null ? null : phone,
        "account_number": account_number == null ? null : account_number,
        "account_balance": account_balance == null ? null : account_balance,
        "sacco_name": sacco_name == null ? null : sacco_name,
        "sacco_balance": sacco_balance == null ? null : sacco_balance,
      };
}
