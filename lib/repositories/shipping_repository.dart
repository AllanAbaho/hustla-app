import 'package:hustla/app_config.dart';
import 'package:hustla/data_model/carriers_response.dart';
import 'package:hustla/data_model/delivery_info_response.dart';
import 'package:hustla/helpers/shared_value_helper.dart';
import 'package:http/http.dart' as http;

class ShippingRepository {
  Future<List<DeliveryInfoResponse>> getDeliveryInfo() async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/delivery-info");
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$,
      },
    );
    print("response.body.toString()${response.body.toString()}");

    return deliveryInfoResponseFromJson(response.body);
  }
}
