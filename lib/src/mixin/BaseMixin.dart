import 'package:flutter/material.dart';
import 'package:flutter_dc/src/utils/gap.dart';
import 'package:flutter_dc/src/widget/test_medium.dart';

import '../constants/color_constants.dart';
import '../constants/drawable_constant.dart';
import '../widget/fix_button_widget.dart';
import '../widget/test_regular.dart';

mixin BaseMixin {
  Widget searchWidget() {
    return Column(
      children: [
        Gap(h: 10),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            children: [
              Expanded(
                child: FixButtonWidget(
                  onPressed: () {},
                  radius: 10,
                  borderColor: AppColor.white,
                  height: 43,
                  child: Row(
                    children: [
                      Gap(w: 10),
                      Image.asset(
                        color: AppColor.black,
                        DrawableConstant.ic_search,
                        width: 23,
                        height: 23,
                      ),
                      Gap(w: 10),
                      TextRegular(str: 'Search by...', size: 16, color: AppColor.black),
                    ],
                  ),
                ),
              ),
              Gap(w: 5),
            ],
          ),
        ),
      ],
    );
  }

  Widget widgetBackUI(BuildContext context, String? title) {
    return Row(
      children: [
        Gap(w: 5),
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_rounded, size: 25),
        ),
        TextMedium(size: 15, str: title ?? '', color: AppColor.black),
      ],
    );
  }
}
