import 'package:flutter_dc/src/model/response/address/AddressModel.dart';
import 'package:flutter_dc/src/model/response/product/ProductModel.dart';
import 'package:flutter_dc/src/model/response/user/UserData.dart';

import '../../../../utils/ext.dart';
import '../../product/SubOwner.dart';

class OneTimeOrderData {
  OneTimeOrderData({
    this.id,
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
    this.orderNumber,
    this.user,
  });

  OneTimeOrderData.fromJson(dynamic json) {
    id = json['id'];
    status = json['status'];
    subOwner = json['subOwner'] != null ? SubOwner.fromJson(json['subOwner']) : null;
    user = json['user'] != null ? UserData.fromJson(json['user']) : null;
    product = json['product'] != null ? ProductModel.fromJson(json['product']) : null;
    quantity = json['quantity'];

    amount = toDouble(json['amount']);
    discountAmount = toDouble(json['discount_amount']);
    finalAmount = toDouble(json['final_amount']);

    address = json['address'] != null ? AddressModel.fromJson(json['address']) : null;
    mealType = json['meal_type'];
    deliveryDate = json['delivery_date'];
    orderNumber = json['order_number'];
  }
  int? id;
  int? status;
  SubOwner? subOwner;
  ProductModel? product;
  int? quantity;
  double? amount;
  double? discountAmount;
  double? finalAmount;
  AddressModel? address;
  String? mealType;
  String? deliveryDate;
  String? orderNumber;

  UserData? user;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['status'] = status;

    if (subOwner != null) {
      map['subOwner'] = subOwner?.toJson();
    }
    if (user != null) {
      map['user'] = user?.toJson();
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
    map['order_number'] = orderNumber;
    return map;
  }
}
