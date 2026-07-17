import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shimmer/shimmer.dart';

import '../constants/color_constants.dart';

class LoadingWidget extends StatelessWidget {
  LoadingWidget();

  final StreamController<List<String>?> galleryListStream = BehaviorSubject();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Shimmer.fromColors(
          baseColor: AppColor.grayborder,
          highlightColor: AppColor.color_BBBBBB,
          child: Container(
            color: AppColor.grayborder,
            height: 5,
            width: 100,
            child: SizedBox(),
          ),
        ),
        SizedBox(height: 1),
        Shimmer.fromColors(
          baseColor: AppColor.grayborder,
          highlightColor: AppColor.color_BBBBBB,
          child: Container(
            color: AppColor.grayborder,
            height: 5,
            width: 150,
            child: SizedBox(),
          ),
        ),
      ],
    );
  }
}

//TypingEffectWidget()
