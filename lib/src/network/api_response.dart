import 'package:dio/src/response.dart';

abstract class ApiResponse {
  void onResponse(Response response, int requestCode);

  void onError(e);
}
