// To parse this JSON data, do
//
//     final PaySellerResponse = PaySellerResponseFromJson(jsonString);

import 'dart:convert';

PaySellerResponse paySellerResponseFromJson(String str) =>
    PaySellerResponse.fromJson(json.decode(str));

String paySellerResponseToJson(PaySellerResponse data) =>
    json.encode(data.toJson());

class PaySellerResponse {
  PaySellerResponse({
    this.status,
    this.transactionId,
    this.message,
  });

  String status;
  String transactionId;
  String message;

  factory PaySellerResponse.fromJson(Map<String, dynamic> json) =>
      PaySellerResponse(
        status: json["status"],
        transactionId: json["transactionid"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "transactionId": transactionId,
        "message": message,
      };
}
