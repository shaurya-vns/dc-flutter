import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dc/src/ui/auth/WelcomePage.dart';

import '../utils/app_constant.dart';
import '../utils/app_utils.dart';
import 'api_request_codes.dart';
import 'api_response.dart';
import 'dio_network_provider.dart';

class ApiHandler implements ApiResponse {
  BuildContext _context;

  final StreamController _onApiSuccess = StreamController();
  final StreamController _onApiError = StreamController();

  // API Error Stream
  Stream get onApiError => _onApiError.stream;

  // API Success Stream
  Stream get onApiSuccess => _onApiSuccess.stream;

  ApiHandler(this._context);

  /// Closes all the streams
  onDispose() {
    _onApiError.close();
    _onApiSuccess.close();
  }

  void customerLogin(Map map) {
    ApiProvider provider = ApiProvider(this);
    provider.dioPost(_context, ApiEndPoint.LOGIN, ApiType.LOGIN, map);
  }

  void customerCreate(Map map) {
    ApiProvider provider = ApiProvider(this);
    provider.dioPost(_context, ApiEndPoint.SIGN_UP, ApiType.SIGN_UP, map);
  }

  void deliveryCreate(Map map) {
    ApiProvider provider = ApiProvider(this);
    provider.dioPost(_context, ApiEndPoint.ADD_PARTNER, ApiType.ADD_PARTNER, map);
  }

  void subOwnerLogin(Map map) {
    ApiProvider provider = ApiProvider(this);
    provider.dioPost(_context, ApiEndPoint.SUB_OWNER_LOGIN, ApiType.SUB_OWNER_LOGIN, map);
  }

  void getSubscriptionOrderAPI(Map map) {
    ApiProvider provider = ApiProvider(this);
    provider.dioGet(
      _context,
      ApiEndPoint.SUBSCRIPTION_ORDER_LIST,
      ApiType.SUBSCRIPTION_ORDER_LIST,
      map,
    );
  }

  void getSubscriptionAPI(Map map) {
    ApiProvider provider = ApiProvider(this);
    provider.dioGet(
      _context,
      ApiEndPoint.SUBSCRIPTION_LIST_BY_USER,
      ApiType.SUBSCRIPTION_LIST_BY_USER,
      map,
    );
  }

  void getProductListAPI(Map map) {
    ApiProvider provider = ApiProvider(this);
    provider.dioGet(_context, ApiEndPoint.PRODUCT_LIST, ApiType.PRODUCT_LIST, map);
  }

  void getProductDetail(Map map) {
    ApiProvider provider = ApiProvider(this);
    provider.dioGet(_context, ApiEndPoint.PRODUCT_DETAIL, ApiType.PRODUCT_DETAIL, map);
  }

  void createSubscriptionAPI(Map map) {
    ApiProvider provider = ApiProvider(this);
    provider.dioPost(
      _context,
      ApiEndPoint.CREATE_SUBSCRIPTION,
      ApiType.CREATE_SUBSCRIPTION,
      map,
    );
  }

  void createOneTimeOrderAPI(Map map) {
    ApiProvider provider = ApiProvider(this);
    provider.dioPost(
      _context,
      ApiEndPoint.CREATE_ONE_TIME_ORDER,
      ApiType.CREATE_ONE_TIME_ORDER,
      map,
    );
  }

  void getUserAddressListAPI(Map map) {
    ApiProvider provider = ApiProvider(this);
    provider.dioGet(_context, ApiEndPoint.ADDRESS_LIST, ApiType.ADDRESS_LIST, map);
  }

  void getOneTimeOrderListAPI(Map map) {
    ApiProvider provider = ApiProvider(this);
    provider.dioGet(
      _context,
      ApiEndPoint.ONE_TIME_ORDER_LIST,
      ApiType.ONE_TIME_ORDER_LIST,
      map,
    );
  }

  void getUserProfile(Map map) {
    ApiProvider provider = ApiProvider(this);
    provider.dioGet(_context, ApiEndPoint.GET_PROFILE, ApiType.GET_PROFILE, map);
  }

  void addAddressAPI(Map map) {
    ApiProvider provider = ApiProvider(this);
    provider.dioPost(_context, ApiEndPoint.ADDRESS_ADD, ApiType.ADDRESS_ADD, map);
  }

  void updateAddressAPI(int? addressId, Map? data) {
    Map<String, dynamic> map = {};
    map.putIfAbsent('addressId', () => addressId);
    ApiProvider provider = ApiProvider(this);
    provider.dioPutBody(
      _context,
      ApiEndPoint.ADDRESS_UPDATE,
      ApiType.ADDRESS_UPDATE,
      data,
      map,
    );
  }

  void deleteAddressAPI(int? addressId) {
    Map<String, dynamic> map = {};
    map.putIfAbsent('addressId', () => addressId);
    ApiProvider provider = ApiProvider(this);
    provider.dioDelete(_context, ApiEndPoint.ADDRESS_DELETE, ApiType.ADDRESS_DELETE, map);
  }

  void subscriptionApproveAPI(Map map) {
    ApiProvider provider = ApiProvider(this);
    provider.dioGet(
      _context,
      ApiEndPoint.SUBSCRIPTION_APPROVE,
      ApiType.SUBSCRIPTION_APPROVE,
      map,
    );
  }

  void getAllUserList(Map map) {
    ApiProvider provider = ApiProvider(this);
    provider.dioGet(_context, ApiEndPoint.ALL_USER_LIST, ApiType.ALL_USER_LIST, map);
  }

  void createOnDemandOrderAPI(Map map) {
    ApiProvider provider = ApiProvider(this);
    provider.dioPost(
      _context,
      ApiEndPoint.CREATE_ON_DEMAND_ORDER,
      ApiType.CREATE_ON_DEMAND_ORDER,
      map,
    );
  }

  void getOnDemandListAPI(Map map) {
    ApiProvider provider = ApiProvider(this);
    provider.dioGet(_context, ApiEndPoint.ON_DEMAND_LIST, ApiType.ON_DEMAND_LIST, map);
  }

  void userApproveOnDemandAPI(int? orderId) {
    Map<String, dynamic> map = {};
    map.putIfAbsent('orderId', () => orderId);
    ApiProvider provider = ApiProvider(this);
    provider.dioPut(
      _context,
      '${ApiEndPoint.ON_DEMAND_USER_APPROVE}/$orderId/approve',
      ApiType.ON_DEMAND_USER_APPROVE,
      map,
    );
  }

  void userCancelOnDemandAPI(int? orderId, data) {
    ApiProvider provider = ApiProvider(this);
    provider.dioPutBody(
      _context,
      '${ApiEndPoint.ON_DEMAND_USER_CANCEL}/$orderId/cancel',
      ApiType.ON_DEMAND_USER_CANCEL,
      data,
      data,
    );
  }

  void vendorApproveOnDemandAPI(int? orderId) {
    Map<String, dynamic> map = {};
    map.putIfAbsent('orderId', () => orderId);
    ApiProvider provider = ApiProvider(this);
    provider.dioPut(
      _context,
      '${ApiEndPoint.ON_DEMAND_VENDOR_APPROVE}/$orderId/approve',
      ApiType.ON_DEMAND_VENDOR_APPROVE,
      map,
    );
  }

  void vendorRejectOnDemandAPI(int? orderId, data) {
    ApiProvider provider = ApiProvider(this);
    provider.dioPutBody(
      _context,
      '${ApiEndPoint.ON_DEMAND_VENDOR_REJECT}/$orderId/reject',
      ApiType.ON_DEMAND_VENDOR_REJECT,
      data,
      data,
    );
  }

  void vendorAmountOnDemandAPI(int? orderId, data) {
    ApiProvider provider = ApiProvider(this);
    provider.dioPutBody(
      _context,
      '${ApiEndPoint.ON_DEMAND_VENDOR_AMOUNT}/$orderId/amount',
      ApiType.ON_DEMAND_VENDOR_AMOUNT,
      data,
      data,
    );
  }

  void vendorPaymentOnDemandAPI(int? orderId) {
    Map<String, dynamic> map = {};
    ApiProvider provider = ApiProvider(this);
    provider.dioPut(
      _context,
      '${ApiEndPoint.ON_DEMAND_VENDOR_PAYMENT}/$orderId/payment',
      ApiType.ON_DEMAND_VENDOR_PAYMENT,
      map,
    );
  }

  void vendorDeliveryOnDemandAPI(int? orderId) {
    Map<String, dynamic> map = {};
    ApiProvider provider = ApiProvider(this);
    provider.dioPut(
      _context,
      '${ApiEndPoint.ON_DEMAND_VENDOR_DELIVERED}/$orderId/delivery',
      ApiType.ON_DEMAND_VENDOR_DELIVERED,
      map,
    );
  }

  void oneTimeUserOrderCancelAPI(int? orderId, data) {
    ApiProvider provider = ApiProvider(this);
    provider.dioPutBody(
      _context,
      '${ApiEndPoint.ONE_TIME_USER_CANCEL}/$orderId/cancel',
      ApiType.ONE_TIME_USER_CANCEL,
      data,
      data,
    );
  }

  void oneTimeVendorRejectAPI(int? orderId, data) {
    ApiProvider provider = ApiProvider(this);
    provider.dioPutBody(
      _context,
      '${ApiEndPoint.ONE_TIME_VENDOR_REJECT}/$orderId/reject',
      ApiType.ONE_TIME_VENDOR_REJECT,
      data,
      data,
    );
  }

  void oneTimeVendorDeliveryAPI(int? orderId) {
    Map<String, dynamic> map = {};
    ApiProvider provider = ApiProvider(this);
    provider.dioPut(
      _context,
      '${ApiEndPoint.ONE_TIME_VENDOR_DELIVERED}/$orderId/delivery',
      ApiType.ONE_TIME_VENDOR_DELIVERED,
      map,
    );
  }

  void subscriptionOrderUserCancelAPI(int? orderId, data) {
    ApiProvider provider = ApiProvider(this);
    provider.dioPutBody(
      _context,
      '${ApiEndPoint.SUBSCRIPTION_ORDER_USER_CANCEL}/$orderId/cancel',
      ApiType.SUBSCRIPTION_ORDER_USER_CANCEL,
      data,
      data,
    );
  }

  void subscriptionOrderVendorRejectAPI(int? orderId, data) {
    ApiProvider provider = ApiProvider(this);
    provider.dioPutBody(
      _context,
      '${ApiEndPoint.SUBSCRIPTION_ORDER_VENDOR_REJECT}/$orderId/reject',
      ApiType.SUBSCRIPTION_ORDER_VENDOR_REJECT,
      data,
      data,
    );
  }

  void subscriptionOrderVendorDeliveryAPI(int? orderId) {
    Map<String, dynamic> map = {};
    ApiProvider provider = ApiProvider(this);
    provider.dioPut(
      _context,
      '${ApiEndPoint.SUBSCRIPTION_ORDER_VENDOR_DELIVERED}/$orderId/delivery',
      ApiType.SUBSCRIPTION_ORDER_VENDOR_DELIVERED,
      map,
    );
  }

  void getProductReviewListAPI(int? productId) {
    Map<String, dynamic> map = {};
    map.putIfAbsent('productId', () => productId);
    ApiProvider provider = ApiProvider(this);
    provider.dioGet(_context, ApiEndPoint.REVIEW_LIST, ApiType.REVIEW_LIST, map);
  }

  void createReviewProductAPI(Map map) {
    ApiProvider provider = ApiProvider(this);
    provider.dioPost(_context, ApiEndPoint.REVIEW_CREATE, ApiType.REVIEW_CREATE, map);
  }

  void createRaiseIssueAPI(Map map) {
    ApiProvider provider = ApiProvider(this);
    provider.dioPost(
      _context,
      ApiEndPoint.CREATE_ISSUE_TICKET,
      ApiType.CREATE_ISSUE_TICKET,
      map,
    );
  }

  void createContactUsAPI(Map map) {
    ApiProvider provider = ApiProvider(this);
    provider.dioPost(
      _context,
      ApiEndPoint.CREATE_CONTACT_US,
      ApiType.CREATE_CONTACT_US,
      map,
    );
  }

  void getContactUsList() {
    Map<String, dynamic> map = {};
    ApiProvider provider = ApiProvider(this);
    provider.dioGet(_context, ApiEndPoint.CONTACT_US_LIST, ApiType.CONTACT_US_LIST, map);
  }

  void getDeliveryListAPI() {
    Map<String, dynamic> map = {};
    ApiProvider provider = ApiProvider(this);
    provider.dioGet(_context, ApiEndPoint.DELIVERY_LIST, ApiType.DELIVERY_LIST, map);
  }

  void chatStreamAPI(Map map) {
    ApiProvider provider = ApiProvider(this);
    provider.dioPost(_context, ApiEndPoint.CHAT_STREAM, ApiType.CHAT_STREAM, map);
  }

  /// On API error
  @override
  void onError(e) {
    try {
      _onApiError.sink.add(e);
    } catch (e) {
      _onApiError.sink.close();
    }
    print('onError $e');
  }

  // Root API
  /// On API success
  @override
  void onResponse(Response response, int apiType) {
    Map<String, dynamic> map = response.data;
    print('apiType $apiType');
    print('map $map');
    print('response statusCode : ${response.statusCode}');
    if (map.containsKey('statusCode')) {
      int statusCode = map['statusCode'];
      if (statusCode == 1) {
        Map<String, dynamic> data = {};
        if (map.containsKey('responseData')) {
          data = map['responseData'];
          data.putIfAbsent(AppConstants.API_TYPE, () => apiType);
          if (!_onApiSuccess.isClosed) {
            print('data $data');
            _onApiSuccess.sink.add(data);
          }
        } else {
          checkError(_context, map, apiType);
        }
      } else {
        checkError(_context, map, apiType);
      }
    }
  }

  void checkError(context, Map<String, dynamic> map, int apiType) {
    print('SSSSSS apiType $apiType ');
    try {
      if (map.containsKey('error')) {
        Map<String, dynamic> error = map['error'];
        if (error.containsKey('code')) {
          var code = error['code'];
          if (code == 34) {
            AppUtils.launchScreenRemoveAll(context, WelcomePage());
          } else {
            var code = error['code'];
            var message = error['message'];
            callFinalError(apiType, code, message);
          }
        } else {
          // callFinalError(apiType, 1, defaultErrorMessage);
        }
        error.putIfAbsent(AppConstants.API_TYPE, () => apiType);
        if (!_onApiError.isClosed) {
          _onApiError.sink.add(error);
        }
      } else {
        // callFinalError(apiType, 1, 'Something went wrong');
      }
    } catch (ee) {
      // callFinalError(apiType, 1, defaultErrorMessage);
    }
  }

  void callFinalError(int apiType, int code, String message) {
    if (!_onApiError.isClosed) {
      Map<String, dynamic> error = {};
      error.putIfAbsent(AppConstants.API_TYPE, () => apiType);
      error['code'] = code;
      error['message'] = message;
      _onApiError.sink.add(error);
    }
  }
}
