// To parse this JSON data, do
//
//     final MakePaymentResponse = MakePaymentResponseFromJson(jsonString);
//https://app.quicktype.io/
import 'dart:convert';

MakeAirlinePaymentResponse makeAirlinePaymentResponseFromJson(String str) =>
    MakeAirlinePaymentResponse.fromJson(json.decode(str));

String makeAirlinePaymentResponseToJson(MakeAirlinePaymentResponse data) =>
    json.encode(data.toJson());

class MakeAirlinePaymentResponse {
  MakeAirlinePaymentResponse(
      {this.paymentstatusexplanation,
      this.paymentstatus,
      this.success,
      this.errors});

  String paymentstatus, paymentstatusexplanation;
  bool success;
  List<String> errors;

  factory MakeAirlinePaymentResponse.fromJson(Map<String, dynamic> json) =>
      MakeAirlinePaymentResponse(
          paymentstatusexplanation: json['aerocrs']["paymentstatusexplanation"],
          paymentstatus: json['aerocrs']["paymentstatus"],
          success: json['aerocrs']["success"],
          errors: json['aerocrs'].containsKey('details')
              ? List<String>.from((json['aerocrs']["details"]["detail"]))
              : []);

  Map<String, dynamic> toJson() => {
        "paymentstatusexplanation": paymentstatusexplanation,
        "paymentstatus": paymentstatus,
        "success": success,
        "errors": errors,
      };
}
