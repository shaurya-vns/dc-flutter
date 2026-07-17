import 'package:flutter/material.dart';
import 'package:flutter_dc/src/widget/test_regular.dart';
import 'package:flutter_dc/src/widget/test_semi.dart';

import '../utils/app_utils.dart';

class RatingWidget extends StatelessWidget {
  final double? rating;
  final int? count;

  RatingWidget({this.rating = 35, this.count = 35});

  @override
  Widget build(BuildContext context) {
    if (AppUtils.getDouble(rating) == 0) {
      return const SizedBox();
    }

    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xff4A90E2), Color(0xff3578E5)],
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(.25),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.star_rounded, color: Colors.amber, size: 12),
              const SizedBox(width: 2),
              TextSemi(str: rating.toString(), color: Colors.white, size: 12),
              const SizedBox(width: 6),
              Container(width: 1, height: 11, color: Colors.white24),
              const SizedBox(width: 6),
              TextRegular(str: count.toString(), color: Colors.white, size: 11),
            ],
          ),
        ),
      ),
    );
  }
}
