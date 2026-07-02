import 'package:flutter_dc/src/model/response/address/AddressModel.dart';
import 'package:flutter_dc/src/model/response/product/ProductModel.dart';

import '../../product/SubOwner.dart';

class OneTimeOrderData {
  OneTimeOrderData({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.status,
    this.subOwner,
    this.product,
    this.quantity,
    this.amount,
    this.discountAmount,
    this.finalAmount,
    this.address,
    this.mealType,
    this.deliveryDate,
  });

  OneTimeOrderData.fromJson(dynamic json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = json['status'];
    subOwner = json['subOwner'] != null ? SubOwner.fromJson(json['subOwner']) : null;
    product = json['product'] != null ? ProductModel.fromJson(json['product']) : null;
    quantity = json['quantity'];
    amount = json['amount'];
    discountAmount = json['discount_amount'];
    finalAmount = json['final_amount'];

    address = json['address'] != null ? AddressModel.fromJson(json['address']) : null;
    mealType = json['meal_type'];
    deliveryDate = json['delivery_date'];
  }
  int? id;
  String? createdAt;
  String? updatedAt;
  int? status;

  SubOwner? subOwner;
  ProductModel? product;
  int? quantity;
  String? amount;
  String? discountAmount;
  String? finalAmount;
  AddressModel? address;
  String? mealType;
  String? deliveryDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['status'] = status;

    if (subOwner != null) {
      map['subOwner'] = subOwner?.toJson();
    }
    if (product != null) {
      map['product'] = product?.toJson();
    }
    map['quantity'] = quantity;
    map['amount'] = amount;
    map['discount_amount'] = discountAmount;
    map['final_amount'] = finalAmount;

    if (address != null) {
      map['address'] = address?.toJson();
    }
    map['meal_type'] = mealType;
    map['delivery_date'] = deliveryDate;
    return map;
  }
}
