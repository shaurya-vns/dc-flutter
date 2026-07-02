import 'OfferModel.dart';
import 'PricingDetail.dart';
import 'SubOwner.dart';

class ProductModel {
  ProductModel({
    this.id,
    this.pricingOptions,
    this.offer,
    this.subOwner,
    this.avgRating,
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
    subOwner = json['subOwner'] != null ? SubOwner.fromJson(json['subOwner']) : null;
    avgRating = (json['avg_rating'] as num?)?.toDouble();
    productPrice = (json['product_price'] as num?)?.toDouble();
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
    images = json['images'] != null ? json['images'].cast<String>() : [];
  }

  int? id;
  List<PricingDetail>? pricingOptions;
  OfferModel? offer;
  SubOwner? subOwner;
  double? avgRating;
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
    if (subOwner != null) {
      map['subOwner'] = subOwner?.toJson();
    }
    map['avg_rating'] = avgRating;
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
    return map;
  }
}

class CategoryModel {
  final String category;
  final String? image;

  CategoryModel({required this.category, this.image});
}
