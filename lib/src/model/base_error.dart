import '../utils/log.dart';

class BaseError {
  BaseError({required this.code, required this.message});

  BaseError.fromJson(dynamic json) {
    try {
      if (json != null && json.containsKey('code')) {
        code = json['code'];
      }
      if (json != null && json.containsKey('message')) {
        message = json['message'];
      }
    } catch (e) {
      code = 123;
      message = 'Something went wrong. Please try again. ';
    }
  }

  int code = 0;
  String? message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = code;
    map['message'] = message;
    return map;
  }
}
