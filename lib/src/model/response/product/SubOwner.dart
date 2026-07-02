import '../address/AddressModel.dart';

class SubOwner {
  SubOwner({this.id, this.name, this.phoneNumber, this.profileImage, this.address});

  SubOwner.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    phoneNumber = json['phoneNumber'];
    profileImage = json['profileImage'];
    address = json['address'] != null ? AddressModel.fromJson(json['address']) : null;
  }
  int? id;
  String? name;
  String? phoneNumber;
  String? profileImage;
  AddressModel? address;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['phoneNumber'] = phoneNumber;
    map['profileImage'] = profileImage;
    if (address != null) {
      map['address'] = address?.toJson();
    }
    return map;
  }
}
