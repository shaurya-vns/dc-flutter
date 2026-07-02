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

class AppConstants {
  static const String API_TYPE = 'request_code';
  static const String no_network = 'No internet connection is found';
}

class FILE_TYPE {
  static const int GALLERY = 1;
  static const int CAMARA = 2;
  static const int IMAGE = 3;
  static const int VIDEO = 4;
}
