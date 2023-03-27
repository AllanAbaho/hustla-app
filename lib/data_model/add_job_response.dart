import 'dart:convert';

AddJobResponse addJobResponseFromJson(String str) =>
    AddJobResponse.fromJson(json.decode(str));

String addJobResponseToJson(AddJobResponse data) => json.encode(data.toJson());

class AddJobResponse {
  AddJobResponse({
    this.status,
    this.message,
  });

  bool status;
  String message;

  factory AddJobResponse.fromJson(Map<String, dynamic> json) => AddJobResponse(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
