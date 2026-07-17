import 'package:flutter_dc/src/model/response/user/UserData.dart';

import '../../../utils/ext.dart';
import 'OfferModel.dart';
import 'PricingDetail.dart';

class ProductModel {
  ProductModel({
    this.id,
    this.pricingOptions,
    this.offer,
    this.vendor,
    this.rating,
    this.createdAt,
    this.updatedAt,
    this.category,
    this.planType,
    this.day,
    this.name,
    this.title,
    this.description,
    this.isActive,
    this.images,
    this.isSubscribed,
    this.productPrice,
    this.totalReviews,
  });

  ProductModel.fromJson(dynamic json) {
    id = json['id'];
    if (json['pricing_options'] != null) {
      pricingOptions = [];
      json['pricing_options'].forEach((v) {
        pricingOptions?.add(PricingDetail.fromJson(v));
      });
    }
    offer = json['offer'] != null ? OfferModel.fromJson(json['offer']) : null;
    vendor = json['vendor'] != null ? UserData.fromJson(json['vendor']) : null;

    rating = toDouble(json['rating']);
    productPrice = toDouble(json['product_price']);

    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    category = json['category'];
    planType = json['plan_type'];
    day = json['day'];
    name = json['name'];
    title = json['title'];
    description = json['description'];
    isActive = json['is_active'];
    isSubscribed = json['isSubscribed'];
    totalReviews = json['totalReviews'];
    images = json['images'] != null ? json['images'].cast<String>() : [];
  }

  int? id;
  List<PricingDetail>? pricingOptions;
  OfferModel? offer;
  UserData? vendor;
  double? rating;
  double? productPrice;
  String? createdAt;
  String? updatedAt;
  String? category;
  String? planType;
  String? day;
  String? name;
  String? title;
  String? description;
  bool? isActive;
  bool? isSubscribed;
  int? totalReviews;
  List<String>? images;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    if (pricingOptions != null) {
      map['pricing_options'] = pricingOptions?.map((v) => v.toJson()).toList();
    }
    if (offer != null) {
      map['offer'] = offer?.toJson();
    }
    if (vendor != null) {
      map['vendor'] = vendor?.toJson();
    }
    map['rating'] = rating;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['category'] = category;
    map['plan_type'] = planType;
    map['day'] = day;
    map['name'] = name;
    map['title'] = title;
    map['description'] = description;
    map['is_active'] = isActive;
    map['images'] = images;
    map['isSubscribed'] = isSubscribed;
    map['product_price'] = productPrice;
    map['totalReviews'] = totalReviews;
    return map;
  }
}

class CategoryModel {
  final String category;
  final String? image;

  CategoryModel({required this.category, this.image});
}
