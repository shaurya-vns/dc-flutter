import 'package:flutter_dc/src/model/response/product/ProductModel.dart';

class ProductListResponse {
  ProductListResponse({this.message, this.data});

  ProductListResponse.fromJson(dynamic json) {
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(ProductModel.fromJson(v));
      });
    }
  }
  String? message;
  List<ProductModel>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
