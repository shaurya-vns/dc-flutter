import 'package:flutter_dc/src/model/response/subscription/active/SubscriptionData.dart';

import '../../product/ProductModel.dart';

class SubTodayOrderData {
  SubTodayOrderData({
    this.id,
    this.subscription,
    this.mealType,
    this.deliveryDate,
    this.status,
    this.quantity,
  });

  SubTodayOrderData.fromJson(dynamic json) {
    id = json['id'];
    subscription =
        json['subscription'] != null
            ? SubscriptionData.fromJson(json['subscription'])
            : null;
    mealType = json['meal_type'];
    deliveryDate = json['delivery_date'];
    status = json['status'];
    quantity = json['quantity'];
  }
  int? id;
  SubscriptionData? subscription;
  String? mealType;
  String? deliveryDate;
  int? status;
  int? quantity;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    if (subscription != null) {
      map['subscription'] = subscription?.toJson();
    }
    map['meal_type'] = mealType;
    map['delivery_date'] = deliveryDate;
    map['status'] = status;
    map['quantity'] = quantity;
    return map;
  }
}
