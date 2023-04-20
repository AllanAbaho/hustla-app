// To parse this JSON data, do
//
//     final CreateBookingResponse = CreateBookingResponseFromJson(jsonString);
//https://app.quicktype.io/
import 'dart:convert';

CreateBookingResponse createBookingResponseFromJson(String str) =>
    CreateBookingResponse.fromJson(json.decode(str));

String createBookingResponseToJson(CreateBookingResponse data) =>
    json.encode(data.toJson());

class CreateBookingResponse {
  CreateBookingResponse({this.booking, this.success, this.errors});

  Booking booking;
  bool success;
  List<String> errors;

  factory CreateBookingResponse.fromJson(Map<String, dynamic> json) =>
      CreateBookingResponse(
          booking: json.containsKey('aerocrs')
              ? Booking.fromJson((json['aerocrs']["booking"]))
              : null,
          success: json.containsKey('aerocrs')
              ? json['aerocrs']["success"]
              : json['success'],
          errors: json.containsKey('details')
              ? List<String>.from((json["details"]["detail"]))
              : []);

  Map<String, dynamic> toJson() => {
        "booking": booking,
        "success": success,
      };
}

class Booking {
  Booking({
    this.bookingid,
    this.pnrref,
    this.pnrttl,
  });

  int bookingid;
  String pnrref;
  String pnrttl;

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
        bookingid: json["bookingid"],
        pnrref: json["pnrref"],
        pnrttl: json["pnrttl"],
      );

  Map<String, dynamic> toJson() => {
        "bookingid": bookingid,
        "pnrref": pnrref,
        "pnrttl": pnrttl,
      };
}
