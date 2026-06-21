import 'dart:convert';

import 'package:dio/dio.dart';

import '../utils/app_constant.dart';
import '../utils/log.dart';
import 'api_request_codes.dart';
import 'api_response.dart';

class ApiProvider {
  late Dio _dio;

  late ApiResponse _apiCallback;

  ApiProvider(ApiResponse apiCallback) {
    _apiCallback = apiCallback;
    Map<String, dynamic> map = Map();
    map.putIfAbsent('Authorization', () => 'Basic cG9zdGFsLXByb3M6cG9zdGFsLXByb3M=');
    map.putIfAbsent('accept', () => 'application/json');

    print('TOKEN IN NETWORK = $ACCESS_TOKEN');

    if (ACCESS_TOKEN != null && ACCESS_TOKEN.isNotEmpty) {
      map.putIfAbsent('access-token', () => ACCESS_TOKEN);
    }

    print('TOKEN IN NETWORK = ${BaseUrl.BASE_URL}');
    BaseOptions options = BaseOptions(
      receiveTimeout: 50000,
      sendTimeout: 50000,
      connectTimeout: 50000,
    );
    // options.contentType = Headers.jsonContentType;
    options.headers = map;
    options.baseUrl = BaseUrl.BASE_URL;
    options.contentType = Headers.formUrlEncodedContentType;
    _dio = Dio();
    _dio.options = options;
  }

  String accessTokenData = '';

  /// Call this method to make GET API requests
  dioGet(context, String url, int apiType, Map<dynamic, dynamic>? request) async {
    print('final method ======> GET');
    print('final url ======> $url');
    print('final req ======> $request');

    try {
      Response? response = await apiGetRequest(url, request);
      print('final res ======> $response');
      if (response != null) {
        _apiCallback.onResponse(response, apiType);
      } else {
        _handleError(apiType, null);
      }
    } catch (error) {
      print('final error ======> $error');
      var d = _handleError(apiType, error);
      return d;
    }
  }

  dioPostBody(context, String url, int apiType, Object? request) async {
    print('final method ======> POST Body');
    print('final url ======> $url');
    print('final req ======> ${request.toString()}');
    try {
      Response? response = await apiPostRequest(url, request, null);
      print('final res ======> $response');
      if (response != null) {
        _apiCallback.onResponse(response, apiType);
      } else {
        _handleError(apiType, null);
      }
    } catch (error) {
      var d = _handleError(apiType, error);
      return d;
    }
  }

  /// Call this method to make POST API requests
  dioPost(context, String url, int apiType, data) async {
    Log.i('final method ======> POST');
    Log.i('final url ======> $url');

    try {
      Response? response = await apiPostRequest(url, data, null);
      Log.i('final res ======> $response');

      if (response != null) {
        _apiCallback.onResponse(response, apiType);
      } else {
        _handleError(apiType, null);
      }
    } catch (error) {
      var d = _handleError(apiType, error);
      return d;
    }
  }

  apiPostBody(
    context,
    String url,
    int apiType,
    data,
    Map<dynamic, dynamic>? request,
  ) async {
    Log.i('final method ======> POST');
    Log.i('final url ======> $url');
    Log.i('final req ======> $request');
    try {
      Response? response = await apiPostBodyRequest(url, data, request, null);
      Log.i('final res ======> $response');

      if (response != null) {
        _apiCallback.onResponse(response, apiType);
      } else {
        _handleError(apiType, null);
      }
    } catch (error) {
      var d = _handleError(apiType, error);
      return d;
    }
  }

  /// Call this method to make POST API requests
  dioPut(context, String url, int apiType, Map<String, dynamic> request) async {
    try {
      Response? response = await apiPutRequest(url, request);
      print('final url ======> $url');
      print('final req ======> $request');
      print('final res ======> $response');
      if (response != null) {
        _apiCallback.onResponse(response, apiType);
      } else {
        _handleError(apiType, null);
      }
    } catch (error) {
      var d = _handleError(apiType, error);
      return d;
    }
  }

  /// Call this method to make POST API requests
  dioPatch(context, String url, int apiType, Map<dynamic, dynamic> request) async {
    try {
      Response? response = await apiPatchRequest(url, request);
      print('final url ======> $url');
      print('final req ======> $request');
      print('final res ======> $response');
      if (response != null) {
        _apiCallback.onResponse(response, apiType);
      } else {
        _handleError(apiType, null);
      }
    } catch (error) {
      var d = _handleError(apiType, error);
      return d;
    }
  }

  dioPutBody(
    context,
    String url,
    int apiType,
    data,
    Map<String, dynamic>? request,
  ) async {
    try {
      print('final Method dioPut ======>');
      print('final url ======> $url');
      print('final request ======> ${request}');

      Response? response = await apiPutBodyRequest(url, data, request);
      if (response != null) {
        _apiCallback.onResponse(response, apiType);
      } else {
        _handleError(apiType, null);
      }
    } catch (error) {
      var d = _handleError(apiType, error);
      return d;
    }
  }

  apiPatchBody(
    context,
    String url,
    int apiType,
    data,
    Map<String, dynamic> request,
  ) async {
    try {
      print('final url ======> $url');
      print('final req ======> $request');
      print('final data ======> ${data.toString()}');

      Response? response = await apiPatchBodyRequest(url, data, request);
      if (response != null) {
        _apiCallback.onResponse(response, apiType);
      } else {
        _handleError(apiType, null);
      }
    } catch (error) {
      var d = _handleError(apiType, error);
      return d;
    }
  }

  /// Call this method to make POST API requests
  dioDelete(context, String url, int apiType, Map<String, dynamic> request) async {
    try {
      print('final url ======> $url');
      print('final req ======> $request');
      Response? response = await apiDeleteRequest(url, request);
      print('final res ======> $response');

      if (response != null) {
        _apiCallback.onResponse(response, apiType);
      } else {
        _handleError(apiType, null);
      }
    } catch (error) {
      var d = _handleError(apiType, error);
      return d;
    }
  }

  dioPostMultipart(context, String url, int apiType, FormData formData) async {
    print('final url ======> $url');
    print('final apiType ======> $apiType');

    try {
      Response? response = await apiPostMultipart(url, formData);
      print('final res ======> $response');

      if (response != null) {
        _apiCallback.onResponse(response, apiType);
      } else {
        _handleError(apiType, null);
      }
    } catch (error) {
      var d = _handleError(apiType, error);
      return d;
    }
  }

  dioPutMultipart(
    context,
    String url,
    int apiType,
    FormData formData,
    Map<String, dynamic> request,
  ) async {
    print('final url ======> $url');
    print('final apiType ======> $apiType');

    try {
      Response? response = await apiPutMultipart(url, formData, request);
      print('final res ======> $response');

      if (response != null) {
        _apiCallback.onResponse(response, apiType);
      } else {
        _handleError(apiType, null);
      }
    } catch (error) {
      var d = _handleError(apiType, error);
      return d;
    }
  }

  Map<String, dynamic> _handleError(int apiType, Object? error) {
    String errorDescription = '';
    if (error != null && error is DioError) {
      String? message = error.message;
      errorDescription = message;
      /* if (message == '' || message.startsWith('SocketException: Failed host lookup')) {
        errorDescription = 'Network is not available. Please check the network connection.';
      } else {

      }*/
    } else {
      errorDescription = "Something went wrong. please try again.";
    }
    Map<String, dynamic> er = {};
    er.putIfAbsent(AppConstants.API_TYPE, () => apiType);
    er['code'] = 1;
    er['message'] = errorDescription;
    _apiCallback.onError(er);
    return er;
  }

  Future apiDeleteRequest(String url, request) async {
    final response = await _dio.delete(url, data: request, queryParameters: request);
    return response;
  }

  Future apiGetRequest(String url, request) async {
    final response = await _dio.get(url, queryParameters: request);
    return response;
  }

  Future apiPostRequest(String url, data, Options? options) async {
    final response = await _dio.post(url, data: data, options: options);
    return response;
  }

  Future apiPostBodyRequest(String url, data, request, Options? options) async {
    final response = await _dio.post(
      url,
      data: data,
      queryParameters: request,
      options: options,
    );
    return response;
  }

  Future apiPutRequest(String url, Map<dynamic, dynamic> request) async {
    final response = await _dio.put(url, data: json.encode(request));
    return response;
  }

  Future apiPatchRequest(String url, Map<dynamic, dynamic> request) async {
    final response = await _dio.patch(url, data: json.encode(request));
    return response;
  }

  Future apiPutBodyRequest(String url, data, Map<String, dynamic>? request) async {
    final response = await _dio.put(url, data: data, queryParameters: request);
    return response;
  }

  Future apiPatchBodyRequest(String url, data, Map<String, dynamic> request) async {
    final response = await _dio.patch(url, data: data, queryParameters: request);
    return response;
  }

  Future apiPostMultipart(String url, FormData formData) async {
    var response = await _dio.post(url, data: formData);
    return response;
  }

  Future apiPutMultipart(
    String url,
    FormData formData,
    Map<String, dynamic> request,
  ) async {
    var response = await _dio.put(url, data: formData, queryParameters: request);
    return response;
  }
}
