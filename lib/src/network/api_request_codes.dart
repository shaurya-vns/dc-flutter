///API REQUEST CODES

class BaseUrl {
  static const String prodBaseURL = 'https://7e4e-182-77-58-183.ngrok-free.app/api/';

  static String BASE_URL = '';
}

class ApiType {
  static const int LOGIN = 100;
  static const int SUB_TODAY_ORDER_LIST = 101;
  static const int SUBSCRIPTION_ME = 102;
  static const int PRODUCT_BY_SUB_OWNER = 103;
  static const int SUB_NEXT_DAY_ORDER = 104;
  static const int CREATE_SUBSCRIPTION = 105;
  static const int PRODUCT_LIST = 106;
  static const int PRODUCT_DETAIL = 107;
  static const int CREATE_ONE_TIME_ORDER = 108;
  static const int USER_ADDRESS_LIST = 109;
  static const int GET_ONE_TIME_TODAY_ORDER_LIST = 110;
}

///API Url's End point
class ApiEndPoint {
  static const String LOGIN = 'users/login';
  static const String SUB_TODAY_ORDER_LIST = 'order/today-orders';
  static const String SUBSCRIPTION_ME = 'subscription/me';
  static const String PRODUCT_BY_SUB_OWNER = 'product/subowner';
  static const String SUB_NEXT_DAY_ORDER = 'order/next-day-order';
  static const String CREATE_SUBSCRIPTION = 'subscription/create';
  static const String PRODUCT_LIST = 'product/list';
  static const String PRODUCT_DETAIL = 'product/product_detail';
  static const String CREATE_ONE_TIME_ORDER = 'one-time-order/create';
  static const String USER_ADDRESS_LIST = 'users/address_list';
  static const String GET_ONE_TIME_TODAY_ORDER_LIST = 'one-time-order/today_orders';
}
