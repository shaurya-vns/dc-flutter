import 'package:flutter_dc/src/model/response/address/AddressModel.dart';

import '../../user/UserData.dart';

class OnDemandData {
  OnDemandData({
    this.id,
    this.vendor,
    this.delivery,
    this.user,
    this.address,
    this.createdAt,
    this.updatedAt,
    this.mealType,
    this.itemName,
    this.quantity,
    this.deliveryDate,
    this.userAmount,
    this.vendorAmount,
    this.finalAmount,
    this.note,
    this.rejectReason,
    this.cancelReason,
    this.status,
  });

  OnDemandData.fromJson(dynamic json) {
    id = json['id'];
    vendor = json['vendor'] != null ? UserData.fromJson(json['vendor']) : null;
    delivery = json['delivery'] != null ? UserData.fromJson(json['delivery']) : null;
    user = json['user'] != null ? UserData.fromJson(json['user']) : null;
    address = json['address'] != null ? AddressModel.fromJson(json['address']) : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    mealType = json['mealType'];
    itemName = json['itemName'];
    quantity = json['quantity'];
    deliveryDate = json['deliveryDate'];
    userAmount = json['userAmount'];
    vendorAmount = json['vendorAmount'];
    finalAmount = json['finalAmount'];
    note = json['note'];
    rejectReason = json['rejectReason'];
    cancelReason = json['cancelReason'];
    status = json['status'];
  }

  int? id;
  UserData? vendor;
  UserData? delivery;
  UserData? user;

  // delivery address
  AddressModel? address;
  String? createdAt;
  String? updatedAt;
  String? mealType;
  String? itemName;
  int? quantity;
  String? deliveryDate;
  String? userAmount;
  String? vendorAmount;
  String? finalAmount;
  String? note;
  String? rejectReason;
  String? cancelReason;
  int? status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    if (vendor != null) {
      map['vendor'] = vendor?.toJson();
    }
    if (delivery != null) {
      map['delivery'] = delivery?.toJson();
    }
    if (user != null) {
      map['user'] = user?.toJson();
    }
    if (address != null) {
      map['address'] = address?.toJson();
    }
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['mealType'] = mealType;
    map['itemName'] = itemName;
    map['quantity'] = quantity;
    map['deliveryDate'] = deliveryDate;
    map['userAmount'] = userAmount;
    map['vendorAmount'] = vendorAmount;
    map['finalAmount'] = finalAmount;
    map['note'] = note;
    map['rejectReason'] = rejectReason;
    map['cancelReason'] = cancelReason;
    map['status'] = status;
    return map;
  }
}
