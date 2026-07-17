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
    this.isToday,
    this.rejectReason,
    this.cancelReason,
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
    isToday = json['isToday'];
    rejectReason = json['rejectReason'];
    cancelReason = json['cancelReason'];
  }
  int? id;
  SubscriptionData? subscription;
  String? mealType;
  String? deliveryDate;
  String? rejectReason;
  String? cancelReason;
  int? status;
  int? quantity;
  bool? isToday;

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
    map['isToday'] = isToday;
    map['rejectReason'] = rejectReason;
    map['cancelReason'] = cancelReason;
    return map;
  }
}
