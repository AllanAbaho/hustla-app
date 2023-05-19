// To parse this JSON data, do
//
//     final TicketBookingResponse = TicketBookingResponseFromJson(jsonString);
//https://app.quicktype.io/
import 'dart:convert';

import 'package:hustla/data_model/confirm_booking_response.dart';

TicketBookingResponse ticketBookingResponseFromJson(String str) =>
    TicketBookingResponse.fromJson(json.decode(str));

String ticketBookingResponseToJson(TicketBookingResponse data) =>
    json.encode(data.toJson());

class TicketBookingResponse {
  TicketBookingResponse({this.success, this.errors});

  bool success;
  List<String> errors;

  factory TicketBookingResponse.fromJson(Map<String, dynamic> json) =>
      TicketBookingResponse(
          success: json.containsKey('aerocrs')
              ? json['aerocrs']["success"]
              : json['success'],
          errors: json.containsKey('details')
              ? List<String>.from((json["details"]["detail"]))
              : []);

  Map<String, dynamic> toJson() => {
        "success": success,
        "errors": errors,
      };
}
