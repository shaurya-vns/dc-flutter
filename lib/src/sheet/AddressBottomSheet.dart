import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dc/src/model/response/address/AddressModel.dart';
import 'package:flutter_dc/src/ui/address/AddAddressPage.dart';
import 'package:flutter_dc/src/widget/click_text.dart';
import 'package:flutter_dc/src/widget/fill_button_widget.dart';
import 'package:flutter_dc/src/widget/fix_button_widget.dart';
import 'package:flutter_dc/src/widget/test_regular.dart';
import 'package:flutter_dc/src/widget/test_semi.dart';
import 'package:rxdart/rxdart.dart';

import '../constants/color_constants.dart';
import '../constants/drawable_constant.dart';
import '../model/base_error.dart';
import '../model/response/address/AddressResponse.dart';
import '../network/api_request_codes.dart';
import '../ui/common_bloc.dart';
import '../utils/app_constant.dart';
import '../utils/app_utils.dart';
import '../utils/gap.dart';
import '../widget/CommonStreamBuilder.dart';
import '../widget/click_image.dart';
import '../widget/custome_line.dart';
import '../widget/test_medium.dart';

class AddressBottomSheet extends StatefulWidget {
  final Function(AddressModel? add) onCallback;

  AddressBottomSheet({required this.onCallback});

  @override
  _AddressBottomSheetState createState() => _AddressBottomSheetState();
}

class _AddressBottomSheetState extends State<AddressBottomSheet> {
  final StreamController<List<AddressModel>?> _addressStream = BehaviorSubject();
  late CommonBloc _commonBloc;

  @override
  void initState() {
    super.initState();
    _commonBloc = CommonBloc(context);
    WidgetsBinding.instance.addPostFrameCallback((_) => onPostFrameCallback(context));
  }

  onPostFrameCallback(BuildContext context) {
    setObservables();
    getUserAddressListAPI();
  }

  @override
  Widget build(BuildContext context) {
    return _widgetSheet();
  }

  Widget _widgetSheet() {
    double w = MediaQuery.of(context).size.width;
    return Stack(
      alignment: Alignment.center,
      children: [
        SafeArea(
          top: false,
          bottom: true,
          child: Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Wrap(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Container(
                      width: w,
                      color: AppColor.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              left: 10,
                              right: 10,
                              top: 10,
                              bottom: 15,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Gap(w: 10),
                                    Expanded(
                                      child: TextSemi(
                                        str: 'Choose Delivery Address',
                                        size: 16,
                                      ),
                                    ),
                                    ClickImage(
                                      size: 20,
                                      icon: DrawableConstant.ic_cross,
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                                Gap(h: 15),
                                CustomLine(),
                                Gap(h: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    FillButtonWidget(
                                      width: 190,
                                      title: 'Add New Address',
                                      onPressed: () async {
                                        Navigator.pop(context);
                                        AppUtils.launchScreen(context, AddAddressPage());
                                      },
                                    ),
                                  ],
                                ),
                                Gap(h: 20),
                                TextSemi(str: 'Address: ', size: 20),
                                Gap(h: 10),
                                _widgetStatusList(),
                                Gap(h: 20),
                                CustomLine(),
                                Gap(h: 15),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _widgetStatusList() {
    return SizedBox(
      height: 320,
      child: CommonStreamBuilder<List<AddressModel>?>(
        stream: _addressStream.stream,
        builder: (context, addresses) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: AppUtils.getInt(addresses?.length),
            itemBuilder: (context, index) {
              var data = addresses?[index];
              return FixButtonWidget(
                borderColor: AppColor.white,
                onPressed: () {
                  data?.isSelected = true;
                  widget.onCallback(data);
                  setState(() {});
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 15, left: 16, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextSemi(
                              str: data?.addressTypeLabel,
                              size: 17,
                              color: AppColor.black,
                            ),
                          ),
                          ClickText(
                            child: TextRegular(
                              str: 'Change',
                              line: true,
                              size: 16,
                              color: AppColor.red,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              AppUtils.launchScreen(
                                context,
                                AddAddressPage(address: data),
                              );
                            },
                          ),
                        ],
                      ),
                      Gap(h: 5),
                      TextMedium(str: data?.fullAddress, size: 15, color: AppColor.black),
                      Gap(h: 5),
                      CustomLine(),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void getUserAddressListAPI() {
    _commonBloc.getUserAddressListAPI();
  }

  @override
  void dispose() {
    super.dispose();
    _commonBloc.onDispose();
  }

  void setObservables() {
    //success listener
    _commonBloc.apiResponse.listen((map) {
      var apiType = map[AppConstants.API_TYPE];
      switch (apiType) {
        case ApiType.ADDRESS_LIST:
          {
            var res = AddressResponse.fromJson(map);
            _addressStream.sink.add(res.data);
          }
      }
    });
    //error listener
    _commonBloc.apiError.listen((error) {
      var baseError = BaseError.fromJson(error);
      AppUtils.showToast(baseError.message);
    });
    //validation error listener
  }
}
