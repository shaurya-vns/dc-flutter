import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dc/src/ui/auth/login/login_page.dart';

import '../../splash.dart';
import '../utils/app_constant.dart';
import '../utils/app_utils.dart';
import '../utils/preference_util.dart';
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

  void loginAPI(Map map) {
    ApiProvider provider = ApiProvider(this);
    provider.dioPost(_context, ApiEndPoint.LOGIN, ApiType.LOGIN, map);
  }

  void getMyTodayOrderAPI(Map map) {
    ApiProvider provider = ApiProvider(this);
    provider.dioGet(
      _context,
      ApiEndPoint.TODAY_ORDER_LIST,
      ApiType.TODAY_ORDER_LIST,
      map,
    );
  }

  void getMySubscriptionAPI(Map map) {
    ApiProvider provider = ApiProvider(this);
    provider.dioGet(_context, ApiEndPoint.SUBSCRIPTION_ME, ApiType.SUBSCRIPTION_ME, map);
  }

  void getProductBySubOwnerIdAPI(Map map) {
    ApiProvider provider = ApiProvider(this);
    provider.dioGet(
      _context,
      ApiEndPoint.PRODUCT_BY_SUB_OWNER,
      ApiType.PRODUCT_BY_SUB_OWNER,
      map,
    );
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
    print('SSSSSS apiType $apiType map $map');
    try {
      if (map.containsKey('error')) {
        Map<String, dynamic> error = map['error'];
        if (error.containsKey('code')) {
          var code = error['code'];
          if (code == 34) {
            AppUtils.launchScreenRemoveAll(context, LoginPage());
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
