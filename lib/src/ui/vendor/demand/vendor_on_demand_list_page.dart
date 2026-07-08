import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dc/src/constants/color_constants.dart';
import 'package:flutter_dc/src/mixin/BaseMixin.dart';
import 'package:flutter_dc/src/utils/AppStatus.dart';
import 'package:flutter_dc/src/utils/app_utils.dart';
import 'package:flutter_dc/src/utils/ext.dart';
import 'package:flutter_dc/src/utils/time_utils.dart';
import 'package:flutter_dc/src/widget/rounded_container.dart';
import 'package:flutter_dc/src/widget/scaffold_widget.dart';
import 'package:flutter_dc/src/widget/test_regular.dart';
import 'package:flutter_dc/src/widget/test_semi.dart';
import 'package:rxdart/rxdart.dart';

import '../../../model/base_error.dart';
import '../../../model/response/ondemand/list/OnDemandData.dart';
import '../../../model/response/ondemand/list/OnDemandResponse.dart';
import '../../../network/api_request_codes.dart';
import '../../../utils/app_constant.dart';
import '../../../utils/gap.dart';
import '../../../widget/CommonStreamBuilder.dart';
import '../../../widget/test_bold.dart';
import '../../common_bloc.dart';
import '../../shimmer/CustomShimmer.dart';
import 'VendorOnDemandDetailPage.dart';

class VendorOnDemandPageList extends StatefulWidget {
  const VendorOnDemandPageList({Key? key}) : super(key: key);

  @override
  State<VendorOnDemandPageList> createState() => _VendorOnDemandPageListState();
}

class _VendorOnDemandPageListState extends State<VendorOnDemandPageList> with BaseMixin {
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
      title: 'User Demand Request',
      onSwipe: () {
        getOnDemandListAPI();
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 1, right: 1),
        child: _widgetUI(),
      ),
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
            Gap(h: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: AppUtils.getLength(data?.length),
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                var demand = data?[index];
                return InkWell(
                  onTap: () async {
                    await AppUtils.launchScreenWithResult(
                      context,
                      VendorOnDemandDetailPage(demand: demand),
                    );

                    getOnDemandListAPI();
                  },
                  child: vendorOnDemandCard(
                    foodName: demand?.itemName,
                    customerName: demand?.userName,
                    phoneNumber: demand?.userPhone,
                    date: TimeUtils.parseDate2(demand?.deliveryDate),
                    meal: demand?.mealType?.toTitleCase(),
                    qty: demand?.quantity,
                    expectedPrice: demand?.userAmount,
                    vendorPrice: demand?.vendorAmount,
                    status: demand?.status,
                  ),
                );
              },
            ),
            Gap(h: 150),
          ],
        );
      },
    );
  }

  Widget vendorOnDemandCard({
    String? foodName,
    String? customerName,
    String? phoneNumber,
    String? date,
    String? meal,
    int? qty,
    String? expectedPrice,
    String? vendorPrice,
    int? status,
  }) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 5),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          // HEADER
          Row(
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: const Color(0xfffff1e8),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.restaurant_menu, color: Color(0xffff6b35)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextBold(str: foodName, size: 17),
                    TextSemi(str: customerName, size: 14, color: AppColor.color_B0B0B0),
                    TextSemi(str: phoneNumber, size: 14, color: AppColor.color_B0B0B0),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),

                decoration: BoxDecoration(
                  color: status == "New" ? Colors.orange.shade50 : Colors.green.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),

                child: TextRegular(
                  str: AppStatus.getStatus(status),
                  color: AppColor.colorBlue,
                  size: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _vendorInfoRow(Icons.calendar_today, "$date • $meal"),
          const SizedBox(height: 6),
          _vendorInfoRow(Icons.shopping_bag, "Quantity : $qty"),
          const SizedBox(height: 6),
          _vendorInfoRow(Icons.currency_rupee, "User Amount : ₹$expectedPrice"),
          if (vendorPrice != null) ...[
            const SizedBox(height: 6),
            _vendorInfoRow(Icons.price_check, "Vendor Amount : ₹$vendorPrice"),
          ],
          Gap(h: 10),
          Center(
            child: RoundedContainer(
              height: 36,
              width: 170,
              rounded: 30,
              color: AppColor.colorBlue,
              child: TextRegular(str: 'View Request', color: AppColor.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _vendorInfoRow(IconData icon, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 30,
          width: 30,
          decoration: BoxDecoration(
            color: const Color(0xfffff4ec),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: const Color(0xffff6b35)),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  void getOnDemandListAPI() {
    _commonBloc.getOnDemandListAPI();
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
