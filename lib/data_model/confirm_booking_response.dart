// To parse this JSON data, do
//
//     final ConfirmBookingResponse = ConfirmBookingResponseFromJson(jsonString);
//https://app.quicktype.io/
import 'dart:convert';

ConfirmBookingResponse confirmBookingResponseFromJson(String str) =>
    ConfirmBookingResponse.fromJson(json.decode(str));

String confirmBookingResponseToJson(ConfirmBookingResponse data) =>
    json.encode(data.toJson());

class ConfirmBookingResponse {
  ConfirmBookingResponse(
      {this.passengers,
      this.success,
      this.bookingconfirmation,
      this.errorMessage,
      this.topay});

  List<Passenger> passengers;
  bool success;
  String bookingconfirmation;
  String errorMessage;
  String topay;

  factory ConfirmBookingResponse.fromJson(Map<String, dynamic> json) =>
      ConfirmBookingResponse(
          passengers: json.containsKey('aerocrs')
              ? List<Passenger>.from((json['aerocrs']["passenger"])
                  .map((x) => Passenger.fromJson(x)))
              : [],
          success: json.containsKey('aerocrs')
              ? json['aerocrs']["success"]
              : json['success'],
          bookingconfirmation: json.containsKey('aerocrs')
              ? json['aerocrs']["bookingconfirmation"]
              : '',
          topay: json.containsKey('aerocrs') ? json['aerocrs']["topay"] : '',
          errorMessage:
              json.containsKey('aerocrs') ? '' : json['details']['detail'][0]);

  Map<String, dynamic> toJson() => {
        "passengers": List<dynamic>.from(passengers.map((x) => x.toJson())),
        "success": success,
        "bookingconfirmation": bookingconfirmation,
        "topay": topay,
      };
}

class Passenger {
  Passenger(
      {this.paxtitle,
      this.firstname,
      this.lastname,
      this.paxage,
      this.paxnationailty,
      this.paxdoctype,
      this.paxdocnumber,
      this.paxdocissuer,
      this.paxdocexpiry,
      this.paxbirthdate,
      this.paxphone,
      this.paxemail,
      this.paxnum});

  String paxtitle,
      firstname,
      lastname,
      paxage,
      paxnationailty,
      paxdoctype,
      paxdocnumber,
      paxdocissuer,
      paxdocexpiry,
      paxbirthdate,
      paxphone,
      paxemail;
  int paxnum;

  factory Passenger.fromJson(Map<String, dynamic> json) => Passenger(
        paxtitle: json["paxtitle"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        paxage: json["paxage"],
        paxnationailty: json["paxnationailty"],
        paxdoctype: json["paxdoctype"],
        paxdocnumber: json["paxdocnumber"],
        paxdocissuer: json["paxdocissuer"],
        paxdocexpiry: json["paxdocexpiry"],
        paxbirthdate: json["paxbirthdate"],
        paxphone: json["paxphone"],
        paxemail: json["paxemail"],
        paxnum: json["paxnum"],
      );

  Map<String, dynamic> toJson() => {
        "paxtitle": paxtitle,
        "firstname": firstname,
        "lastname": lastname,
        "paxage": paxage,
        "paxnationailty": paxnationailty,
        "paxdoctype": paxdoctype,
        "paxdocnumber": paxdocnumber,
        "paxdocissuer": paxdocissuer,
        "paxdocexpiry": paxdocexpiry,
        "paxbirthdate": paxbirthdate,
        "paxphone": paxphone,
        "paxemail": paxemail,
        "paxnum": paxnum,
      };
}
