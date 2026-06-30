import 'UserData.dart';

class UserResponse {
  UserResponse({this.message, this.token, this.data});

  UserResponse.fromJson(dynamic json) {
    message = json['message'];
    token = json['token'];
    data = json['data'] != null ? UserData.fromJson(json['data']) : null;
  }
  String? message;
  String? token;
  UserData? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    map['token'] = token;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }
}
