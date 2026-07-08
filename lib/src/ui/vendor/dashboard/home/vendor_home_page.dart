import 'package:flutter/material.dart';
import 'package:flutter_dc/src/constants/drawable_constant.dart';
import 'package:flutter_dc/src/widget/click_widget.dart';
import 'package:flutter_dc/src/widget/fix_button_widget.dart';
import 'package:flutter_dc/src/widget/test_regular.dart';

import '../../../../constants/color_constants.dart';
import '../../../../utils/gap.dart';
import 'user_list_widget.dart';

class VendorHomePage extends StatefulWidget {
  const VendorHomePage({Key? key}) : super(key: key);

  @override
  State<VendorHomePage> createState() => _VendorHomePageState();
}

class _VendorHomePageState extends State<VendorHomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.color_bg,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(children: [_widgetHeader(), UserListWidget()]),
      ),
    );
  }

  Widget _widgetHeader() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 10, top: 0, bottom: 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
              ClickWidget(child: Icon(Icons.filter_alt_outlined), onClick: () {}),
            ],
          ),
        ],
      ),
    );
  }
}
