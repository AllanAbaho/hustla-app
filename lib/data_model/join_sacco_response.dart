// To parse this JSON data, do
//
//     final JoinSaccoResponse = JoinSaccoResponseFromJson(jsonString);

import 'dart:convert';

JoinSaccoResponse joinSaccoResponseFromJson(String str) =>
    JoinSaccoResponse.fromJson(json.decode(str));

String joinSaccoResponseToJson(JoinSaccoResponse data) =>
    json.encode(data.toJson());

class JoinSaccoResponse {
  JoinSaccoResponse({
    this.status,
    this.message,
  });

  String status;
  String message;

  factory JoinSaccoResponse.fromJson(Map<String, dynamic> json) =>
      JoinSaccoResponse(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
