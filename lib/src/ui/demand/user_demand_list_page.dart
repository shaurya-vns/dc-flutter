import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dc/src/constants/color_constants.dart';
import 'package:flutter_dc/src/mixin/BaseMixin.dart';
import 'package:flutter_dc/src/model/response/ondemand/list/OnDemandData.dart';
import 'package:flutter_dc/src/ui/demand/add_demand_page.dart';
import 'package:flutter_dc/src/utils/AppStatus.dart';
import 'package:flutter_dc/src/utils/app_utils.dart';
import 'package:flutter_dc/src/utils/ext.dart';
import 'package:flutter_dc/src/utils/time_utils.dart';
import 'package:flutter_dc/src/widget/custome_card.dart';
import 'package:flutter_dc/src/widget/fill_button_widget.dart';
import 'package:flutter_dc/src/widget/scaffold_widget.dart';
import 'package:flutter_dc/src/widget/test_regular.dart';
import 'package:flutter_dc/src/widget/test_semi.dart';
import 'package:rxdart/rxdart.dart';

import '../../model/base_error.dart';
import '../../model/response/ondemand/list/OnDemandResponse.dart';
import '../../network/api_request_codes.dart';
import '../../utils/app_constant.dart';
import '../../widget/CommonStreamBuilder.dart';
import '../../widget/test_bold.dart';
import '../common_bloc.dart';
import '../shimmer/CustomShimmer.dart';
import 'UserDemandDetailPage.dart';

class UserDemandPageList extends StatefulWidget {
  const UserDemandPageList({Key? key}) : super(key: key);

  @override
  State<UserDemandPageList> createState() => _UserDemandPageListState();
}

class _UserDemandPageListState extends State<UserDemandPageList> with BaseMixin {
  late CommonBloc _commonBloc;
  final StreamController<List<OnDemandData>?> _dataStream = BehaviorSubject();

  @override
  void initState() {
    super.initState();
    _commonBloc = CommonBloc(context);
    WidgetsBinding.instance.addPostFrameCallback((_) => onPostFrameCallback(context));
  }

  onPostFrameCallback(BuildContext context) {
    setObservables();
    getOnDemandListAPI();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      title: 'User On Demand Order List',
      onSwipe: () {
        getOnDemandListAPI();
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 1, right: 1),
        child: _widgetUI(),
      ),
      bottom: _widgetBottomUI(),
    );
  }

  Widget _widgetUI() {
    return CommonStreamBuilder<List<OnDemandData>?>(
      stream: _dataStream.stream,
      shimmer: CustomShimmer(),
      builder: (context, data) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: TextBold(
                str: 'On Demand Orders (${data?.length})'.toUpperCase(),
                size: 14,
                color: AppColor.black,
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: AppUtils.getLength(data?.length),
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                var demand = data?[index];
                return _widgetOnDemandCard(demand);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _widgetOnDemandCard(OnDemandData? data) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: InkWell(
        onTap: () async {
          await AppUtils.launchScreenWithResult(
            context,
            UserDemandDetailPage(data: data),
          );
          getOnDemandListAPI();
        },
        child: CustomCard(
          child: Column(
            children: [
              /// Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      height: 52,
                      width: 52,
                      decoration: BoxDecoration(
                        color: const Color(0xffFFF4EC),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.restaurant_menu, color: Color(0xffFF6B35)),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextSemi(str: data?.itemName, size: 16),
                          TextSemi(
                            str: 'Order# ${data?.orderNumber}',
                            size: 12,
                            color: AppColor.color_B0B0B0,
                          ),
                        ],
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        AppStatus.getStatus(data?.status),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 18, color: Colors.grey),
                        SizedBox(width: 8),
                        Expanded(
                          child: TextSemi(str: TimeUtils.parseDate2(data?.deliveryDate)),
                        ),
                        Icon(Icons.lunch_dining, size: 18, color: Colors.orange),
                        SizedBox(width: 4),
                        TextRegular(str: data?.mealType?.toTitleCase(), size: 14),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.shopping_bag_outlined, size: 18, color: Colors.grey),
                        SizedBox(width: 8),
                        Text(
                          "Qty : ${data?.quantity}",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    _priceCard(
                      expectedPrice: AppUtils.getDouble2(data?.userAmount),
                      vendorPrice: AppUtils.getDouble2(data?.vendorAmount),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.location_on, color: Colors.red, size: 18),
                        SizedBox(width: 8),
                        Expanded(
                          child: TextRegular(
                            str: data?.addressDetail?.fullAddress,
                            size: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.notes, color: Colors.orange, size: 18),
                          SizedBox(width: 8),
                          Expanded(child: TextRegular(str: data?.note)),
                        ],
                      ),
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

  Widget _priceCard({required double? expectedPrice, double? vendorPrice}) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.orange.shade100),
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Icon(Icons.account_balance_wallet_outlined, color: Colors.orange, size: 20),
              SizedBox(width: 8),
              Text(
                "Price Details",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Expanded(child: TextRegular(str: "User Amount", size: 14)),
              TextSemi(str: AppUtils.formatPrice(expectedPrice)),
            ],
          ),
          if (vendorPrice == 0)
            ...[]
          else ...[
            Row(
              children: [
                const Expanded(child: TextRegular(str: "Vendor Price", size: 14)),
                TextSemi(str: AppUtils.formatPrice(vendorPrice)),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _widgetBottomUI() {
    return Container(
      padding: const EdgeInsets.only(left: 40, bottom: 20, top: 20, right: 40),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black12)],
      ),
      child: SafeArea(
        child: FillButtonWidget(
          title: 'Request On Demand Order',
          onPressed: () async {
            await AppUtils.launchScreenWithResult(context, AddDemandPage());
            getOnDemandListAPI();
          },
        ),
      ),
    );
  }

  void getOnDemandListAPI() {
    _commonBloc.getOnDemandListAPI(USER_DATA?.id);
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
        case ApiType.ON_DEMAND_LIST:
          {
            var res = OnDemandResponse.fromJson(map);
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
