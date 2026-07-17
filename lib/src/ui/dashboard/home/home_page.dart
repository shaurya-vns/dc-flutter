import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dc/src/constants/drawable_constant.dart';
import 'package:flutter_dc/src/model/response/address/AddressModel.dart';
import 'package:flutter_dc/src/ui/dashboard/home/recommend_widget.dart';
import 'package:flutter_dc/src/ui/dashboard/home/trending_widget.dart';
import 'package:flutter_dc/src/widget/click_widget.dart';
import 'package:flutter_dc/src/widget/fix_button_widget.dart';
import 'package:flutter_dc/src/widget/rounded_container.dart';
import 'package:flutter_dc/src/widget/test_bold.dart';
import 'package:flutter_dc/src/widget/test_regular.dart';
import 'package:rxdart/rxdart.dart';

import '../../../constants/color_constants.dart';
import '../../../model/base_error.dart';
import '../../../model/response/address/AddressResponse.dart';
import '../../../model/response/product/ProductListResponse.dart';
import '../../../model/response/product/ProductModel.dart';
import '../../../network/api_request_codes.dart';
import '../../../sheet/AddressBottomSheet.dart';
import '../../../utils/app_constant.dart';
import '../../../utils/app_utils.dart';
import '../../../utils/gap.dart';
import '../../../widget/CommonStreamBuilder.dart';
import '../../common_bloc.dart';
import '../../shimmer/CustomShimmer.dart';
import '../menu/menu_widget.dart';
import 'category_widget.dart';
import 'health_widget.dart';
import 'offer_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late CommonBloc _commonBloc;
  final StreamController<List<ProductModel>?> _productsStream = BehaviorSubject();
  AddressModel? address;

  @override
  void initState() {
    super.initState();
    _commonBloc = CommonBloc(context);
    WidgetsBinding.instance.addPostFrameCallback((_) => onPostFrameCallback(context));
  }

  onPostFrameCallback(BuildContext context) {
    setObservables();
    getProductListAPI();
    getUserAddressListAPI();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.color_bg,
      child: RefreshIndicator(
        onRefresh: () async {},
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 110),
              child: SingleChildScrollView(
                child: CommonStreamBuilder<List<ProductModel>?>(
                  stream: _productsStream.stream,
                  shimmer: CustomShimmer(),
                  builder: (context, products) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        OfferWidget(products: products),
                        CategoryWidget(products: products),
                        TrendingWidget(products: products),
                        RecommendWidget(products: products),
                        HealthWidget(products: products),
                        MenuWidget(products: products),
                      ],
                    );
                  },
                ),
              ),
            ),
            _widgetHeader(),
          ],
        ),
      ),
    );
  }

  Widget _widgetHeader() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 10, top: 0, bottom: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Gap(h: 5), _widgetAddressUI(), Gap(h: 5), _widgetLocationUI()],
      ),
    );
  }

  Widget _widgetAddressUI() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.location_on_outlined, size: 24),
        Gap(w: 6),
        Expanded(
          child: InkWell(
            onTap: () {
              showSheet();
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    TextBold(str: homeAddress, size: 17, color: AppColor.black),
                    Icon((Icons.keyboard_arrow_down_outlined), size: 26),
                  ],
                ),
                TextRegular(str: fullAddress, max: 1, size: 14, color: AppColor.black),
              ],
            ),
          ),
        ),
        ClickWidget(
          paddingTop: 8,
          paddingRight: 8,
          onClick: () {},
          child: RoundedContainer(
            width: 35,
            height: 35,
            rounded: 35,
            child: Icon(Icons.notifications_active_outlined, color: AppColor.colorBlue),
          ),
        ),

        ClickWidget(
          paddingTop: 8,
          paddingRight: 8,
          onClick: () {},
          child: RoundedContainer(
            width: 35,
            height: 35,
            rounded: 35,
            child: Icon(Icons.emoji_people_rounded, color: AppColor.colorBlue),
          ),
        ),
      ],
    );
  }

  Widget _widgetLocationUI() {
    return Row(
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
      ],
    );
  }

  void getProductListAPI() {
    _commonBloc.getProductListAPI();
  }

  void getUserAddressListAPI() {
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
        case ApiType.PRODUCT_LIST:
          {
            var res = ProductListResponse.fromJson(map);
            print('sssssss data ${res.data}');
            _productsStream.sink.add(res.data);
          }

        case ApiType.ADDRESS_LIST:
          {
            var res = AddressResponse.fromJson(map);
            var addresses = res.data;
            var address = AppUtils.getDefaultAddress(addresses);
            homeAddress = AppUtils.getHomeAddress(address);
            fullAddress = AppUtils.getFullAddress(address);
            addressId = address?.id;
            setState(() {});
          }
      }
    });

    _commonBloc.apiError.listen((error) {
      var baseError = BaseError.fromJson(error);
      AppUtils.showToast(baseError.message);
    });
    //validation error listener
  }

  void showSheet() {
    showModalBottomSheet<dynamic>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return AddressBottomSheet(
          onCallback: (AddressModel? add) {
            address = add;
            homeAddress = address?.addressTypeLabel;
            fullAddress = address?.fullAddress;
            setState(() {});
          },
        );
      },
    );
  }
}
