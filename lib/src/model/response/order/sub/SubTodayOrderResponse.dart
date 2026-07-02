import 'SubTodayOrderData.dart';

class SubTodayOrderResponse {
  SubTodayOrderResponse({this.message, this.data});

  SubTodayOrderResponse.fromJson(dynamic json) {
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(SubTodayOrderData.fromJson(v));
      });
    }
  }
  String? message;
  List<SubTodayOrderData>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
