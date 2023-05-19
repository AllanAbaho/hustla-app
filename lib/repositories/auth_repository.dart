import 'package:hustla/app_config.dart';
import 'package:hustla/data_model/authorize_otp_response.dart';
import 'package:http/http.dart' as http;
import 'package:hustla/data_model/login_response.dart';
import 'package:hustla/data_model/logout_response.dart';
import 'package:hustla/data_model/signup_response.dart';
import 'package:hustla/data_model/resend_code_response.dart';
import 'package:hustla/data_model/confirm_code_response.dart';
import 'package:hustla/data_model/password_forget_response.dart';
import 'package:hustla/data_model/password_confirm_response.dart';
import 'package:hustla/data_model/user_by_token.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:hustla/helpers/shared_value_helper.dart';

class AuthRepository {
  Future<LoginResponse> getLoginResponse(
      @required String email, @required String password) async {
    var postBody = jsonEncode({
      "user_name": "${email}",
      "password": "$password",
      "identity_matrix": AppConfig.purchase_code
    });

    Uri url = Uri.parse("${AppConfig.BASE_URL}/auth/login");
    final response = await http.post(url,
        headers: {
          "Accept": "*/*",
          "Content-Type": "application/json",
          "App-Language": app_language.$,
        },
        body: postBody);

    return loginResponseFromJson(response.body);
  }

  Future<LoginResponse> getSocialLoginResponse(@required String socialProvider,
      @required String name, @required String email, @required String provider,
      {access_token = ""}) async {
    email = email == ("null") ? "" : email;

    var postBody = jsonEncode({
      "name": "${name}",
      "email": email,
      "provider": "$provider",
      "social_provider": "$socialProvider",
      "access_token": "$access_token"
    });

    Uri url = Uri.parse("${AppConfig.BASE_URL}/auth/social-login");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "App-Language": app_language.$,
        },
        body: postBody);
    print(postBody);
    print(response.body.toString());
    return loginResponseFromJson(response.body);
  }

  Future<LogoutResponse> getLogoutResponse() async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/auth/logout");
    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$,
      },
    );

    print(response.body);

    return logoutResponseFromJson(response.body);
  }

  Future<SignupResponse> getSignupResponse(
      @required String uname,
      @required String fname,
      @required String lname,
      // @required String dob,
      // @required String gender,
      @required String nin,
      @required String phone,
      @required String idFront,
      @required String idBack,
      @required String email,
      @required String password) async {
    var postBody = jsonEncode({
      "user_name": "$uname",
      "first_name": "$fname",
      "second_name": "$lname",
      "id_number": "$nin",
      "phone_number": "$phone",
      "email": "$email",
      "pin": "$password",
      "appVersion": "1.0.0+1",
      "osType": 'ANDROID',
      "country": "Kenya",
      "verified": "NONE",
      "currency": "KES",
      "country_code": "254",
      "device_id": "NONE",
      "id_type": "National ID",
      "referral_code": "NONE",
      "id_img": "NONE",
      "id_img_back": idBack,
      "profile_img": idFront
    });

    Uri url = Uri.parse("${AppConfig.BASE_URL}/auth/signup");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "App-Language": app_language.$,
        },
        body: postBody);

    return signupResponseFromJson(response.body);
  }

  Future<ResendCodeResponse> getResendCodeResponse(
      @required int userId, @required String verifyBy) async {
    var postBody =
        jsonEncode({"user_id": "$userId", "register_by": "$verifyBy"});

    Uri url = Uri.parse("${AppConfig.BASE_URL}/auth/resend_code");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "App-Language": app_language.$,
        },
        body: postBody);

    return resendCodeResponseFromJson(response.body);
  }

  Future<ConfirmCodeResponse> getConfirmCodeResponse(
      @required int userId, @required String verificationCode) async {
    var postBody = jsonEncode(
        {"user_id": "$userId", "verification_code": "$verificationCode"});

    Uri url = Uri.parse("${AppConfig.BASE_URL}/auth/confirm_code");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "App-Language": app_language.$,
        },
        body: postBody);

    return confirmCodeResponseFromJson(response.body);
  }

  Future<AuthorizeOtpResponse> authorizeOTPResponse(
    String verificationCode,
    String phone,
  ) async {
    var postBody =
        jsonEncode({"message": verificationCode, "phoneNumber": phone});

    Uri url = Uri.parse("${AppConfig.HUSTLER_GATEWAY}/sendAppSms");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization":
              'Basic ' + base64.encode(utf8.encode('admin:secret123')),
        },
        body: postBody);
    return authorizeOtpResponseFromJson(response.body);
  }

  Future<PasswordForgetResponse> getPasswordForgetResponse(
      @required String emailOrPhone, @required String sendCodeBy) async {
    var postBody = jsonEncode(
        {"email_or_phone": "$emailOrPhone", "send_code_by": "$sendCodeBy"});

    Uri url = Uri.parse(
      "${AppConfig.BASE_URL}/auth/password/forget_request",
    );

    print(url.toString());
    print(postBody.toString());

    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "App-Language": app_language.$,
        },
        body: postBody);

    //print(response.body.toString());

    return passwordForgetResponseFromJson(response.body);
  }

  Future<PasswordConfirmResponse> getPasswordConfirmResponse(
      @required String verificationCode, @required String password) async {
    var postBody = jsonEncode(
        {"verification_code": "$verificationCode", "password": "$password"});

    Uri url = Uri.parse(
      "${AppConfig.BASE_URL}/auth/password/confirm_reset",
    );
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "App-Language": app_language.$,
        },
        body: postBody);

    return passwordConfirmResponseFromJson(response.body);
  }

  Future<ResendCodeResponse> getPasswordResendCodeResponse(
      @required String emailOrCode, @required String verifyBy) async {
    var postBody =
        jsonEncode({"email_or_code": "$emailOrCode", "verify_by": "$verifyBy"});

    Uri url = Uri.parse("${AppConfig.BASE_URL}/auth/password/resend_code");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "App-Language": app_language.$,
        },
        body: postBody);

    return resendCodeResponseFromJson(response.body);
  }

  Future<UserByTokenResponse> getUserByTokenResponse() async {
    var postBody = jsonEncode({"access_token": "${access_token.$}"});
    Uri url = Uri.parse("${AppConfig.BASE_URL}/get-user-by-access_token");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "App-Language": app_language.$,
        },
        body: postBody);

    return userByTokenResponseFromJson(response.body);
  }
}
