class Data {
  Data({this.id, this.orderNumber, this.discount, this.finalAmount, this.status});

  Data.fromJson(dynamic json) {
    id = json['id'];
    orderNumber = json['orderNumber'];
    discount = json['discount'];
    finalAmount = json['final_amount'];
    status = json['status'];
  }
  int? id;
  String? orderNumber;
  int? discount;
  double? finalAmount;
  int? status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['orderNumber'] = orderNumber;
    map['discount'] = discount;
    map['final_amount'] = finalAmount;
    map['status'] = status;
    return map;
  }
}
