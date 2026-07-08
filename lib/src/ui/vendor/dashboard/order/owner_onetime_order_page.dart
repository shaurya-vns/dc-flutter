import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dc/src/widget/test_regular.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../constants/color_constants.dart';
import '../../../../model/base_error.dart';
import '../../../../model/response/order/one/OneTimeOrderData.dart';
import '../../../../model/response/order/one/OneTimeOrderResponse.dart';
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
import '../../../detail/OneTimeOrderDetailPage.dart';
import '../../../shimmer/CustomShimmer.dart';

class OwnerOneTimeOrderPage extends StatefulWidget {
  const OwnerOneTimeOrderPage({Key? key}) : super(key: key);

  @override
  State<OwnerOneTimeOrderPage> createState() => _OwnerOneTimeOrderPageState();
}

class _OwnerOneTimeOrderPageState extends State<OwnerOneTimeOrderPage> {
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
    getAllOneTimeOrderList();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: Column(children: [_widgetTodayOrder()]));
  }

  Widget _widgetTodayOrder() {
    return CommonStreamBuilder<List<OneTimeOrderData>?>(
      stream: _dataStream.stream,
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
                str: 'One Time Order (${data?.length})',
                size: 16,
                color: AppColor.black,
              ),
            ),
            Gap(h: 10),

            Gap(h: 10),
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

  Widget _widgetTodayItemUI(OneTimeOrderData? sub) {
    var product = sub?.product;
    var image = AppUtils.getFirstImage(product?.images);
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 2),
      child: InkWell(
        onTap: () {
          AppUtils.launchScreen(context, OneTimeOrderDetailPage(data: sub));
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
                          size: 14,
                        ),
                        Gap(w: 10),
                        TextSemi(str: '|', color: AppColor.black, size: 14),
                        Gap(w: 6),
                        TextMedium(
                          str: sub?.mealType?.toTitleCase(),
                          color: AppColor.black,
                          size: 14,
                        ),
                      ],
                    ),
                    Gap(h: 4),
                    TextRegular(
                      str: AppUtils.getMealSummary(sub?.mealType, sub?.quantity),
                      size: 13,
                      color: AppColor.black,
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

  void getAllOneTimeOrderList() {
    _commonBloc.getAllOneTimeOrderList();
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
        case ApiType.SUB_OWNER_ONE_TIME_ALL_ORDER:
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
