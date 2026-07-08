import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dc/src/constants/drawable_constant.dart';
import 'package:flutter_dc/src/ui/address/AddAddressPage.dart';
import 'package:flutter_dc/src/widget/click_widget.dart';
import 'package:flutter_dc/src/widget/fill_button_widget.dart';
import 'package:flutter_dc/src/widget/test_semi.dart';
import 'package:rxdart/rxdart.dart';

import '../../constants/color_constants.dart';
import '../../model/base_error.dart';
import '../../model/response/address/AddressModel.dart';
import '../../model/response/address/AddressResponse.dart';
import '../../network/api_request_codes.dart';
import '../../utils/app_constant.dart';
import '../../utils/app_utils.dart';
import '../../utils/gap.dart';
import '../../widget/CommonStreamBuilder.dart';
import '../../widget/custome_card.dart';
import '../../widget/scaffold_widget.dart';
import '../../widget/test_bold.dart';
import '../common_bloc.dart';
import '../shimmer/CustomShimmer.dart';

class MyAddressPage extends StatefulWidget {
  const MyAddressPage({super.key});

  @override
  State<MyAddressPage> createState() => _MyAddressPageState();
}

class _MyAddressPageState extends State<MyAddressPage> {
  late CommonBloc _commonBloc;
  final StreamController<List<AddressModel>?> _dataStream = BehaviorSubject();

  @override
  void initState() {
    super.initState();
    _commonBloc = CommonBloc(context);
    WidgetsBinding.instance.addPostFrameCallback((_) => onPostFrameCallback(context));
  }

  onPostFrameCallback(BuildContext context) {
    setObservables();
    getUserAddress();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      title: 'My Address',
      isBottom: false,
      bottom: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: FillButtonWidget(
              title: 'Add Address',
              onPressed: () async {
                await AppUtils.launchScreenWithResult(context, AddAddressPage());
                getUserAddress();
              },
            ),
          ),
        ],
      ),
      child: SingleChildScrollView(child: _widgetSubTodayOrder()),
    );
  }

  Widget _widgetSubTodayOrder() {
    return CommonStreamBuilder<List<AddressModel>?>(
      stream: _dataStream.stream,
      shimmer: CustomShimmer(),
      builder: (context, data) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: TextBold(
                str: 'My Address (${data?.length})'.toUpperCase(),
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
                return _widgetUI(today, data?.length);
              },
            ),
            Gap(h: 150),
          ],
        );
      },
    );
  }

  Widget _widgetUI(AddressModel? address, int? length) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 2),
      child: InkWell(
        onTap: () async {
          await AppUtils.launchScreenWithResult(
            context,
            AddAddressPage(address: address),
          );
          getUserAddress();
        },
        child: CustomCard(
          rounded: 5,
          child: Padding(
            padding: const EdgeInsets.only(left: 20, top: 10, bottom: 20, right: 10),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextBold(
                        str: address?.addressTypeLabel,
                        max: 1,
                        color: AppColor.black,
                        size: 18,
                      ),
                      TextSemi(
                        str: address?.fullAddress,
                        max: 10,
                        color: AppColor.black,
                        size: 15,
                      ),
                      Gap(h: 10),
                      TextSemi(
                        str: address?.phoneNumber,
                        max: 10,
                        color: AppColor.black,
                        size: 16,
                      ),
                    ],
                  ),
                ),
                Gap(w: 20),
                address?.isDefault != true
                    ? ClickWidget(
                      child: Icon(Icons.delete, color: AppColor.color_EA645F),
                      onClick: () {},
                    )
                    : SizedBox(),
                address?.isDefault == true
                    ? Image.asset(
                      width: 25,
                      height: 25,
                      DrawableConstant.ic_tick,
                      color: AppColor.color_EA645F,
                    )
                    : SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void getUserAddress() {
    _commonBloc.getUserAddressListAPI();
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
        case ApiType.ADDRESS_LIST:
          {
            var res = AddressResponse.fromJson(map);
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
