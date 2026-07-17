import 'package:flutter_dc/src/utils/ext.dart';

class ReviewData {
  ReviewData({this.id, this.userName, this.profileImage, this.rating, this.review});

  ReviewData.fromJson(dynamic json) {
    id = json['id'];
    userName = json['userName'];
    profileImage = json['profileImage'];
    rating = toDouble(json['rating']);
    review = json['review'];
  }

  int? id;
  String? userName;
  String? profileImage;
  double? rating;
  String? review;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['userName'] = userName;
    map['profileImage'] = profileImage;
    map['rating'] = rating;
    map['review'] = review;
    return map;
  }
}
