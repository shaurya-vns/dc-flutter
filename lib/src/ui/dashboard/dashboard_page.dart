import 'package:flutter/material.dart';
import 'package:flutter_dc/src/ui/dashboard/menu/menu_page.dart';
import 'package:flutter_dc/src/ui/dashboard/orders/order_page.dart';
import 'package:flutter_dc/src/ui/dashboard/profile/profile_page.dart';
import 'package:flutter_dc/src/ui/dashboard/subscription/subscription_page.dart';
import 'package:flutter_dc/src/widget/test_regular.dart';

import '../../constants/color_constants.dart';
import '../../constants/drawable_constant.dart';
import '../../model/base_error.dart';
import '../../utils/app_constant.dart';
import '../../utils/app_utils.dart';
import '../../widget/click_widget.dart';
import '../common_bloc.dart';
import 'ai/ai_page.dart';
import 'home/home_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late CommonBloc _commonBloc;

  int _selectedIndex = 0;

  List<Widget> _pages = [
    HomePage(),
    SubscriptionPage(),
    AIPage(),
    OrderPage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();

    _commonBloc = CommonBloc(context);
    WidgetsBinding.instance.addPostFrameCallback((_) => onPostFrameCallback(context));
  }

  onPostFrameCallback(BuildContext context) {
    setObservables();
    _getToken();
  }

  void _getToken() async {}

  void _onNavItemTapped(int idx) {
    setState(() {
      _selectedIndex = idx;
    });
  }

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
        floatingActionButton: SizedBox(
          width: 60, // same width and height to retain circle
          height: 60,
          child: FloatingActionButton(
            onPressed: () {
              _onNavItemTapped(2);
            },
            backgroundColor: AppColor.trans,
            // your desired bg color
            elevation: 2,
            shape: const CircleBorder(),
            child: ClipOval(
              child: Image.asset(
                DrawableConstant.ic_ai,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
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
                          DrawableConstant.ic_t_2,
                        ),
                        TextRegular(
                          str: 'Plan',
                          size: sizeT,
                          color:
                              _selectedIndex == 1
                                  ? AppColor.white
                                  : AppColor.color_FFFFB0.withOpacity(0.2),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 50), // space for the FAB
                  ClickWidget(
                    onClick: () {
                      setState(() {
                        _selectedIndex = 3;
                      });
                    },
                    child: Column(
                      children: [
                        Image.asset(
                          width: size,
                          height: size,
                          color:
                              _selectedIndex == 3
                                  ? AppColor.white
                                  : AppColor.color_FFFFB0.withOpacity(0.2),
                          DrawableConstant.ic_t_3,
                        ),
                        TextRegular(
                          str: 'Order',
                          size: sizeT,
                          color:
                              _selectedIndex == 3
                                  ? AppColor.white
                                  : AppColor.color_FFFFB0.withOpacity(0.2),
                        ),
                      ],
                    ),
                  ),
                  ClickWidget(
                    onClick: () {
                      setState(() {
                        _selectedIndex = 4;
                      });
                    },
                    child: Column(
                      children: [
                        Image.asset(
                          width: size,
                          height: size,
                          color:
                              _selectedIndex == 4
                                  ? AppColor.white
                                  : AppColor.color_FFFFB0.withOpacity(0.2),
                          DrawableConstant.ic_t_4,
                        ),
                        TextRegular(
                          str: 'Profile',
                          size: sizeT,
                          color:
                              _selectedIndex == 4
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

  @override
  void dispose() {
    _commonBloc.onDispose();
    super.dispose();
  }

  void setObservables() {
    //success listener
    _commonBloc.apiResponse.listen((map) {
      var apiType = map[AppConstants.API_TYPE];
    });
    //error listener
    _commonBloc.apiError.listen((error) {
      var baseError = BaseError.fromJson(error);
      AppUtils.showToast(baseError.message);
    });
    //validation error listener
  }
}
