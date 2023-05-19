import 'package:hustla/app_config.dart';
import 'package:hustla/data_model/confirm_booking_response.dart';
import 'package:hustla/data_model/create_booking_response.dart';
import 'package:hustla/data_model/destination_response.dart';
import 'package:hustla/data_model/flights_response.dart';
import 'package:hustla/data_model/make_airline_payment_response.dart';
import 'package:hustla/data_model/ticket_booking_response.dart';
import 'package:http/http.dart' as http;

class AirlineRepository {
  Future<DestinationResponse> getDestinations() async {
    Uri url = Uri.parse("${AppConfig.AIRLINE_API}/getDestinations");
    final response = await http.get(url, headers: {
      "auth_id": AppConfig.auth_id,
      "auth_password": AppConfig.auth_password,
      "Content-Type": AppConfig.content_type,
    });

    return destinationResponseFromJson(response.body);
  }

  Future<CreateBookingResponse> createBooking(postData) async {
    Uri url = Uri.parse("${AppConfig.AIRLINE_API}/createBooking");
    final response = await http.post(url,
        headers: {
          "auth_id": AppConfig.auth_id,
          "auth_password": AppConfig.auth_password,
          "Content-Type": AppConfig.content_type,
        },
        body: postData);

    return createBookingResponseFromJson(response.body);
  }

  Future<TicketBookingResponse> ticketBooking(postData) async {
    Uri url = Uri.parse("${AppConfig.AIRLINE_API}/ticketBooking");
    final response = await http.post(url,
        headers: {
          "auth_id": AppConfig.auth_id,
          "auth_password": AppConfig.auth_password,
          "Content-Type": AppConfig.content_type,
        },
        body: postData);

    return ticketBookingResponseFromJson(response.body);
  }

  Future<ConfirmBookingResponse> confirmBooking(postData) async {
    Uri url = Uri.parse("${AppConfig.AIRLINE_API}/confirmBooking");
    final response = await http.post(url,
        headers: {
          "auth_id": AppConfig.auth_id,
          "auth_password": AppConfig.auth_password,
          "Content-Type": AppConfig.content_type,
        },
        body: postData);

    return confirmBookingResponseFromJson(response.body);
  }

  Future<MakeAirlinePaymentResponse> makeAirlinePayment(postData) async {
    Uri url = Uri.parse("https://secure.aerocrs.com/v4/makePayment");
    final response = await http.post(url,
        headers: {
          "auth_id": AppConfig.auth_id,
          "auth_password": AppConfig.auth_password,
          "Content-Type": AppConfig.content_type,
        },
        body: postData);

    return makeAirlinePaymentResponseFromJson(response.body);
  }

  Future<FlightsResponse> getFlights(
      from, to, start, adults, child, infants, cabinCode, end) async {
    Uri url = Uri.parse(
        "${AppConfig.AIRLINE_API}/getDeepLink?from=$from&to=$to&start=$start&adults=$adults&child=$child&infant=$infants&cabinCode=$cabinCode&end=$end");
    final response = await http.get(url, headers: {
      "auth_id": AppConfig.auth_id,
      "auth_password": AppConfig.auth_password,
      "Content-Type": AppConfig.content_type,
    });

    return flightsResponseFromJson(response.body);
  }
}
