import 'dart:convert';

import 'package:hustla/app_config.dart';
import 'package:hustla/data_model/join_sacco_response.dart';
import 'package:hustla/data_model/sacco_list_response.dart';
import 'package:hustla/helpers/shared_value_helper.dart';
import 'package:http/http.dart' as http;

class SaccoRepository {
  Future<SaccoListResponse> getSaccoList() async {
    Uri url = Uri.parse("${AppConfig.HUSTLER_GATEWAY}/getSaccoList");

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization":
            'Basic ' + base64.encode(utf8.encode('admin:secret123')),
      },
    );
    return saccoListResponseFromJson(response.body);
  }

  Future<JoinSaccoResponse> joinSacco(String saccoName) async {
    Uri url = Uri.parse("${AppConfig.HUSTLER_GATEWAY}/joinSacco");

    var post_body =
        jsonEncode({"username": account_number.$, "saccoName": saccoName});
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization":
              'Basic ' + base64.encode(utf8.encode('admin:secret123')),
        },
        body: post_body);
    return joinSaccoResponseFromJson(response.body);
  }
}
