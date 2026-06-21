import 'package:flutter/material.dart';

import '../constants/color_constants.dart';
import '../constants/drawable_constant.dart';
import 'fill_button_widget.dart';

class BottomWidget extends StatelessWidget {
  final String? title;
  final VoidCallback onClick;

  const BottomWidget({required this.title, required this.onClick});

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 1,
          decoration: const BoxDecoration(
            color: AppColor.white,
            boxShadow: [
              BoxShadow(
                color: AppColor.color_DADADA,
                blurRadius: 1.0, // soften the shadow
                spreadRadius: .5, //extend the shadow
                offset: Offset(
                  0.0, // Move to right 5  horizontally
                  1.0, // Move to bottom 5 Vertically
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(left: 30, right: 30, bottom: 40),
          child: FillButtonWidget(
            title: title ?? '',
            fontSize: 16,
            bgColor: AppColor.color_002B56,
            onPressed: () {
              onClick();
            },
          ),
        ),
      ],
    );
  }
}
