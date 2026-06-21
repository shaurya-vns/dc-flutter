class AreasOfService {
  AreasOfService({this.icon, this.title, this.description, this.img});

  AreasOfService.fromJson(dynamic json) {
    icon = json['icon'];
    title = json['title'];
    description = json['description'];
    img = json['img'];
  }

  String? icon;
  String? title;
  String? description;
  String? img;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['icon'] = icon;
    map['title'] = title;
    map['description'] = description;
    map['img'] = img;
    return map;
  }
}
