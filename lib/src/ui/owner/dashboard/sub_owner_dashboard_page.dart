import 'package:flutter/material.dart';
import 'package:flutter_dc/src/ui/owner/dashboard/home/owner_home_page.dart';
import 'package:flutter_dc/src/ui/owner/dashboard/user/sub_user_page.dart';
import 'package:flutter_dc/src/widget/test_regular.dart';

import '../../../constants/color_constants.dart';
import '../../../constants/drawable_constant.dart';
import '../../../widget/click_widget.dart';
import 'order/owner_order_page.dart';

class SubOwnerDashboardPage extends StatefulWidget {
  const SubOwnerDashboardPage({Key? key}) : super(key: key);

  @override
  State<SubOwnerDashboardPage> createState() => _SubOwnerDashboardPageState();
}

class _SubOwnerDashboardPageState extends State<SubOwnerDashboardPage> {
  int _selectedIndex = 0;

  List<Widget> _pages = [OwnerHomePage(), OwnerOrderPage(), SubUserPage()];

  double size = 27;
  double sizeT = 30;

  @override
  Widget build(BuildContext context) {
    size = 25;
    sizeT = 12;
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        extendBody: true,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          toolbarHeight: 0,
          backgroundColor: AppColor.color_bg,
        ),
        backgroundColor: AppColor.color_bg,
        body: _pages[_selectedIndex],

        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: SizedBox(
          height: 86,
          child: BottomAppBar(
            color: AppColor.color_0C2C1C,
            notchMargin: 6.0,
            shape: const CircularNotchedRectangle(),
            child: SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ClickWidget(
                    onClick: () {
                      setState(() {
                        _selectedIndex = 0;
                      });
                    },
                    child: Column(
                      children: [
                        Image.asset(
                          width: size,
                          height: size,
                          color:
                              _selectedIndex == 0
                                  ? AppColor.white
                                  : AppColor.color_FFFFB0.withOpacity(0.2),
                          DrawableConstant.ic_t_1,
                        ),
                        TextRegular(
                          str: 'Home',
                          size: sizeT,
                          color:
                              _selectedIndex == 0
                                  ? AppColor.white
                                  : AppColor.color_FFFFB0.withOpacity(0.2),
                        ),
                      ],
                    ),
                  ),

                  ClickWidget(
                    onClick: () {
                      setState(() {
                        _selectedIndex = 1;
                      });
                    },
                    child: Column(
                      children: [
                        Image.asset(
                          width: size,
                          height: size,
                          color:
                              _selectedIndex == 1
                                  ? AppColor.white
                                  : AppColor.color_FFFFB0.withOpacity(0.2),
                          DrawableConstant.ic_tab_55,
                        ),
                        TextRegular(
                          str: 'User',
                          size: sizeT,
                          color:
                              _selectedIndex == 1
                                  ? AppColor.white
                                  : AppColor.color_FFFFB0.withOpacity(0.2),
                        ),
                      ],
                    ),
                  ),

                  ClickWidget(
                    onClick: () {
                      setState(() {
                        _selectedIndex = 2;
                      });
                    },
                    child: Column(
                      children: [
                        Image.asset(
                          width: size,
                          height: size,
                          color:
                              _selectedIndex == 2
                                  ? AppColor.white
                                  : AppColor.color_FFFFB0.withOpacity(0.2),
                          DrawableConstant.ic_tab_55,
                        ),
                        TextRegular(
                          str: 'User',
                          size: sizeT,
                          color:
                              _selectedIndex == 2
                                  ? AppColor.white
                                  : AppColor.color_FFFFB0.withOpacity(0.2),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
