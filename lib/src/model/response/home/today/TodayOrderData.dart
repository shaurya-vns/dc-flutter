import '../../product/ProductModel.dart';

class TodayOrderData {
  TodayOrderData({
    this.id,
    this.product,
    this.mealType,
    this.deliveryDate,
    this.status,
    this.createdAt,
  });

  TodayOrderData.fromJson(dynamic json) {
    id = json['id'];
    product = json['product'] != null ? ProductModel.fromJson(json['product']) : null;
    mealType = json['meal_type'];
    deliveryDate = json['delivery_date'];
    status = json['status'];
    createdAt = json['created_at'];
  }
  int? id;
  ProductModel? product;
  String? mealType;
  String? deliveryDate;
  int? status;
  String? createdAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    if (product != null) {
      map['product'] = product?.toJson();
    }
    map['meal_type'] = mealType;
    map['delivery_date'] = deliveryDate;
    map['status'] = status;
    map['created_at'] = createdAt;
    return map;
  }
}
