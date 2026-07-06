import 'package:flutter/material.dart';
import 'package:flutter_dc/src/constants/drawable_constant.dart';
import 'package:flutter_dc/src/widget/click_widget.dart';
import 'package:flutter_dc/src/widget/fix_button_widget.dart';
import 'package:flutter_dc/src/widget/test_regular.dart';

import '../../../../constants/color_constants.dart';
import '../../../../utils/gap.dart';
import 'owner_onetime_order_page.dart';
import 'owner_sub_order_page.dart';

class OwnerOrderPage extends StatefulWidget {
  const OwnerOrderPage({Key? key}) : super(key: key);

  @override
  State<OwnerOrderPage> createState() => _OwnerOrderPageState();
}

class _OwnerOrderPageState extends State<OwnerOrderPage> {
  int _selectedTab = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.color_bg,
      child: Column(
        children: [
          _widgetHeader(),
          Gap(h: 15),
          _widgetTab(),
          Gap(h: 15),
          _selectedTab == 1 ? OwnerSubOrderPage() : OwnerOneTimeOrderPage(),
        ],
      ),
    );
  }

  Widget _widgetTab() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _widgetItem('Subscription Order', 1),
          Gap(w: 20),
          _widgetItem('One Time Order', 2),
        ],
      ),
    );
  }

  Widget _widgetItem(String str, int type) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 4),
      child: FixButtonWidget(
        color: _selectedTab == type ? AppColor.colorBlue : AppColor.white,
        borderColor: AppColor.colorBlue.withOpacity(0.3),
        height: 36,
        child: Row(
          children: [
            Gap(w: 20),
            Icon(
              Icons.all_inbox,
              color: _selectedTab == type ? AppColor.white : AppColor.colorBlue,
              size: 15,
            ),
            Gap(w: 6),
            TextRegular(
              str: str,
              color: _selectedTab == type ? AppColor.white : AppColor.colorBlue,
              size: 14,
            ),
            Gap(w: 15),
          ],
        ),
        onPressed: () {
          _selectedTab = type;
          setState(() {});
        },
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
