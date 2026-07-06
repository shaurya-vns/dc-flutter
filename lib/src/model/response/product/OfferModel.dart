import '../../../utils/ext.dart';

class OfferModel {
  OfferModel({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.code,
    this.name,
    this.discountAmount,
    this.isActive,
    this.startDate,
    this.endDate,
  });

  OfferModel.fromJson(dynamic json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    code = json['code'];
    name = json['name'];
    discountAmount = toDouble(json['discount_amount']);
    isActive = json['is_active'];
    startDate = json['start_date'];
    endDate = json['end_date'];
  }
  int? id;
  String? createdAt;
  String? updatedAt;
  String? code;
  String? name;
  double? discountAmount;
  bool? isActive;
  String? startDate;
  String? endDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['code'] = code;
    map['name'] = name;
    map['discount_amount'] = discountAmount;
    map['is_active'] = isActive;
    map['start_date'] = startDate;
    map['end_date'] = endDate;
    return map;
  }
}
