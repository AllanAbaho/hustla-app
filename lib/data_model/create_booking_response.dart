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
  CreateBookingResponse({
    this.booking,
    this.success,
  });

  Booking booking;
  bool success;

  factory CreateBookingResponse.fromJson(Map<String, dynamic> json) =>
      CreateBookingResponse(
        booking: Booking.fromJson((json['aerocrs']["booking"])),
        success: json['aerocrs']["success"],
      );

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
