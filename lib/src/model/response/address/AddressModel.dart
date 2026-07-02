import '../../../utils/ext.dart';

class AddressModel {
  AddressModel({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.addressType,
    this.houseNo,
    this.landmark,
    this.address,
    this.city,
    this.state,
    this.pincode,
    this.latitude,
    this.longitude,
    this.isDefault,
  });

  AddressModel.fromJson(dynamic json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    addressType = json['addressType'];
    houseNo = json['houseNo'];
    landmark = json['landmark'];
    address = json['address'];
    city = json['city'];
    state = json['state'];
    pincode = json['pincode'];

    latitude = toDouble(json['latitude']);
    longitude = toDouble(json['longitude']);

    isDefault = json['isDefault'];
  }

  int? id;
  String? createdAt;
  String? updatedAt;
  int? addressType;
  String? houseNo;
  String? landmark;
  String? address;
  String? city;
  String? state;
  int? pincode;
  double? latitude;
  double? longitude;
  bool? isDefault;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['addressType'] = addressType;
    map['houseNo'] = houseNo;
    map['landmark'] = landmark;
    map['address'] = address;
    map['city'] = city;
    map['state'] = state;
    map['pincode'] = pincode;
    map['latitude'] = latitude;
    map['longitude'] = longitude;
    map['isDefault'] = isDefault;

    return map;
  }

  String get fullAddress1 {
    final parts = <String>[
      if ((houseNo ?? '').trim().isNotEmpty) houseNo!.trim(),
      if ((landmark ?? '').trim().isNotEmpty) landmark!.trim(),
      if ((address ?? '').trim().isNotEmpty) address!.trim(),
      if (pincode != null) pincode.toString(),
    ];

    return parts.join(', ');
  }

  String get fullAddress {
    final parts = <String>[
      if ((houseNo ?? '').trim().isNotEmpty) houseNo!.trim(),
      if ((landmark ?? '').trim().isNotEmpty) landmark!.trim(),
      if ((address ?? '').trim().isNotEmpty) address!.trim(),
      if ((city ?? '').trim().isNotEmpty) city!.trim(),
      if ((state ?? '').trim().isNotEmpty) state!.trim(),
      if (pincode != null) pincode.toString(),
    ];

    return parts.join(', ');
  }

  String get addressTypeLabel {
    switch (addressType) {
      case 1:
        return "Home";
      case 2:
        return "Office";
      case 3:
        return "Other";
      default:
        return "Unknown";
    }
  }
}
