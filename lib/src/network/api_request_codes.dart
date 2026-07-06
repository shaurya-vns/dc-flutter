///API REQUEST CODES

class BaseUrl {
  static const String prodBaseURL = 'https://b194-182-77-58-183.ngrok-free.app/api/';

  static String BASE_URL = '';
}

class ApiType {
  static const int LOGIN = 100;
  static const int PRODUCT_LIST = 101;
  static const int SUBSCRIPTION_ME = 102;
  static const int SUBSCRIPTION_ORDER_LIST = 103;
  static const int ONE_TIME_ORDER_LIST = 104;

  static const int PRODUCT_BY_SUB_OWNER = 103;
  static const int SUB_NEXT_DAY_ORDER = 104;
  static const int CREATE_SUBSCRIPTION = 105;

  static const int PRODUCT_DETAIL = 107;
  static const int CREATE_ONE_TIME_ORDER = 108;
  static const int USER_ADDRESS_LIST = 109;

  static const int ADDRESS_LIST = 113;
  static const int ADDRESS_ADD = 114;
  static const int ADDRESS_UPDATE = 115;
  static const int GET_PROFILE = 116;
  static const int SUB_OWNER_LOGIN = 117;
  static const int SUB_OWNER_TODAY_ALL_ORDER = 118;
  static const int SUB_OWNER_ONE_TIME_ALL_ORDER = 119;
  static const int UPDATE_SUB_ORDER = 120;
  static const int UPDATE_ONETIME_ORDER = 121;
  static const int ALL_ONE_TIME_ORDER_LIST = 122;
  static const int ALL_SUB_ORDER_LIST = 123;
  static const int ALL_SUBSCRIPTION_LIST = 124;
  static const int SUBSCRIPTION_APPROVE = 125;
  static const int ALL_USER_LIST = 126;
  static const int GET_USER_TODAY_ORDERS = 127;
}

///API Url's End point
class ApiEndPoint {
  static const String LOGIN = 'users/login';
  static const String PRODUCT_LIST = 'products/list';
  static const String SUBSCRIPTION_ME = 'subscriptions/me';
  static const String SUBSCRIPTION_ORDER_LIST = 'subscription-orders/list';
  static const String ONE_TIME_ORDER_LIST = 'one-time-orders/list';

  static const String PRODUCT_BY_SUB_OWNER = 'product/subowner';
  static const String SUB_NEXT_DAY_ORDER = 'order/next-day-order';
  static const String CREATE_SUBSCRIPTION = 'subscription/create';

  static const String PRODUCT_DETAIL = 'product/product_detail';
  static const String CREATE_ONE_TIME_ORDER = 'one-time-order/create';
  static const String USER_ADDRESS_LIST = 'users/address_list';

  static const String ADDRESS_LIST = 'users/address_list';
  static const String ADDRESS_ADD = 'users/address_add';
  static const String ADDRESS_UPDATE = 'users/address_update';
  static const String GET_PROFILE = 'users/profile';
  static const String SUB_OWNER_LOGIN = 'subowner/login';
  static const String SUB_OWNER_TODAY_ALL_ORDER = 'subowner/sub_today_order';
  static const String SUB_OWNER_ONE_TIME_ALL_ORDER = 'subowner/onetime_today_order';
  static const String UPDATE_SUB_ORDER = 'subowner/update_sub_order_status';
  static const String UPDATE_ONETIME_ORDER = 'subowner/update_onetime_order_status';

  static const String ALL_ONE_TIME_ORDER_LIST = 'subowner/all_one_time_order_list';
  static const String ALL_SUB_ORDER_LIST = 'subowner/all_subscription_orders';
  static const String ALL_SUBSCRIPTION_LIST = 'subowner/all_subscriptions';
  static const String SUBSCRIPTION_APPROVE = 'subscription/approve-payment';
  static const String ALL_USER_LIST = 'subowner/get_all_profile';
  static const String GET_USER_TODAY_ORDERS = 'subowner/user_one_time_order_list';
}
