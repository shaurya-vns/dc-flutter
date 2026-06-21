class CommonResponse {
  CommonResponse({this.message});

  CommonResponse.fromJson(dynamic json) {
    message = json['message'];
  }
  String? message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    return map;
  }
}

class CommonResponse1 {
  CommonResponse1({this.message, this.data});

  CommonResponse1.fromJson(dynamic json) {
    message = json['message'];
    data = json['data'];
  }
  String? message;
  bool? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    map['data'] = data;
    return map;
  }
}
