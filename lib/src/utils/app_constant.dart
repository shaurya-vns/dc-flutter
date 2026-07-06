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

class UserType {
  static const int OWNER = 1;
  static const int SUB_OWNER = 2;
  static const int USER = 3;
  static const int DELIVERY = 4;
}

class OrderStatus {
  static const int PENDING = 1;
  static const int PREPARING = 2;
  static const int DELIVERED = 3;
  static const int CANCELLED = 4;
}

class PaymentStatus {
  static const int PAYMENT_PENDING = 1;
  static const int PAYMENT_RECEIVED = 2;
  static const int PAYMENT_FAILED = 3;
  static const int PAYMENT_REFUNDED = 4;
}

class FILE_TYPE {
  static const int GALLERY = 1;
  static const int CAMARA = 2;
  static const int IMAGE = 3;
  static const int VIDEO = 4;
}
