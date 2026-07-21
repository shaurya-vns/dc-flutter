class AIData {
  AIData({this.type, this.message});

  AIData.fromJson(dynamic json) {
    type = json['type'];
    message = json['message'];
  }

  String? type;
  String? message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['type'] = type;
    map['message'] = message;
    return map;
  }
}
