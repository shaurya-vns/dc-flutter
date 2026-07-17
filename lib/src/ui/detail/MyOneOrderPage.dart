import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../../constants/color_constants.dart';
import '../../model/base_error.dart';
import '../../model/response/order/one/OneTimeOrderData.dart';
import '../../model/response/order/one/OneTimeOrderResponse.dart';
import '../../network/api_request_codes.dart';
import '../../utils/app_constant.dart';
import '../../utils/app_utils.dart';
import '../../utils/gap.dart';
import '../../utils/widgetUtils.dart';
import '../../widget/CommonStreamBuilder.dart';
import '../../widget/scaffold_widget.dart';
import '../../widget/test_bold.dart';
import '../common_bloc.dart';
import '../dashboard/custom/one_time_item_widget.dart';
import '../shimmer/CustomShimmer.dart';

class MyOneOrderPage extends StatefulWidget {
  const MyOneOrderPage({super.key});

  @override
  State<MyOneOrderPage> createState() => _MyOneOrderPageState();
}

class _MyOneOrderPageState extends State<MyOneOrderPage> {
  late CommonBloc _commonBloc;
  final StreamController<List<OneTimeOrderData>?> _dataStream = BehaviorSubject();

  @override
  void initState() {
    super.initState();
    _commonBloc = CommonBloc(context);
    WidgetsBinding.instance.addPostFrameCallback((_) => onPostFrameCallback(context));
  }

  onPostFrameCallback(BuildContext context) {
    setObservables();
    getOneTimeOrderListAPI();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      title: 'My One Time Orders',
      isBottom: false,
      onSwipe: () {
        getOneTimeOrderListAPI();
      },
      child: SingleChildScrollView(child: _widgetSubTodayOrder()),
    );
  }

  Widget _widgetSubTodayOrder() {
    return CommonStreamBuilder<List<OneTimeOrderData>?>(
      stream: _dataStream.stream,
      shimmer: CustomShimmer(),
      nothing: WidgetUtils.noOrderWidget(
        title: "No Orders Yet",
        message:
            "You don't have any orders for today.\nNew orders will appear here automatically.",

        onRefresh: () {
          getOneTimeOrderListAPI();
        },
      ),
      builder: (context, data) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: TextBold(
                str: 'My Orders (${data?.length})'.toUpperCase(),
                size: 14,
                color: AppColor.black,
              ),
            ),
            Gap(h: 7),
            ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: AppUtils.getLength(data?.length),
              scrollDirection: Axis.vertical,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                var oneTimeOrder = data?[index];
                return OneTimeOrderWidget(oneTimeOrder: oneTimeOrder);
              },
            ),
            Gap(h: 150),
          ],
        );
      },
    );
  }

  void getOneTimeOrderListAPI() {
    _commonBloc.getOneTimeOrderListAPI(USER_DATA?.id);
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
        case ApiType.ONE_TIME_ORDER_LIST:
          {
            var res = OneTimeOrderResponse.fromJson(map);
            _dataStream.sink.add(res.data);
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
