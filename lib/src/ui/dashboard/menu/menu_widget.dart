import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dc/src/ui/detail/CategoryPage.dart';
import 'package:flutter_dc/src/widget/fix_button_widget.dart';
import 'package:rxdart/rxdart.dart';

import '../../../constants/color_constants.dart';
import '../../../model/response/product/ProductModel.dart';
import '../../../utils/app_utils.dart';
import '../../../utils/gap.dart';
import '../../../widget/CommonStreamBuilder.dart';
import '../../../widget/test_semi.dart';
import '../../detail/create_subscription_page.dart';
import '../../shimmer/CustomShimmer.dart';

class MenuWidget extends StatefulWidget {
  final List<ProductModel>? products;

  const MenuWidget({Key? key, required this.products}) : super(key: key);

  @override
  State<MenuWidget> createState() => _MenuWidgetState();
}

class _MenuWidgetState extends State<MenuWidget> {
  final StreamController<Map<String, List<ProductModel>>> _dataStream = BehaviorSubject();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => onPostFrameCallback(context));
  }

  Map<String, List<ProductModel>> weekPlanType = {};

  onPostFrameCallback(BuildContext context) {
    weekPlanType = {};

    for (final product in widget.products ?? []) {
      // breakfast_lunch -> [breakfast, lunch]
      final meals = product.planType.split('_');

      for (final meal in meals) {
        final key = '${product.day}_$meal';

        weekPlanType.putIfAbsent(key, () => []);
        weekPlanType[key]!.add(product);
      }
    }

    _dataStream.sink.add(weekPlanType);
  }

  @override
  Widget build(BuildContext context) {
    return CommonStreamBuilder<Map<String, List<ProductModel>>>(
      stream: _dataStream.stream,
      shimmer: CustomShimmer(),
      builder: (context, data) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _widgetMenu(),
            _widgetMenuMFList(),
            Gap(h: 10),
            _widgetSatSunMenu(),
            _widgetMenuSFList(),
            Gap(h: 200),
          ],
        );
      },
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

  Widget _widgetMenuMFList() {
    var mb = getPlan(weekPlanType['mon_breakfast']);
    var ml = getPlan(weekPlanType['mon_lunch']);
    var md = getPlan(weekPlanType['mon_dinner']);

    // Tuesday
    var tub = getPlan(weekPlanType['tue_breakfast']);
    var tul = getPlan(weekPlanType['tue_lunch']);
    var tud = getPlan(weekPlanType['tue_dinner']);

    // Wednesday
    var wb = getPlan(weekPlanType['wed_breakfast']);
    var wl = getPlan(weekPlanType['wed_lunch']);
    var wd = getPlan(weekPlanType['wed_dinner']);

    // Thursday
    var thb = getPlan(weekPlanType['thu_breakfast']);
    var thl = getPlan(weekPlanType['thu_lunch']);
    var thd = getPlan(weekPlanType['thu_dinner']);

    // Friday
    var fb = getPlan(weekPlanType['fri_breakfast']);
    var fl = getPlan(weekPlanType['fri_lunch']);
    var fd = getPlan(weekPlanType['fri_dinner']);

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

                    // Monday
                    _widgetMeal(mb, ml, md, AppColor.white),

                    // Tuesday
                    _widgetMeal(tub, tul, tud, AppColor.white),

                    // Wednesday
                    _widgetMeal(wb, wl, wd, AppColor.white),

                    // Thursday
                    _widgetMeal(thb, thl, thd, AppColor.white),

                    // Friday
                    _widgetMeal(fb, fl, fd, AppColor.white),
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
    // Saturday
    var sab = getPlan(weekPlanType['sat_breakfast']);
    var sal = getPlan(weekPlanType['sat_lunch']);
    var sad = getPlan(weekPlanType['sat_dinner']);

    // Sunday
    var sub = getPlan(weekPlanType['sun_breakfast']);
    var sul = getPlan(weekPlanType['sun_lunch']);
    var sud = getPlan(weekPlanType['sun_dinner']);

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
                    _widgetMeal(sab, sal, sad, AppColor.white),
                    _widgetMeal(sub, sul, sud, AppColor.white),
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

  Widget _widgetMeal(
    List<ProductModel>? p1,
    List<ProductModel>? p2,
    List<ProductModel>? p3,
    Color color,
  ) {
    var name1 = getName(p1);
    var name2 = getName(p2);
    var name3 = getName(p3);

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(0.3),
          child: FixButtonWidget(
            radius: 0,
            borderColor: AppColor.trans,
            height: 100,
            color: color,
            width: 140,
            onPressed: () {},
            child: TextSemi(align: 2, str: name1, color: AppColor.black, size: 12),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(0.3),
          child: FixButtonWidget(
            height: 100,
            radius: 0,
            borderColor: AppColor.trans,
            color: color,
            width: 140,
            onPressed: () {
              print('SSSS ee ${name2}');
            },
            child: TextSemi(align: 2, str: name2, color: AppColor.black, size: 12),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(0.3),
          child: FixButtonWidget(
            height: 100,
            radius: 0,
            borderColor: AppColor.trans,
            color: color,
            width: 140,
            onPressed: () {
              print('SSSS ee ${name3}');
            },
            child: TextSemi(align: 2, str: name3, color: AppColor.black, size: 12),
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

  List<ProductModel>? getPlan(List<ProductModel>? p) {
    return p;
  }

  String? getName(List<ProductModel>? p) {
    if (p != null && p.isNotEmpty == true) {
      return p[0].name;
    }
    return 'No plan yet';
  }
}
