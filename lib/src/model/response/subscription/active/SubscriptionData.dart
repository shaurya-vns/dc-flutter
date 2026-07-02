import 'package:flutter_dc/src/model/response/product/ProductModel.dart';

import '../../product/PricingDetail.dart';

class SubscriptionData {
  SubscriptionData({
    this.id,
    this.product,
    this.pricingDetail,
    this.startDate,
    this.endDate,
    this.totalDays,
    this.amount,
    this.status,
    this.createdAt,
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
    totalDays = json['total_days'];
    amount = json['amount'];
    status = json['status'];
    createdAt = json['created_at'];
    quantity = json['quantity'];
  }

  int? id;
  ProductModel? product;
  PricingDetail? pricingDetail;
  String? startDate;
  String? endDate;
  int? totalDays;
  String? amount;
  int? status;
  int? quantity;
  String? createdAt;

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
    map['total_days'] = totalDays;
    map['amount'] = amount;
    map['status'] = status;
    map['created_at'] = createdAt;
    map['quantity'] = quantity;
    return map;
  }
}
