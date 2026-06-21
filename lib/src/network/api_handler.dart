import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

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

  void homeAPI() {
    Map map = <String, dynamic>{};
    ApiProvider provider = ApiProvider(this);
    provider.dioGet(_context, ApiEndPoint.HOME, ApiType.HOME, map);
  }

  void serviceEventAPI() {
    Map map = <String, dynamic>{};
    ApiProvider provider = ApiProvider(this);
    provider.dioGet(_context, ApiEndPoint.SERVICE_EVENT, ApiType.SERVICE_EVENT, map);
  }

  void clientsAPI() {
    Map map = <String, dynamic>{};
    ApiProvider provider = ApiProvider(this);
    provider.dioGet(_context, ApiEndPoint.CLIENT, ApiType.CLIENT, map);
  }

  /// On API error
  @override
  void onError(e) {
    try {
      _onApiError.sink.add(e);
    } catch (e) {
      _onApiError.sink.close();
    }
  }

  // Root API
  /// On API success
  @override
  void onResponse(Response response, int apiType) {
    Map<String, dynamic> map = response.data;
    if (response.statusCode == 200) {
      map.putIfAbsent(AppConstants.API_TYPE, () => apiType);
      if (!_onApiSuccess.isClosed) {
        _onApiSuccess.sink.add(map);
      }
    } else {
      checkError(map, apiType);
    }
  }

  void checkError(Map<String, dynamic> map, int apiType) {
    try {
      Map<String, dynamic> error = {};
      if (map.containsKey('error')) {
        error = map['error'];

        if (error.containsKey('code')) {
          var code = error['code'];
          if (code == 34) {
            var message = error['message'];
            AppUtils.showToast(message);
            PreferenceUtil.setLogin(false);
            AppUtils.launchScreenRemoveAll(_context, SplashScreen());
          }
        } else {
          error['code'] = 1;
          error['message'] = error.toString();
        }
        error.putIfAbsent(AppConstants.API_TYPE, () => apiType);
        if (!_onApiError.isClosed) {
          _onApiError.sink.add(error);
        }
      } else if (!_onApiError.isClosed) {
        _onApiError.sink.add(error);
      }
    } catch (ee) {
      cc(apiType);
    }
  }

  void cc(int apiType) {
    if (!_onApiError.isClosed) {
      Map<String, dynamic> error = {};
      error.putIfAbsent(AppConstants.API_TYPE, () => apiType);
      error['code'] = 1;
      error['message'] = 'Something went wrong. Please try again.';
      _onApiError.sink.add(error);
    }
  }
}
