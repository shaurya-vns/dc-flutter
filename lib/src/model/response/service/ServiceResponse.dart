import 'ServiceData.dart';

class ServiceResponse {
  ServiceResponse({this.status, this.data});

  ServiceResponse.fromJson(dynamic json) {
    status = json['status'];
    data = json['data'] != null ? ServiceData.fromJson(json['data']) : null;
  }

  String? status;
  ServiceData? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }
}
