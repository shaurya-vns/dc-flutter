import 'BannerData.dart';
import 'AreasOfService.dart';

class ServiceData {
  ServiceData({
    this.banner,
    this.mainTitle,
    this.mainDescription,
    this.areasOfServiceTitle,
    this.areasOfService,
  });

  ServiceData.fromJson(dynamic json) {
    banner = json['banner'] != null ? BannerData.fromJson(json['banner']) : null;
    mainTitle = json['main_title'];
    mainDescription = json['main_description'];
    areasOfServiceTitle = json['areas_of_service_title'];
    if (json['areas_of_service'] != null) {
      areasOfService = [];
      json['areas_of_service'].forEach((v) {
        areasOfService?.add(AreasOfService.fromJson(v));
      });
    }
  }
  BannerData? banner;
  String? mainTitle;
  String? mainDescription;
  String? areasOfServiceTitle;
  List<AreasOfService>? areasOfService;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (banner != null) {
      map['banner'] = banner?.toJson();
    }
    map['main_title'] = mainTitle;
    map['main_description'] = mainDescription;
    map['areas_of_service_title'] = areasOfServiceTitle;
    if (areasOfService != null) {
      map['areas_of_service'] = areasOfService?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
