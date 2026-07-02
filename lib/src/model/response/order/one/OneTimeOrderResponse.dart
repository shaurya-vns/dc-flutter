import 'OneTimeOrderData.dart';

class OneTimeOrderResponse {
  OneTimeOrderResponse({this.data});

  OneTimeOrderResponse.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(OneTimeOrderData.fromJson(v));
      });
    }
  }

  List<OneTimeOrderData>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
