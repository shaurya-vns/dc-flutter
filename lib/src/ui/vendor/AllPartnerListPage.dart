import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dc/src/widget/custome_card.dart';
import 'package:flutter_dc/src/widget/test_regular.dart';
import 'package:flutter_dc/src/widget/test_semi.dart';
import 'package:rxdart/rxdart.dart';

import '../../constants/color_constants.dart';
import '../../model/base_error.dart';
import '../../model/response/delivery/list/UserListResponse.dart';
import '../../model/response/user/UserData.dart';
import '../../network/api_request_codes.dart';
import '../../utils/app_constant.dart';
import '../../utils/app_utils.dart';
import '../../utils/gap.dart';
import '../../utils/widgetUtils.dart';
import '../../widget/CommonStreamBuilder.dart';
import '../../widget/scaffold_widget.dart';
import '../../widget/test_bold.dart';
import '../common_bloc.dart';
import '../shimmer/CustomShimmer.dart';

class AllPartnerListPage extends StatefulWidget {
  const AllPartnerListPage({super.key});

  @override
  State<AllPartnerListPage> createState() => _AllPartnerListPageState();
}

class _AllPartnerListPageState extends State<AllPartnerListPage> {
  late CommonBloc _commonBloc;
  final StreamController<List<UserData>?> _dataStream = BehaviorSubject();

  @override
  void initState() {
    super.initState();
    _commonBloc = CommonBloc(context);
    WidgetsBinding.instance.addPostFrameCallback((_) => onPostFrameCallback(context));
  }

  onPostFrameCallback(BuildContext context) {
    setObservables();
    getDeliveryListAPI();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      title: 'All Delivery Partners',
      isBottom: false,
      onSwipe: () {
        getDeliveryListAPI();
      },
      child: SingleChildScrollView(child: _widgetSubTodayOrder()),
    );
  }

  Widget _widgetSubTodayOrder() {
    return CommonStreamBuilder<List<UserData>?>(
      stream: _dataStream.stream,
      shimmer: CustomShimmer(),
      nothing: WidgetUtils.noOrderWidget(
        title: "No delivery partner Yet",
        message:
            "Please add delivery partner to manage your order, subscription and on demand",

        onRefresh: () {
          getDeliveryListAPI();
        },
      ),
      builder: (context, data) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: TextBold(
                str: 'My Delivery Partner (${data?.length})'.toUpperCase(),
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
                var delivery = data?[index];
                return _deliveryHeaderCard(delivery);
              },
            ),
            Gap(h: 150),
          ],
        );
      },
    );
  }

  Widget _deliveryHeaderCard(UserData? data) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: CustomCard(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              /// Header
              Row(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 26,
                        backgroundColor: Colors.green,
                        child: TextRegular(
                          str: AppUtils.getFirstValue(data?.name),
                          color: AppColor.white,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextSemi(str: data?.name ?? "", size: 17),
                        Gap(h: 4),
                        Row(
                          children: [
                            const Icon(Icons.phone, size: 16, color: Colors.black),
                            const SizedBox(width: 6),
                            Expanded(
                              child: TextRegular(
                                size: 13,
                                str: data?.phoneNumber,
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
            ],
          ),
        ),
      ),
    );
  }

  void getDeliveryListAPI() {
    _commonBloc.getDeliveryListAPI();
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
        case ApiType.DELIVERY_LIST:
          {
            var res = UserListResponse.fromJson(map);
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
