import 'ContactUsData.dart';

class ContactUsResponse {
  ContactUsResponse({this.data});

  ContactUsResponse.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(ContactUsData.fromJson(v));
      });
    }
  }
  List<ContactUsData>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
