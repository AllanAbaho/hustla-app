// To parse this JSON data, do
//
//     final TicketBookingResponse = TicketBookingResponseFromJson(jsonString);
//https://app.quicktype.io/
import 'dart:convert';

import 'package:active_ecommerce_flutter/data_model/confirm_booking_response.dart';

TicketBookingResponse ticketBookingResponseFromJson(String str) =>
    TicketBookingResponse.fromJson(json.decode(str));

String ticketBookingResponseToJson(TicketBookingResponse data) =>
    json.encode(data.toJson());

class TicketBookingResponse {
  TicketBookingResponse(
      {this.passengers,
      this.success,
      this.bookingconfirmation,
      this.bookingid,
      this.pnrref,
      this.ticketnumber,
      this.invoicenumber,
      this.deposit,
      this.status,
      this.title,
      this.firstname,
      this.lastname,
      this.eticket,
      this.errors});

  List<Passenger> passengers;
  bool success;
  String bookingconfirmation,
      pnrref,
      ticketnumber,
      status,
      title,
      firstname,
      lastname,
      eticket;
  int bookingid, invoicenumber, deposit;
  List<String> errors;

  factory TicketBookingResponse.fromJson(Map<String, dynamic> json) =>
      TicketBookingResponse(
          passengers:
              json.containsKey('aerocrs')
                  ? List<Passenger>.from((json['aerocrs']["passenger"]).map((x) =>
                      Passenger.fromJson(x)))
                  : [],
          success: json.containsKey('aerocrs')
              ? json['aerocrs']["success"]
              : json['success'],
          pnrref: json.containsKey('aerocrs') ? json['aerocrs']["pnrref"] : '',
          ticketnumber: json.containsKey('aerocrs')
              ? json['aerocrs']["ticketnumber"]
              : '',
          status: json.containsKey('aerocrs') ? json['aerocrs']["status"] : '',
          title: json.containsKey('aerocrs') ? json['aerocrs']["title"] : '',
          firstname:
              json.containsKey('aerocrs') ? json['aerocrs']["firstname"] : '',
          lastname:
              json.containsKey('aerocrs') ? json['aerocrs']["lastname"] : '',
          eticket:
              json.containsKey('aerocrs') ? json['aerocrs']["e-ticket"] : '',
          bookingconfirmation: json.containsKey('aerocrs')
              ? json['aerocrs']["bookingconfirmation"]
              : '',
          errors: json.containsKey('details')
              ? List<String>.from((json["details"]["detail"]))
              : []);

  Map<String, dynamic> toJson() => {
        "passengers": List<dynamic>.from(passengers.map((x) => x.toJson())),
        "success": success,
        "bookingconfirmation": bookingconfirmation,
        "errors": errors,
      };
}
