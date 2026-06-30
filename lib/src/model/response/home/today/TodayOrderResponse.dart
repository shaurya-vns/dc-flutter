import 'TodayOrderData.dart';

class TodayOrderResponse {
  TodayOrderResponse({this.message, this.data});

  TodayOrderResponse.fromJson(dynamic json) {
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(TodayOrderData.fromJson(v));
      });
    }
  }
  String? message;
  List<TodayOrderData>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
