///API REQUEST CODES

class BaseUrl {
  static const String prodBaseURL = 'https://1255-182-77-58-183.ngrok-free.app/api/';

  static String BASE_URL = '';
}

class ApiType {
  static const int LOGIN = 100;
  static const int TODAY_ORDER_LIST = 101;
  static const int SUBSCRIPTION_ME = 102;
  static const int PRODUCT_BY_SUB_OWNER = 103;
}

///API Url's End point
class ApiEndPoint {
  static const String LOGIN = 'users/login';
  static const String TODAY_ORDER_LIST = 'order/today-orders';
  static const String SUBSCRIPTION_ME = 'subscription/me';
  static const String PRODUCT_BY_SUB_OWNER = 'product/subowner';
}
