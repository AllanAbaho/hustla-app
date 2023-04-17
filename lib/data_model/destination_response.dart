// To parse this JSON data, do
//
//     final DestinationResponse = DestinationResponseFromJson(jsonString);
//https://app.quicktype.io/
import 'dart:convert';

DestinationResponse destinationResponseFromJson(String str) =>
    DestinationResponse.fromJson(json.decode(str));

String destinationResponseToJson(DestinationResponse data) =>
    json.encode(data.toJson());

class DestinationResponse {
  DestinationResponse({
    this.destinations,
    this.success,
  });

  List<Destination> destinations;
  bool success;

  factory DestinationResponse.fromJson(Map<String, dynamic> json) =>
      DestinationResponse(
        destinations: List<Destination>.from((json['aerocrs']["destinations"]
                ["destination"])
            .map((x) => Destination.fromJson(x))),
        success: json['aerocrs']["success"],
      );

  Map<String, dynamic> toJson() => {
        "destinations": List<dynamic>.from(destinations.map((x) => x.toJson())),
        "success": success,
      };
}

class Destination {
  Destination({
    this.name,
    this.code,
    this.iatacode,
    this.icaocode,
    this.country,
    this.countryiso,
  });

  String name;
  String code;
  String iatacode;
  String icaocode;
  String country;
  String countryiso;

  factory Destination.fromJson(Map<String, dynamic> json) => Destination(
        name: json["name"],
        code: json["code"],
        iatacode: json["iatacode"],
        icaocode: json["icaocode"],
        country: json["country"],
        countryiso: json["countryiso"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "code": code,
        "iatacode": iatacode,
        "icaocode": icaocode,
        "country": country,
        "countryiso": countryiso,
      };
}

class CabinClass {
  CabinClass(
    this.name,
    this.code,
  );

  String name;
  String code;
}

class TripType {
  TripType(
    this.name,
    this.code,
  );

  String name;
  String code;
}
