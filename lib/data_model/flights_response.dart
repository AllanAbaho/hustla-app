// To parse this JSON data, do
//
//     final FlightsResponse = FlightsResponseFromJson(jsonString);
//https://app.quicktype.io/
import 'dart:convert';

FlightsResponse flightsResponseFromJson(String str) =>
    FlightsResponse.fromJson(json.decode(str));

String flightsResponseToJson(FlightsResponse data) =>
    json.encode(data.toJson());

class FlightsResponse {
  FlightsResponse({
    this.flights,
    this.success,
    this.message,
    this.count,
  });

  List<Flight> flights;
  bool success;
  String message;
  int count;

  factory FlightsResponse.fromJson(Map<String, dynamic> json) =>
      FlightsResponse(
        flights: json['aerocrs']["success"] == true &&
                json['aerocrs']["flights"]['count'] > 0
            ? List<Flight>.from((json['aerocrs']["flights"]["flight"])
                .map((x) => Flight.fromJson(x)))
            : [],
        success: json['aerocrs']["success"],
        message: json['aerocrs']["success"] == false
            ? json['aerocrs']["details"]['detail']
            : '',
        count: json['aerocrs']["success"] == true
            ? json['aerocrs']["flights"]['count']
            : 0,
      );

  Map<String, dynamic> toJson() => {
        "flights": List<dynamic>.from(flights.map((x) => x.toJson())),
        "success": success,
        "message": message,
        "count": count,
      };
}

class Flight {
  Flight({
    this.airlineName,
    this.aircraftType,
    this.airlineLogo,
    this.flighttype,
    this.flightcode,
    this.direction,
    this.flightid,
    this.freeseats,
    this.baggageAllowance,
    this.departureTerminal,
    this.arrivalTerminal,
    this.rules,
    this.fare,
    this.fareid,
    this.departureTime,
    this.arrivalTime,
    this.fromcode,
    this.tocode,
    this.cabinClass,
  });

  String airlineName;
  String aircraftType;
  String airlineLogo;
  String flighttype;
  int flightcode;
  String direction;
  String departureTerminal;
  String arrivalTerminal;
  List<String> rules;
  int flightid;
  int freeseats;
  int baggageAllowance;
  Fare fare;
  int fareid;
  String departureTime;
  String arrivalTime;
  String fromcode;
  String tocode;
  String cabinClass;

  factory Flight.fromJson(Map<String, dynamic> json) => Flight(
        airlineName: json["airlineName"],
        aircraftType: json["aircraftType"],
        airlineLogo: json["airlineLogo"],
        flighttype: json["flighttype"],
        flightcode: json["flightcode"],
        direction: json["direction"],
        departureTerminal: json["departureTerminal"],
        arrivalTerminal: json["arrivalTerminal"],
        rules: List<String>.from((json['rules'])),
        flightid: json['classes']['Y']["flightid"],
        freeseats: json['classes']['Y']["freeseats"],
        baggageAllowance: json['classes']['Y']["baggageAllowance"],
        fare: Fare.fromJson(json['classes']['Y']["fare"]),
        fareid: json['classes']['Y']["fareid"],
        departureTime: json["STDinUTC"],
        arrivalTime: json["STAinUTC"],
        fromcode: json["fromcode"],
        tocode: json["tocode"],
        cabinClass: json['classes']['Y']["cabinClass"],
      );

  Map<String, dynamic> toJson() => {
        "airlineName": airlineName,
        "aircraftType": aircraftType,
        "airlineLogo": airlineLogo,
        "flighttype": flighttype,
        "flightcode": flightcode,
        "direction": direction,
        "departureTerminal": departureTerminal,
        "arrivalTerminal": arrivalTerminal,
        "rules": List<dynamic>.from(rules),
        "flightid": flightid,
        "freeseats": freeseats,
        "baggageAllowance": baggageAllowance,
        "fare": fare.toJson(),
        "fareid": fareid,
        "STDinUTC": departureTime,
        "STAinUTC": arrivalTime,
        "fromcode": fromcode,
        "tocode": tocode,
        "cabinClass": cabinClass,
      };
}

class Fare {
  Fare({this.tax, this.adultFare, this.childFare, this.infantFare});
  String tax, adultFare, childFare, infantFare;
  factory Fare.fromJson(Map<String, dynamic> json) => Fare(
        tax: json["tax"],
        adultFare: json["adultFare"],
        childFare: json["childFare"],
        infantFare: json["infantFare"],
      );

  Map<String, dynamic> toJson() => {
        "tax": tax,
        "adultFare": adultFare,
        "childFare": childFare,
        "infantFare": infantFare,
      };
}
