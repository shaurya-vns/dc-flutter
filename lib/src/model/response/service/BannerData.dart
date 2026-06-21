class BannerData {
  BannerData({this.img, this.alt});

  BannerData.fromJson(dynamic json) {
    img = json['img'];
    alt = json['alt'];
  }
  String? img;
  String? alt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['img'] = img;
    map['alt'] = alt;
    return map;
  }
}
