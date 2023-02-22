// To parse this JSON data, do
//
//     final signupResponse = signupResponseFromJson(jsonString);

import 'dart:convert';

SignupResponse signupResponseFromJson(String str) =>
    SignupResponse.fromJson(json.decode(str));

String signupResponseToJson(SignupResponse data) => json.encode(data.toJson());

class SignupResponse {
  SignupResponse(
      {this.result, this.message, this.user_id, this.verification_code});

  bool result;
  String message;
  int user_id;
  String verification_code;

  factory SignupResponse.fromJson(Map<String, dynamic> json) => SignupResponse(
        result: json["result"],
        message: json["message"],
        user_id: json["user_id"],
        verification_code: json["verification_code"],
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "message": message,
        "user_id": user_id,
        "verification_code": verification_code,
      };
}
