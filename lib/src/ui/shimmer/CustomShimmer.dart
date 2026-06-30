import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../constants/color_constants.dart';
import '../../utils/app_constant.dart';
import '../../utils/gap.dart';
import '../../widget/rounded_container.dart';

class CustomShimmer extends StatelessWidget {
  final int? listSize;

  const CustomShimmer({this.listSize = 9, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Gap(h: 20),
        Shimmer.fromColors(
          baseColor: AppColor.grayborder,
          highlightColor: AppColor.color_BBBBBB,
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: RoundedContainer(
              paddingL: 10,
              width: SCREEN_WIDTH,
              height: 50,
              paddingR: 10,
              rounded: 10,
              child: Center(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    children: [TextSpan(text: '', style: TextStyle(color: Colors.white))],
                  ),
                ),
              ),
            ),
          ),
        ),
        Gap(h: 20),
        Shimmer.fromColors(
          baseColor: AppColor.grayborder,
          highlightColor: AppColor.color_BBBBBB,
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: RoundedContainer(
              paddingL: 10,
              width: SCREEN_WIDTH,
              height: 150,
              paddingR: 10,
              rounded: 10,
              child: Center(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    children: [TextSpan(text: '', style: TextStyle(color: Colors.white))],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
