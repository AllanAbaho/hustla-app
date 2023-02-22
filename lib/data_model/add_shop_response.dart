import 'dart:convert';

AddShopResponse addShopResponseFromJson(String str) =>
    AddShopResponse.fromJson(json.decode(str));

String addShopResponseToJson(AddShopResponse data) =>
    json.encode(data.toJson());

class AddShopResponse {
  AddShopResponse({
    this.success,
    this.message,
  });

  bool success;
  String message;

  factory AddShopResponse.fromJson(Map<String, dynamic> json) =>
      AddShopResponse(
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
      };
}
