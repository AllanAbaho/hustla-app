import 'dart:convert';

TopUpResponse topUpResponseFromJson(String str) =>
    TopUpResponse.fromJson(json.decode(str));

String topUpResponseToJson(TopUpResponse data) => json.encode(data.toJson());

class TopUpResponse {
  TopUpResponse({
    this.status,
    this.transactionId,
    this.message,
  });

  String status;
  String transactionId;
  String message;

  factory TopUpResponse.fromJson(Map<String, dynamic> json) => TopUpResponse(
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
