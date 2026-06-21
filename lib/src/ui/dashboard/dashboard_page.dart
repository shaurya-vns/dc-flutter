import 'package:flutter/material.dart';
import 'package:flutter_dc/src/ui/dashboard/menu/menu_page.dart';
import 'package:flutter_dc/src/ui/dashboard/orders/order_page.dart';
import 'package:flutter_dc/src/ui/dashboard/subscription/subscription_page.dart';

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
    MenuPage(),
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        extendBody: true,
        appBar: AppBar(toolbarHeight: 0, backgroundColor: AppColor.color_bg),
        backgroundColor: AppColor.color_bg,
        body: _pages[_selectedIndex],
        floatingActionButton: SizedBox(
          width: 80, // same width and height to retain circle
          height: 80,
          child: FloatingActionButton(
            onPressed: () {
              _onNavItemTapped(2);
            },
            backgroundColor: AppColor.trans,
            // your desired bg color
            elevation: 3,
            shape: const CircleBorder(),
            child: ClipOval(
              child: Image.asset(
                DrawableConstant.ic_ai,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: SizedBox(
          height: 70,
          child: BottomAppBar(
            color: AppColor.color_0C2C1C,
            notchMargin: 12.0,
            shape: const CircularNotchedRectangle(),
            child: Container(
              color: AppColor.trans,
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ClickWidget(
                    paddingTop: 8,
                    paddingLeft: 10,
                    paddingRight: 10,
                    onClick: () {
                      setState(() {
                        _selectedIndex = 0;
                      });
                    },
                    child: Image.asset(
                      width: 40,
                      height: 40,
                      color:
                          _selectedIndex == 0
                              ? AppColor.white
                              : AppColor.color_FFFFB0.withOpacity(0.2),
                      DrawableConstant.ic_t_1,
                    ),
                  ),
                  ClickWidget(
                    paddingTop: 8,
                    paddingLeft: 10,
                    paddingRight: 10,
                    onClick: () {
                      setState(() {
                        _selectedIndex = 1;
                      });
                    },
                    child: Image.asset(
                      width: 40,
                      height: 40,
                      color:
                          _selectedIndex == 1
                              ? AppColor.white
                              : AppColor.color_FFFFB0.withOpacity(0.2),
                      DrawableConstant.ic_t_2,
                    ),
                  ),
                  SizedBox(width: 48), // space for the FAB
                  ClickWidget(
                    paddingTop: 8,
                    paddingLeft: 10,
                    paddingRight: 10,
                    onClick: () {
                      setState(() {
                        _selectedIndex = 3;
                      });
                    },
                    child: Image.asset(
                      width: 40,
                      height: 40,
                      color:
                          _selectedIndex == 3
                              ? AppColor.white
                              : AppColor.color_FFFFB0.withOpacity(0.2),
                      DrawableConstant.ic_t_3,
                    ),
                  ),
                  ClickWidget(
                    paddingTop: 8,
                    paddingLeft: 10,
                    paddingRight: 10,
                    onClick: () {
                      setState(() {
                        _selectedIndex = 4;
                      });
                    },
                    child: Image.asset(
                      width: 40,
                      height: 40,
                      color:
                          _selectedIndex == 4
                              ? AppColor.white
                              : AppColor.color_FFFFB0.withOpacity(0.2),
                      DrawableConstant.ic_t_4,
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
