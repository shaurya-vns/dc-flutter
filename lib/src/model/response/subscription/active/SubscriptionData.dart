import 'package:flutter_dc/src/model/response/address/AddressModel.dart';
import 'package:flutter_dc/src/model/response/product/ProductModel.dart';

import '../../../../utils/ext.dart';
import '../../product/PricingDetail.dart';
import '../../user/UserData.dart';

class SubscriptionData {
  SubscriptionData({
    this.id,
    this.product,
    this.pricingDetail,
    this.startDate,
    this.endDate,
    this.status,
    this.quantity,
    this.paymentStatus,
    this.originalPrice,
    this.discountAmount,
    this.amount,
    this.address,
    this.subNumber,
    this.user,
  });

  SubscriptionData.fromJson(dynamic json) {
    id = json['id'];
    product = json['product'] != null ? ProductModel.fromJson(json['product']) : null;
    pricingDetail =
        json['pricing_detail'] != null
            ? PricingDetail.fromJson(json['pricing_detail'])
            : null;
    startDate = json['start_date'];
    endDate = json['end_date'];
    status = json['status'];
    quantity = json['quantity'];
    subNumber = json['sub_number'];
    paymentStatus = json['payment_status'];
    originalPrice = toDouble(json['original_price']);
    discountAmount = toDouble(json['discount_amount']);
    amount = toDouble(json['amount']);
    address = json['address'] != null ? AddressModel.fromJson(json['address']) : null;
    user = json['user'] != null ? UserData.fromJson(json['user']) : null;
  }

  int? id;
  ProductModel? product;
  PricingDetail? pricingDetail;
  String? startDate;
  String? endDate;
  int? status;
  int? quantity;
  int? paymentStatus;
  double? originalPrice;
  double? discountAmount;
  double? amount;
  AddressModel? address;
  String? subNumber;
  UserData? user;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    if (product != null) {
      map['product'] = product?.toJson();
    }
    if (pricingDetail != null) {
      map['pricing_detail'] = pricingDetail?.toJson();
    }
    map['start_date'] = startDate;
    map['end_date'] = endDate;
    map['status'] = status;
    map['quantity'] = quantity;
    map['payment_status'] = paymentStatus;
    map['original_price'] = originalPrice;
    map['discount_amount'] = discountAmount;
    map['amount'] = amount;
    map['sub_number'] = subNumber;
    if (address != null) {
      map['address'] = address?.toJson();
    }
    if (user != null) {
      map['user'] = user?.toJson();
    }
    return map;
  }
}
