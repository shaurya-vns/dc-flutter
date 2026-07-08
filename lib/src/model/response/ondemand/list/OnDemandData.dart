import 'package:flutter_dc/src/model/response/address/AddressModel.dart';

class OnDemandData {
  OnDemandData({
    this.id,
    this.userName,
    this.userPhone,
    this.subOwnerName,
    this.subOwnerPhone,
    this.addressDetail,
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
    this.status,
    this.orderNumber,
    this.user,
    this.subOwner,
    this.address,
    this.cancelReason,
  });

  OnDemandData.fromJson(dynamic json) {
    id = json['id'];
    userName = json['userName'];
    userPhone = json['userPhone'];
    subOwnerName = json['subOwnerName'];
    subOwnerPhone = json['subOwnerPhone'];
    addressDetail =
        json['addressDetail'] != null
            ? AddressModel.fromJson(json['addressDetail'])
            : null;
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
    status = json['status'];
    orderNumber = json['orderNumber'];
    cancelReason = json['cancelReason'];
    user = json['user'];
    subOwner = json['subOwner'];
    address = json['address'];
  }

  int? id;
  String? userName;
  String? userPhone;
  String? subOwnerName;
  String? subOwnerPhone;
  AddressModel? addressDetail;
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
  String? orderNumber;
  int? user;
  int? subOwner;
  int? address;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['userName'] = userName;
    map['userPhone'] = userPhone;
    map['subOwnerName'] = subOwnerName;
    map['subOwnerPhone'] = subOwnerPhone;
    if (addressDetail != null) {
      map['addressDetail'] = addressDetail?.toJson();
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
    map['status'] = status;
    map['orderNumber'] = orderNumber;
    map['user'] = user;
    map['subOwner'] = subOwner;
    map['address'] = address;
    map['cancelReason'] = cancelReason;
    return map;
  }
}
