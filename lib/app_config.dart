import 'dart:convert';

import 'package:flutter/material.dart';

var this_year = DateTime.now().year.toString();

class AppConfig {
  static String copyright_text = "Financial services without limitations";
  static String app_name = "Hustla"; //this shows in the splash screen
  static String purchase_code =
      "6f56de4a-0426-45e0-bf02-d0bb7caabeb3"; //enter your purchase code for the app from codecanyon

  //Default language config
  static String default_language = "en";
  static String mobile_app_code = "en";
  static bool app_language_rtl = false;

  //configure this
  static const bool HTTPS = false;

  //configure this

  // static const DOMAIN_PATH = "192.168.1.6:8000"; //localhost
  static const DOMAIN_PATH = "hustlermarkets.com";

  //do not configure these below
  static const String API_ENDPATH = "api/v2";
  static const String PROTOCOL = HTTPS ? "https://" : "http://";
  static const String RAW_BASE_URL = "${PROTOCOL}${DOMAIN_PATH}";
  static const String BASE_URL = "${RAW_BASE_URL}/${API_ENDPATH}";
  static const String HUSTLER_GATEWAY =
      'http://3.28.82.227:9010/api/huslazgateway';
  static const String AIRLINE_API = 'https://api.aerocrs.com/v5';
  static const String auth_id = 'CCF22C4E-DFF6-4961-949C-EE7C7E3291B3';
  static const String auth_password = 'rsQZ4LLdk0';
  static const String content_type = 'application/json';
}
