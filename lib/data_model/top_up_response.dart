import 'dart:convert';

TransactionResponse transactionResponseFromJson(String str) =>
    TransactionResponse.fromJson(json.decode(str));

String transactionResponseToJson(TransactionResponse data) =>
    json.encode(data.toJson());

class TransactionResponse {
  TransactionResponse(
      {this.status, this.transactionId, this.message, this.finalStatus});

  String status;
  String transactionId;
  String message;
  String finalStatus;

  factory TransactionResponse.fromJson(Map<String, dynamic> json) =>
      TransactionResponse(
        status: json["status"],
        transactionId: json["transactionid"],
        message: json["message"],
        finalStatus: json["finalStatus"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "transactionId": transactionId,
        "message": message,
        "finalStatus": finalStatus,
      };
}
