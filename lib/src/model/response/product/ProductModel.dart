import '../subscription/active/PricingDetail.dart';

class ProductModel {
  ProductModel({
    this.id,
    this.name,
    this.planName,
    this.planType,
    this.shortDescription,
    this.include,
    this.description,
    this.images,
    this.isSubscribed,
  });

  ProductModel.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    planName = json['plan_name'];
    planType = json['plan_type'];
    shortDescription = json['short_description'];
    include = json['include'];
    description = json['description'];
    isSubscribed = json['isSubscribed'];
    images = json['images'] != null ? json['images'].cast<String>() : [];

    if (json['pricing_options'] != null) {
      pricingOptions = [];
      json['pricing_options'].forEach((v) {
        pricingOptions?.add(PricingDetail.fromJson(v));
      });
    }
  }

  int? id;
  String? name;
  String? planName;
  String? planType;
  String? shortDescription;
  String? include;
  String? description;
  bool? isSubscribed;
  List<String>? images;
  List<PricingDetail>? pricingOptions;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['plan_name'] = planName;
    map['plan_type'] = planType;
    map['short_description'] = shortDescription;
    map['include'] = include;
    map['description'] = description;
    map['images'] = images;
    map['isSubscribed'] = isSubscribed;

    if (pricingOptions != null) {
      map['pricing_options'] = pricingOptions?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
