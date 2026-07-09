import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dc/src/ui/detail/SubscriptionDetailPage.dart';
import 'package:flutter_dc/src/utils/time_utils.dart';
import 'package:rxdart/rxdart.dart';

import '../../../constants/color_constants.dart';
import '../../../model/base_error.dart';
import '../../../model/response/subscription/active/SubscriptionData.dart';
import '../../../model/response/subscription/active/SubscriptionResponse.dart';
import '../../../network/api_request_codes.dart';
import '../../../utils/AppStatus.dart';
import '../../../utils/app_constant.dart';
import '../../../utils/app_utils.dart';
import '../../../utils/cache_image.dart';
import '../../../utils/gap.dart';
import '../../../widget/CommonStreamBuilder.dart';
import '../../../widget/custome_card.dart';
import '../../../widget/test_bold.dart';
import '../../../widget/test_medium.dart';
import '../../../widget/test_regular.dart';
import '../../../widget/test_semi.dart';
import '../../common_bloc.dart';
import '../../shimmer/CustomShimmer.dart';

class VendorUserSubscriptionWidget extends StatefulWidget {
  final int? userId;

  const VendorUserSubscriptionWidget({Key? key, required this.userId}) : super(key: key);

  @override
  State<VendorUserSubscriptionWidget> createState() =>
      _VendorUserSubscriptionWidgetState();
}

class _VendorUserSubscriptionWidgetState extends State<VendorUserSubscriptionWidget> {
  late CommonBloc _commonBloc;
  final StreamController<List<SubscriptionData>?> _dataStream = BehaviorSubject();

  @override
  void initState() {
    super.initState();
    _commonBloc = CommonBloc(context);
    WidgetsBinding.instance.addPostFrameCallback((_) => onPostFrameCallback(context));
  }

  onPostFrameCallback(BuildContext context) {
    setObservables();
    getSubscriptionAPI();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: _widgetUserSubscription());
  }

  Widget _widgetUserSubscription() {
    return CommonStreamBuilder<List<SubscriptionData>?>(
      stream: _dataStream.stream,
      shimmer: CustomShimmer(),
      builder: (context, data) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 20),
              child: TextBold(
                str: 'User Subscription (${data?.length})'.toUpperCase(),
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
                var today = data?[index];
                return _widgetSubscriptionUI(today, data?.length);
              },
            ),
            Gap(h: 150),
          ],
        );
      },
    );
  }

  Widget _widgetSubscriptionUI(SubscriptionData? sub, int? length) {
    var product = sub?.product;
    var image = AppUtils.getFirstImage(product?.images);
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 2),
      child: InkWell(
        onTap: () async {
          await AppUtils.launchScreenWithResult(
            context,
            SubscriptionDetailPage(data: sub),
          );
          getSubscriptionAPI();
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
                          str: 'Subscription: SUB_${sub?.subNumber}',
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
                      str: AppUtils.formatStatus(sub?.product?.category),
                      max: 1,
                      color: AppColor.black,
                      size: 14,
                    ),
                    Gap(h: 5),
                    Row(
                      children: [
                        TextSemi(
                          str: TimeUtils.parseDate2(sub?.startDate),
                          max: 1,
                          color: AppColor.black,
                          size: 14,
                        ),
                        TextRegular(str: ' - '),
                        TextSemi(
                          str: TimeUtils.parseDate2(sub?.endDate),
                          max: 1,
                          color: AppColor.black,
                          size: 14,
                        ),
                      ],
                    ),
                    Gap(h: 5),
                    TextRegular(
                      str: product?.name,
                      max: 1,
                      color: AppColor.black,
                      size: 12,
                    ),
                    Gap(h: 4),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getSubscriptionAPI() {
    _commonBloc.getSubscriptionAPI(widget.userId);
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
        case ApiType.SUBSCRIPTION_LIST_BY_USER:
          {
            var res = SubscriptionResponse.fromJson(map);
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
