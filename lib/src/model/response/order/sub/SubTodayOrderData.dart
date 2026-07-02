import '../../product/ProductModel.dart';

class SubTodayOrderData {
  SubTodayOrderData({
    this.id,
    this.product,
    this.mealType,
    this.deliveryDate,
    this.status,
    this.createdAt,
    this.quantity,
  });

  SubTodayOrderData.fromJson(dynamic json) {
    id = json['id'];
    product = json['product'] != null ? ProductModel.fromJson(json['product']) : null;
    mealType = json['meal_type'];
    deliveryDate = json['delivery_date'];
    status = json['status'];
    createdAt = json['created_at'];
    quantity = json['quantity'];
  }
  int? id;
  ProductModel? product;
  String? mealType;
  String? deliveryDate;
  int? status;
  int? quantity;
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
    map['quantity'] = quantity;
    return map;
  }
}
