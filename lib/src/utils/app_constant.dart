// ignore_for_file: constant_identifier_names

import 'package:flutter_dc/src/model/response/user/UserData.dart';

double SCREEN_WIDTH = 0;

double SCREEN_HEIGHT = 0;

String? USER_TYPE = '';
String? USER_ROLE = '';

String ACCESS_TOKEN = "";
String DEVICE_TOKEN = "";
UserData? USER_DATA;

String? homeAddress;
String? fullAddress;
int? addressId;

class AppConstants {
  static const String API_TYPE = 'request_code';
  static const String no_network = 'No internet connection is found';
}

class UserType {
  static const int OWNER = 1;
  static const int VENDOR = 2;
  static const int USER = 3;
  static const int DELIVERY = 4;
}

class FILE_TYPE {
  static const int GALLERY = 1;
  static const int CAMARA = 2;
  static const int IMAGE = 3;
  static const int VIDEO = 4;
}

class AI_TYPE {
  static const String PARTIAL_TEXT = 'PARTIAL_TEXT';
  static const String TEXT_BUTTON = 'TEXT_BUTTON';
  static const String PROMPT_BUTTON = 'PROMPT_BUTTON';
  static const String TEXT = 'TEXT';
  static const String IMMEDIATE_ACTION = 'IMMEDIATE_ACTION';
  static const String WIDGET_REVIEW_SUMMARY = 'WIDGET_REVIEW_SUMMARY';
}
