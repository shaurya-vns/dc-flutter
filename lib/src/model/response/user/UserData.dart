import 'package:flutter_dc/src/model/response/address/AddressModel.dart';

class UserData {
  UserData({
    this.id,
    this.name,
    this.phoneNumber,
    this.platform,
    this.deviceToken,
    this.deviceId,
    this.userType,
    this.address,
  });

  UserData.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    phoneNumber = json['phoneNumber'];
    platform = json['platform'];
    deviceToken = json['deviceToken'];
    deviceId = json['deviceId'];
    userType = json['userType'];
    address = json['address'] != null ? AddressModel.fromJson(json['address']) : null;
  }
  int? id;
  String? name;
  String? phoneNumber;
  int? platform;
  int? userType;
  String? deviceToken;
  String? deviceId;

  AddressModel? address;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['phoneNumber'] = phoneNumber;
    map['platform'] = platform;
    map['deviceToken'] = deviceToken;
    map['deviceId'] = deviceId;
    map['userType'] = userType;

    if (address != null) {
      map['address'] = address?.toJson();
    }
    return map;
  }
}
