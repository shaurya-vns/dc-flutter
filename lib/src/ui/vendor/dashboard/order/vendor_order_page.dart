import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dc/src/constants/drawable_constant.dart';
import 'package:flutter_dc/src/widget/click_widget.dart';
import 'package:flutter_dc/src/widget/fix_button_widget.dart';
import 'package:flutter_dc/src/widget/test_regular.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../constants/color_constants.dart';
import '../../../../model/base_error.dart';
import '../../../../model/response/order/sub/SubTodayOrderData.dart';
import '../../../../model/response/order/sub/SubTodayOrderResponse.dart';
import '../../../../network/api_request_codes.dart';
import '../../../../utils/AppStatus.dart';
import '../../../../utils/app_constant.dart';
import '../../../../utils/app_utils.dart';
import '../../../../utils/cache_image.dart';
import '../../../../utils/ext.dart';
import '../../../../utils/gap.dart';
import '../../../../widget/CommonStreamBuilder.dart';
import '../../../../widget/custome_card.dart';
import '../../../../widget/test_bold.dart';
import '../../../../widget/test_medium.dart';
import '../../../../widget/test_semi.dart';
import '../../../common_bloc.dart';
import '../../../detail/SubscriptionOrderDetailPage.dart';
import '../../../shimmer/CustomShimmer.dart';

class VendorOrderPage extends StatefulWidget {
  const VendorOrderPage({Key? key}) : super(key: key);

  @override
  State<VendorOrderPage> createState() => _VendorOrderPageState();
}

class _VendorOrderPageState extends State<VendorOrderPage> {
  late CommonBloc _commonBloc;

  final StreamController<List<SubTodayOrderData>?> _todayAllSubOrderStream =
      BehaviorSubject();

  @override
  void initState() {
    super.initState();
    _commonBloc = CommonBloc(context);
    WidgetsBinding.instance.addPostFrameCallback((_) => onPostFrameCallback(context));
  }

  onPostFrameCallback(BuildContext context) {
    setObservables();
    getAllSubOrderList();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: Column(children: [_widgetTodayOrder()]));
  }

  Widget _widgetTodayOrder() {
    return CommonStreamBuilder<List<SubTodayOrderData>?>(
      stream: _todayAllSubOrderStream.stream,
      shimmer: CustomShimmer(),
      nothing: Container(
        height: 300,
        alignment: Alignment.center,
        child: TextSemi(str: 'No data found yet'),
      ),
      builder: (context, data) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: TextBold(
                str: 'Today Subscription Order (${data?.length})',
                size: 16,
                color: AppColor.black,
              ),
            ),
            Gap(h: 3),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: AppUtils.getLength(data?.length),
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                var today = data?[index];
                return _widgetTodayItemUI(today);
              },
            ),
            Gap(h: 10),
          ],
        );
      },
    );
  }

  Widget _widgetTodayItemUI(SubTodayOrderData? sub) {
    var product = sub?.subscription?.product;
    var image = AppUtils.getFirstImage(product?.images);
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 2),
      child: InkWell(
        onTap: () async {
          await AppUtils.launchScreenWithResult(
            context,
            SubscriptionOrderDetailPage(data: sub),
          );
          getAllSubOrderList();
        },
        child: CustomCard(
          rounded: 5,
          color: AppColor.white,
          child: Row(
            children: [
              CacheImage(url: image, w: 90, h: 90),
              Gap(w: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        TextMedium(
                          str: 'Order Id: ${sub?.id}',
                          max: 1,
                          color: AppColor.black,
                          size: 14,
                        ),
                        Expanded(
                          child: TextMedium(
                            str: AppStatus.getStatus(sub?.status),
                            max: 1,
                            align: 1,
                            color: AppColor.colorBlue,
                            size: 12,
                          ),
                        ),
                        Gap(w: 10),
                      ],
                    ),
                    TextSemi(
                      str: AppUtils.formatStatus(product?.category),
                      max: 1,
                      color: AppColor.black,
                      size: 14,
                    ),
                    Row(
                      children: [
                        TextRegular(
                          str: product?.name,
                          max: 1,
                          color: AppColor.black,
                          size: 12,
                        ),
                        Gap(w: 10),
                        TextSemi(str: '|', color: AppColor.black, size: 12),
                        Gap(w: 6),
                        TextMedium(
                          str: sub?.mealType?.toTitleCase(),
                          color: AppColor.black,
                          size: 13,
                        ),
                      ],
                    ),
                    Gap(h: 4),
                    Row(
                      children: [
                        Expanded(
                          child: TextRegular(
                            str: AppUtils.getMealSummary(sub?.mealType, sub?.quantity),
                            size: 13,
                            color: AppColor.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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

  void getAllSubOrderList() {
    _commonBloc.getAllSubOrderList();
  }

  @override
  void dispose() {
    _commonBloc.onDispose();
    super.dispose();
  }

  void setObservables() {
    _commonBloc.apiResponse.listen((map) {
      var apiType = map[AppConstants.API_TYPE];

      switch (apiType) {
        case ApiType.SUB_OWNER_TODAY_ALL_ORDER:
          {
            var res = SubTodayOrderResponse.fromJson(map);
            _todayAllSubOrderStream.sink.add(res.data);
          }
      }
    });

    _commonBloc.apiError.listen((error) {
      var baseError = BaseError.fromJson(error);
      AppUtils.showToast(baseError.message);
    });
    //validation error listener
  }
}
