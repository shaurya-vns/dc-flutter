import 'ReviewData.dart';

class ReviewResponse {
  ReviewResponse({this.data});

  ReviewResponse.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(ReviewData.fromJson(v));
      });
    }
  }

  List<ReviewData>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
