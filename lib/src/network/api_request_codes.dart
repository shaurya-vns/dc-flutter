///API REQUEST CODES

class BaseUrl {
  /// Production base url
  /// // https://dcxn.design/app/api/home.php
  static const String prodBaseURL = 'https://dcxn.design/app/api/';

  static String BASE_URL = '';
}

class ApiType {
  static const int GALLERY = 100;
  static const int CLIENT = 101;
  static const int ABOUT_US = 102;
  static const int SERVICE_EVENT = 103;
  static const int SERVICE_MARKET = 104;
  static const int SERVICE_CPASS = 105;
  static const int SERVICE_BTLA = 106;
  static const int HOME = 107;
  static const int CONTACT = 108;
  static const int LOGIN = 105;
}

///API Url's End point
class ApiEndPoint {
  static const String GALLERY = 'gallary.php';
  static const String CLIENT = 'clients.php';
  static const String ABOUT_US = 'about.php';
  static const String SERVICE_EVENT = 'service_events.php';
  static const String SERVICE_MARKET = 'service_content.php';
  static const String SERVICE_CPASS = 'service_cpass.php';
  static const String SERVICE_BTLA = 'service_btla.php';
  static const String HOME = 'home.php';
  static const String CONTACT = 'contact.php';
}

class UserStatus {
  static const int EMAIL_ADDED = 1;
  static const int SIGNUP_ADDED = 2;
  static const int OTP_ADDED = 3;
}

class OtpSend {
  static const int MOBILE_OTP = 1;
  static const int EMAIL_OTP = 2;
}

class FieldType {
  static const int All = 1;
  static const int NAME = 2;
}

class OnBoardingType {
  static const int PENDING = 0;
  static const int COMPLETED = 1;
}
