import 'package:flutter_dc/src/model/response/user/UserData.dart';

import 'Data.dart';

class UserListResponse {
  UserListResponse({this.data});

  UserListResponse.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(UserData.fromJson(v));
      });
    }
  }
  List<UserData>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
