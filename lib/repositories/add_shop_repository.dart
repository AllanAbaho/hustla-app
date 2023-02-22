import 'dart:convert';

import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/data_model/add_shop_response.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddShopRepository {
  Future<AddShopResponse> getAddShopResponse(
    @required String name,
    @required String email,
    @required String address,
    @required String password,
  ) async {
    var postBody = jsonEncode({
      "name": "$name",
      "email": "$email",
      "address": "$address",
      "password": "$password",
    });

    Uri url = Uri.parse("${AppConfig.BASE_URL}/add-shop");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "App-Language": app_language.$,
        },
        body: postBody);

    return addShopResponseFromJson(response.body);
  }
}
