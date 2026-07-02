import 'package:flutter_dc/src/model/response/product/ProductModel.dart';

class ProductDetailResponse {
  ProductDetailResponse({this.data});

  ProductDetailResponse.fromJson(dynamic json) {
    data = json['data'] != null ? ProductModel.fromJson(json['data']) : null;
  }
  ProductModel? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }
}
