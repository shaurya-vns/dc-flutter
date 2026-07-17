class Data {
  Data({this.id, this.name, this.phoneNumber, this.userType});

  Data.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    phoneNumber = json['phoneNumber'];
    userType = json['userType'];
  }
  int? id;
  String? name;
  String? phoneNumber;
  int? userType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['phoneNumber'] = phoneNumber;
    map['userType'] = userType;
    return map;
  }
}
