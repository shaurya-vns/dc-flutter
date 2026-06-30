import 'package:flutter/material.dart';

import '../../../constants/color_constants.dart';
import '../../../model/base_error.dart';
import '../../../utils/app_constant.dart';
import '../../../utils/app_utils.dart';
import '../../../utils/gap.dart';
import '../../../widget/test_semi.dart';
import '../../common_bloc.dart';

class MenuWidget extends StatefulWidget {
  const MenuWidget({Key? key}) : super(key: key);

  @override
  State<MenuWidget> createState() => _MenuWidgetState();
}

class _MenuWidgetState extends State<MenuWidget> {
  late CommonBloc _commonBloc;

  @override
  void initState() {
    super.initState();
    _commonBloc = CommonBloc(context);
    WidgetsBinding.instance.addPostFrameCallback((_) => onPostFrameCallback(context));
  }

  onPostFrameCallback(BuildContext context) {
    setObservables();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _widgetMenu(),
        _widgetMenuList(),
        Gap(h: 10),
        _widgetSatSunMenu(),
        _widgetMenuSFList(),
        Gap(h: 200),
      ],
    );
  }

  Widget _widgetMenu() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 20, bottom: 10),
      child: TextSemi(
        str: 'Monday to friday'.toUpperCase(),
        color: AppColor.black,
        size: 16,
      ),
    );
  }

  Widget _widgetMenuList() {
    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 0),
      child: Container(
        padding: EdgeInsets.all(0),
        color: AppColor.black.withOpacity(0.5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _widgetDay(),
                _widgetWeek('Mon', AppColor.color_1E6F46),
                _widgetWeek('Tue', AppColor.color_1E6F46),
                _widgetWeek('Wed', AppColor.color_1E6F46),
                _widgetWeek('Thu', AppColor.color_1E6F46),
                _widgetWeek('Fri', AppColor.color_1E6F46),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  children: [
                    _widgetType(),
                    _widgetMeal(
                      'Plan paratha, dal, rice',
                      'Plan paratha, dal, rice',
                      'Plan paratha, dal, rice',
                      AppColor.white,
                    ),
                    _widgetMeal(
                      'Plan paratha, dal, rice',
                      'Plan paratha, dal, rice',
                      'Plan paratha, dal, rice',
                      AppColor.white,
                    ),
                    _widgetMeal(
                      'Plan paratha, dal, rice',
                      'Plan paratha, dal, rice',
                      'Plan paratha, dal, rice',
                      AppColor.white,
                    ),
                    _widgetMeal(
                      'Plan paratha, dal, rice',
                      'Plan paratha, dal, rice',
                      'Plan paratha, dal, rice',
                      AppColor.white,
                    ),
                    _widgetMeal(
                      'Plan paratha, dal, rice',
                      'Plan paratha, dal, rice',
                      'Plan paratha, dal, rice',
                      AppColor.white,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _widgetSatSunMenu() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 20, bottom: 10),
      child: TextSemi(
        str: 'Saturday & Sunday -  Special Menu'.toUpperCase(),
        color: AppColor.black,
        size: 16,
      ),
    );
  }

  Widget _widgetMenuSFList() {
    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 0),
      child: Container(
        padding: EdgeInsets.all(0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColor.colorBlue, AppColor.white],
          ),
          boxShadow: [
            BoxShadow(color: Color(0x33FF5722), blurRadius: 20, offset: Offset(0, 10)),
          ],
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _widgetDay(),
                _widgetWeek('Sat', AppColor.color_1E6F46),
                _widgetWeek('Sun', AppColor.color_1E6F46),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  children: [
                    _widgetType(),

                    _widgetMeal(
                      'Plan paratha, dal, rice',
                      'Plan paratha, dal, rice',
                      'Plan paratha, dal, rice',
                      AppColor.white,
                    ),
                    _widgetMeal(
                      'Plan paratha, dal, rice',
                      'Plan paratha, dal, rice',
                      'Plan paratha, dal, rice',
                      AppColor.white,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _widgetDay() {
    return Padding(
      padding: const EdgeInsets.all(0.5),
      child: Container(
        height: 60,
        alignment: Alignment.center,
        width: 80,
        color: AppColor.red,
        child: TextSemi(str: 'Day'.toUpperCase(), color: AppColor.white, size: 13),
      ),
    );
  }

  Widget _widgetMeal(String str1, String str2, String str3, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(0.3),
          child: Container(
            height: 100,
            color: color,
            alignment: Alignment.center,
            width: 140,
            padding: EdgeInsets.all(2),
            child: TextSemi(align: 2, str: str1, color: AppColor.black, size: 13),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(0.3),
          child: Container(
            height: 100,
            padding: EdgeInsets.all(2),
            color: color,
            alignment: Alignment.center,
            width: 140,
            child: TextSemi(align: 2, str: str2, color: AppColor.black, size: 13),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(0.3),
          child: Container(
            height: 100,
            padding: EdgeInsets.all(2),
            color: color,
            alignment: Alignment.center,
            width: 140,
            child: TextSemi(align: 2, str: str3, color: AppColor.black, size: 13),
          ),
        ),
      ],
    );
  }

  Widget _widgetType() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(height: 60, width: 0.4, color: AppColor.white),
        Container(
          height: 60,
          color: AppColor.color_D25B17,
          alignment: Alignment.center,
          width: 140,
          child: TextSemi(
            str: 'Breakfast'.toUpperCase(),
            color: AppColor.white,
            size: 13,
          ),
        ),
        Container(height: 60, width: 0.4, color: AppColor.white),
        Container(
          height: 60,
          color: AppColor.color_156CD7,
          alignment: Alignment.center,
          width: 140,
          child: TextSemi(str: 'Lunch'.toUpperCase(), color: AppColor.white, size: 13),
        ),
        Container(height: 60, width: 0.4, color: AppColor.white),
        Container(
          height: 60,
          color: AppColor.color_F4C102,
          alignment: Alignment.center,
          width: 140,
          child: TextSemi(str: 'Dinner'.toUpperCase(), color: AppColor.white, size: 13),
        ),
      ],
    );
  }

  Widget _widgetWeek(String w, Color color) {
    return Padding(
      padding: const EdgeInsets.all(0.5),
      child: Container(
        color: color,
        width: 80,
        height: 99,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.calendar_month, size: 18, color: AppColor.white),
              Gap(h: 2),
              TextSemi(str: w.toUpperCase(), color: AppColor.white, size: 13),
            ],
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
    _commonBloc.apiResponse.listen((map) {
      var apiType = map[AppConstants.API_TYPE];

      switch (apiType) {}
    });

    _commonBloc.apiError.listen((error) {
      var baseError = BaseError.fromJson(error);
      AppUtils.showToast(baseError.message);
    });
    //validation error listener
  }
}
