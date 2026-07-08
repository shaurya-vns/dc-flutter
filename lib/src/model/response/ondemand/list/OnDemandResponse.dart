import 'OnDemandData.dart';

class OnDemandResponse {
  OnDemandResponse({this.data});

  OnDemandResponse.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(OnDemandData.fromJson(v));
      });
    }
  }
  List<OnDemandData>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
