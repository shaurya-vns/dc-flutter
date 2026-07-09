///API REQUEST CODES

class BaseUrl {
  static const String prodBaseURL = 'https://b194-182-77-58-183.ngrok-free.app/api/';

  static String BASE_URL = '';
}

class ApiType {
  static const int LOGIN = 100;
  static const int PRODUCT_LIST = 101;
  static const int SUBSCRIPTION_LIST_BY_USER = 102;
  static const int SUBSCRIPTION_ORDER_LIST = 103;
  static const int ONE_TIME_ORDER_LIST = 104;
  static const int PRODUCT_DETAIL = 105;
  static const int CREATE_SUBSCRIPTION = 106;
  static const int CREATE_ONE_TIME_ORDER = 107;

  static const int ADDRESS_LIST = 108;
  static const int ADDRESS_ADD = 109;
  static const int ADDRESS_UPDATE = 110;

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
  static const int CREATE_ON_DEMAND_ODER = 128;
  static const int ON_DEMAND_LIST = 129;

  static const int ON_DEMAND_USER_APPROVE = 130;
  static const int ON_DEMAND_USER_CANCEL = 131;

  static const int ON_DEMAND_VENDOR_APPROVE = 132;
  static const int ON_DEMAND_VENDOR_REJECT = 133;
  static const int ON_DEMAND_VENDOR_AMOUNT = 134;
  static const int ON_DEMAND_VENDOR_PAYMENT = 135;
  static const int ON_DEMAND_VENDOR_DELIVERED = 136;
}

///API Url's End point
class ApiEndPoint {
  static const String LOGIN = 'users/login';
  static const String PRODUCT_LIST = 'products/list';
  static const String SUBSCRIPTION_LIST_BY_USER = 'subscriptions/list';
  static const String SUBSCRIPTION_ORDER_LIST = 'subscription-orders/list';
  static const String ONE_TIME_ORDER_LIST = 'one-time-orders/list';
  static const String PRODUCT_DETAIL = 'products/detail';
  static const String CREATE_SUBSCRIPTION = 'subscriptions/create';
  static const String CREATE_ONE_TIME_ORDER = 'one-time-orders/create';
  static const String UPDATE_ONETIME_ORDER = 'one-time-orders/update';
  static const String UPDATE_SUB_ORDER = 'orders/update';
  static const String SUBSCRIPTION_APPROVE = 'subscriptions/approve-payment';

  static const String ADDRESS_ADD = 'address/add';
  static const String ADDRESS_LIST = 'address/list';
  static const String ADDRESS_UPDATE = 'address/update';

  static const String GET_PROFILE = 'users/profile';
  static const String SUB_OWNER_LOGIN = 'sub-owners/login';

  static const String ALL_USER_LIST = 'users/all';

  static const String CREATE_ON_DEMAND_ODER = 'ondemand/create';

  static const String ON_DEMAND_LIST = 'ondemand/list';
  static const String ON_DEMAND_USER_APPROVE = 'ondemand/user';
  static const String ON_DEMAND_USER_CANCEL = 'ondemand/user';

  static const String ON_DEMAND_VENDOR_APPROVE = 'ondemand/vendor';
  static const String ON_DEMAND_VENDOR_REJECT = 'ondemand/vendor';
  static const String ON_DEMAND_VENDOR_AMOUNT = 'ondemand/vendor';
  static const String ON_DEMAND_VENDOR_PAYMENT = 'ondemand/vendor';
  static const String ON_DEMAND_VENDOR_DELIVERED = 'ondemand/vendor';
}
