// To parse this JSON data, do
//
//     final AuthorizeOtpResponse = AuthorizeOtpResponseFromJson(jsonString);

import 'dart:convert';

AuthorizeOtpResponse authorizeOtpResponseFromJson(String str) =>
    AuthorizeOtpResponse.fromJson(json.decode(str));

String authorizeOtpResponseToJson(AuthorizeOtpResponse data) =>
    json.encode(data.toJson());

class AuthorizeOtpResponse {
  AuthorizeOtpResponse({
    this.status,
    this.transactionId,
    this.message,
  });

  String status;
  String transactionId;
  String message;

  factory AuthorizeOtpResponse.fromJson(Map<String, dynamic> json) =>
      AuthorizeOtpResponse(
        status: json["status"],
        transactionId: json["transactionId"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "transactionId": transactionId,
        "message": message,
      };
}
