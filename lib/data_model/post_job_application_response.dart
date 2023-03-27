import 'dart:convert';

PostJobApplicationResponse postJobApplicationResponseFromJson(String str) =>
    PostJobApplicationResponse.fromJson(json.decode(str));

String postJobApplicationResponseToJson(PostJobApplicationResponse data) =>
    json.encode(data.toJson());

class PostJobApplicationResponse {
  PostJobApplicationResponse({
    this.status,
    this.message,
  });

  bool status;
  String message;

  factory PostJobApplicationResponse.fromJson(Map<String, dynamic> json) =>
      PostJobApplicationResponse(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
