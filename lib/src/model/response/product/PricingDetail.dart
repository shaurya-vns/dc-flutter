import 'package:flutter_dc/src/utils/ext.dart';

class PricingDetail {
  PricingDetail({this.id, this.days, this.price, this.isBestOffer});

  PricingDetail.fromJson(dynamic json) {
    id = json['id'];
    days = json['days'];
    isBestOffer = json['is_best_offer'];
    price = toDouble(json['price']);
  }
  int? id;
  int? days;
  double? price;
  bool? isBestOffer;
  bool isSelected = false;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['days'] = days;
    map['price'] = price;
    map['is_best_offer'] = isBestOffer;
    return map;
  }
}
