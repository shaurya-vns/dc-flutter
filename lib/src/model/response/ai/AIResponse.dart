import 'package:flutter_dc/src/model/response/ai/AIData.dart';

class AIResponse {
  AIResponse({this.data});

  AIResponse.fromJson(dynamic json) {
    data = json['data'] != null ? AIData.fromJson(json['data']) : null;
  }

  AIData? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }
}
