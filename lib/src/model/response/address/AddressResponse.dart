import 'AddressModel.dart';

class AddressResponse {
  AddressResponse({this.data});

  AddressResponse.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(AddressModel.fromJson(v));
      });
    }
  }

  List<AddressModel>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
