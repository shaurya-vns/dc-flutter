class UserOrder {
  UserOrder({
    this.id,
    this.name,
    this.phoneNumber,
    this.subscriptionOrderCount,
    this.oneTimeOrderCount,
    this.totalOrderCount,
  });

  UserOrder.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    phoneNumber = json['phoneNumber'];
    subscriptionOrderCount = json['subscription_order_count'];
    oneTimeOrderCount = json['one_time_order_count'];
    totalOrderCount = json['total_order_count'];
  }
  int? id;
  String? name;
  String? phoneNumber;
  int? subscriptionOrderCount;
  int? oneTimeOrderCount;
  int? totalOrderCount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['phoneNumber'] = phoneNumber;
    map['subscription_order_count'] = subscriptionOrderCount;
    map['one_time_order_count'] = oneTimeOrderCount;
    map['total_order_count'] = totalOrderCount;
    return map;
  }
}
