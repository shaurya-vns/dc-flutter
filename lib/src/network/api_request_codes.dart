///API REQUEST CODES

class BaseUrl {
  static const String prodBaseURL = 'https://bbb6-103-170-81-167.ngrok-free.app/api/';

  static String BASE_URL = '';
}

class ApiType {
  static const int LOGIN = 0;
  static const int SIGN_UP = 1;
  static const int ADD_PARTNER = 100;
  static const int GET_PROFILE = 2;
  static const int ALL_USER_LIST = 3;

  static const int PRODUCT_LIST = 4;
  static const int PRODUCT_DETAIL = 5;

  static const int CREATE_SUBSCRIPTION = 6;
  static const int SUBSCRIPTION_LIST_BY_USER = 7;
  static const int SUBSCRIPTION_APPROVE = 8;

  static const int SUBSCRIPTION_ORDER_LIST = 9;
  static const int SUBSCRIPTION_ORDER_USER_CANCEL = 10;
  static const int SUBSCRIPTION_ORDER_VENDOR_REJECT = 11;
  static const int SUBSCRIPTION_ORDER_VENDOR_DELIVERED = 12;

  static const int ONE_TIME_ORDER_LIST = 13;
  static const int CREATE_ONE_TIME_ORDER = 14;
  static const int ONE_TIME_USER_CANCEL = 15;
  static const int ONE_TIME_VENDOR_REJECT = 16;
  static const int ONE_TIME_VENDOR_DELIVERED = 17;

  static const int CREATE_ON_DEMAND_ORDER = 18;
  static const int ON_DEMAND_LIST = 19;
  static const int ON_DEMAND_USER_APPROVE = 20;
  static const int ON_DEMAND_USER_CANCEL = 21;
  static const int ON_DEMAND_VENDOR_APPROVE = 22;
  static const int ON_DEMAND_VENDOR_REJECT = 23;
  static const int ON_DEMAND_VENDOR_AMOUNT = 24;
  static const int ON_DEMAND_VENDOR_PAYMENT = 25;
  static const int ON_DEMAND_VENDOR_DELIVERED = 26;

  static const int ADDRESS_LIST = 27;
  static const int ADDRESS_ADD = 28;
  static const int ADDRESS_UPDATE = 29;
  static const int ADDRESS_DELETE = 30;

  static const int SUB_OWNER_LOGIN = 31;

  static const int REVIEW_LIST = 32;
  static const int REVIEW_CREATE = 33;

  static const int CREATE_ISSUE_TICKET = 34;
  static const int CREATE_CONTACT_US = 35;
  static const int CONTACT_US_LIST = 36;

  static const int DELIVERY_LIST = 37;
  static const int CHAT_STREAM = 38;
}

///API Url's End point
class ApiEndPoint {
  static const String LOGIN = 'users/login';
  static const String SIGN_UP = 'users/register';
  static const String ADD_PARTNER = 'delivery/register';
  static const String GET_PROFILE = 'users/profile';
  static const String ALL_USER_LIST = 'users/all';

  static const String PRODUCT_LIST = 'products/list';
  static const String PRODUCT_DETAIL = 'products/detail';

  static const String CREATE_SUBSCRIPTION = 'subscriptions/create';
  static const String SUBSCRIPTION_LIST_BY_USER = 'subscriptions/list';
  static const String SUBSCRIPTION_APPROVE = 'subscriptions/approve-payment';

  static const String SUBSCRIPTION_ORDER_LIST = 'subscription-orders/list';
  static const String SUBSCRIPTION_ORDER_USER_CANCEL = 'subscription-orders/user';
  static const String SUBSCRIPTION_ORDER_VENDOR_REJECT = 'subscription-orders/vendor';
  static const String SUBSCRIPTION_ORDER_VENDOR_DELIVERED = 'subscription-orders/vendor';

  static const String ONE_TIME_ORDER_LIST = 'one-time-orders/list';
  static const String CREATE_ONE_TIME_ORDER = 'one-time-orders/create';
  static const String ONE_TIME_USER_CANCEL = 'one-time-orders/user';
  static const String ONE_TIME_VENDOR_REJECT = 'one-time-orders/vendor';
  static const String ONE_TIME_VENDOR_DELIVERED = 'one-time-orders/vendor';

  static const String CREATE_ON_DEMAND_ORDER = 'on-demand-orders/create';
  static const String ON_DEMAND_LIST = 'on-demand-orders/list';
  static const String ON_DEMAND_USER_APPROVE = 'on-demand-orders/user';
  static const String ON_DEMAND_USER_CANCEL = 'on-demand-orders/user';
  static const String ON_DEMAND_VENDOR_APPROVE = 'on-demand-orders/vendor';
  static const String ON_DEMAND_VENDOR_REJECT = 'on-demand-orders/vendor';
  static const String ON_DEMAND_VENDOR_AMOUNT = 'on-demand-orders/vendor';
  static const String ON_DEMAND_VENDOR_PAYMENT = 'on-demand-orders/vendor';
  static const String ON_DEMAND_VENDOR_DELIVERED = 'on-demand-orders/vendor';

  static const String ADDRESS_ADD = 'address/add';
  static const String ADDRESS_LIST = 'address/list';
  static const String ADDRESS_UPDATE = 'address/update';
  static const String ADDRESS_DELETE = 'address/delete';

  static const String SUB_OWNER_LOGIN = 'sub-owners/login';

  static const String REVIEW_LIST = 'reviews/list';
  static const String REVIEW_CREATE = 'reviews/create';

  static const String CREATE_ISSUE_TICKET = 'supports/tickets/create';

  static const String CREATE_CONTACT_US = 'contact-us/user/create';
  static const String CONTACT_US_LIST = 'contact-us/user/list';
  static const String DELIVERY_LIST = 'delivery/list';
  static const String CHAT_STREAM = 'ai/chat-stream';
}
