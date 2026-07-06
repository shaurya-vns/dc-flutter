import 'UserOrder.dart';

class UserListResponse {
  UserListResponse({this.message, this.data});

  UserListResponse.fromJson(dynamic json) {
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(UserOrder.fromJson(v));
      });
    }
  }
  String? message;
  List<UserOrder>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
