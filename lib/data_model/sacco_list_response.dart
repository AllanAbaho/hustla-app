// To parse this JSON data, do
//
//     final SaccoListResponse = SaccoListResponseFromJson(jsonString);
//https://app.quicktype.io/
import 'dart:convert';

SaccoListResponse saccoListResponseFromJson(String str) =>
    SaccoListResponse.fromJson(json.decode(str));

String saccoListResponseToJson(SaccoListResponse data) =>
    json.encode(data.toJson());

class SaccoListResponse {
  SaccoListResponse({
    this.members,
    this.status,
    this.message,
  });

  List<Sacco> members;
  String message;
  String status;

  factory SaccoListResponse.fromJson(Map<String, dynamic> json) =>
      SaccoListResponse(
        members:
            List<Sacco>.from(json["members"].map((x) => Sacco.fromJson(x))),
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "members": List<dynamic>.from(members.map((x) => x.toJson())),
        "status": status,
        "message": message,
      };
}

class Sacco {
  Sacco({
    this.id,
    this.name,
  });

  String id;
  String name;

  factory Sacco.fromJson(Map<String, dynamic> json) => Sacco(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
