import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dc/src/constants/color_constants.dart';
import 'package:flutter_dc/src/mixin/BaseMixin.dart';
import 'package:flutter_dc/src/model/response/address/AddressModel.dart';
import 'package:flutter_dc/src/ui/common_bloc.dart';
import 'package:flutter_dc/src/ui/detail/sub_widget.dart';
import 'package:flutter_dc/src/utils/cache_image.dart';
import 'package:flutter_dc/src/utils/gap.dart';
import 'package:flutter_dc/src/widget/rounded_container.dart';
import 'package:flutter_dc/src/widget/test_light.dart';
import 'package:flutter_dc/src/widget/test_medium.dart';
import 'package:flutter_dc/src/widget/test_regular.dart';
import 'package:flutter_dc/src/widget/test_semi.dart';
import 'package:rxdart/rxdart.dart';

import '../../model/base_error.dart';
import '../../model/response/address/AddressResponse.dart';
import '../../model/response/detail/ProductDetailResponse.dart';
import '../../model/response/product/ProductModel.dart';
import '../../network/api_request_codes.dart';
import '../../utils/app_constant.dart';
import '../../utils/app_utils.dart';
import '../../widget/CommonStreamBuilder.dart';
import '../../widget/SlideToPayButton.dart';
import '../../widget/test_bold.dart';
import '../shimmer/CustomShimmer.dart';
import 'SubscriptionSuccessScreen.dart';
import 'one_widget.dart';

class CreateSubscriptionPage extends StatefulWidget {
  final ProductModel? product;

  const CreateSubscriptionPage({Key? key, required this.product}) : super(key: key);

  @override
  State<CreateSubscriptionPage> createState() => _CreateSubscriptionPageState();
}

class _CreateSubscriptionPageState extends State<CreateSubscriptionPage> with BaseMixin {
  final StreamController<ProductModel?> _dataStream = BehaviorSubject();
  final StreamController<AddressModel?> _addressStream = BehaviorSubject();
  late CommonBloc _commonBloc;

  bool? isApplyOffer = false;

  int quantity = 1;
  int? productId;
  String? startDateAPI;
  double? payableAmount = 0;
  int index = 2;
  int? pricingId;
  ProductModel? product;
  AddressModel? address;

  double? distanceProduct;

  @override
  void initState() {
    productId = widget.product?.id;
    super.initState();
    _commonBloc = CommonBloc(context);
    WidgetsBinding.instance.addPostFrameCallback((_) => onPostFrameCallback(context));
  }

  onPostFrameCallback(BuildContext context) {
    setObservables();
    getProductDetail();
    getUserAddressListAPI();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: SafeArea(
        top: false,
        bottom: true,
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            toolbarHeight: 0,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          bottomNavigationBar: product == null ? SizedBox() : _widgetBottomUI(),
          body: Stack(
            children: [
              SingleChildScrollView(
                child: CommonStreamBuilder<ProductModel?>(
                  stream: _dataStream.stream,
                  shimmer: CustomShimmer(),
                  builder: (context, product) {
                    var image = AppUtils.getFirstImage(product?.images);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CacheImage(url: image, w: SCREEN_WIDTH, h: 300),
                        _widgetSubUI(product),
                        _widgetTabUI(),
                        _widgetOneSubUI(product),
                        Gap(h: 100),
                      ],
                    );
                  },
                ),
              ),
              _widgetBackUI(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _widgetBackUI() {
    return Padding(
      padding: const EdgeInsets.only(top: 70),
      child: CommonStreamBuilder<AddressModel?>(
        stream: _addressStream.stream,
        builder: (context, data) {
          double? lat1 = data?.latitude;
          double? lng1 = data?.longitude;
          double? lat2 = product?.subOwner?.address?.latitude;
          double? lng2 = product?.subOwner?.address?.longitude;
          // distanceProduct = AppUtils.getDistance(lat1, lng1, lat2, lng2);
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.topLeft,
                colors: [
                  AppColor.trans,
                  AppColor.color_F4C102.withOpacity(0.8),
                  AppColor.color_F4C102.withOpacity(1),
                ],
                stops: [0.0, 0.7, 1.0],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 4, top: 10, bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back_rounded, color: AppColor.white, size: 25),
                  ),
                  Expanded(
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 4,
                          right: 10,
                          top: 0,
                          bottom: 1,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                TextBold(
                                  str: address?.addressTypeLabel,
                                  size: 15,
                                  color: AppColor.white,
                                ),
                                Icon(
                                  (Icons.keyboard_arrow_down_outlined),
                                  color: AppColor.white,
                                  size: 26,
                                ),
                                TextSemi(
                                  str: 'Change address',
                                  size: 13,
                                  color: AppColor.white,
                                ),
                              ],
                            ),
                            TextRegular(
                              str: address?.fullAddress,
                              size: 13,
                              max: 2,
                              color: AppColor.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _widgetSubUI(ProductModel? product) {
    var sub = product?.subOwner;

    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextMedium(str: sub?.name, size: 17, color: AppColor.black),
              TextRegular(str: sub?.address?.address, size: 13, color: AppColor.black),
              TextLight(str: '$distanceProduct km away', size: 11, color: AppColor.black),
              Gap(h: 6),
              TextRegular(
                str: AppUtils.formatStatus(product?.planType),
                color: AppColor.black,
                size: 14,
              ),
              Gap(h: 6),
              TextRegular(
                str: AppUtils.formatStatus(product?.name),
                color: AppColor.black,
                size: 14,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _widgetTabUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: RoundedContainer(
        rounded: 8,
        color: AppColor.color_F7CCB4,
        child: Row(
          children: [
            _widgetTabItemUI('Order Now', 'One Time', 1),
            _widgetTabItemUI('Subscribe Now', 'Save More', 2),
          ],
        ),
      ),
    );
  }

  Widget _widgetTabItemUI(String str, String str2, int type) {
    return Expanded(
      child: InkWell(
        onTap: () {
          index = type;
          setState(() {});
        },
        child: RoundedContainer(
          height: 46,
          rounded: 8,
          border: index == type ? AppColor.color_E65C0E : AppColor.trans,
          color: index == type ? AppColor.color_E65C0E : AppColor.trans,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextSemi(
                str: str,
                color: index == type ? AppColor.white : AppColor.black,
                size: 15,
              ),
              TextRegular(
                str: str2,
                color: index == type ? AppColor.white : AppColor.black,
                size: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _widgetOneSubUI(ProductModel? product) {
    return Stack(
      children: [
        Visibility(
          visible: index == 1,
          child: OneWidget(
            product: product,
            callback: (q, startDate, amount) {
              quantity = q;
              startDateAPI = startDate;
              payableAmount = amount;
              setState(() {});
            },
          ),
        ),
        Visibility(
          visible: index == 2,
          child: SubWidget(
            product: product,
            callback: (q, pId, startDate, amount, isOffer) {
              quantity = q;
              pricingId = pId;
              startDateAPI = startDate;
              payableAmount = amount;
              isApplyOffer = isOffer;
              setState(() {});
            },
          ),
        ),
      ],
    );
  }

  Widget _widgetBottomUI() {
    String grandTotal = AppUtils.formatPrice(payableAmount);
    return Container(
      width: SCREEN_WIDTH,
      color: AppColor.white,
      child: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 20, left: 20, right: 20),
        child:
            index == 2 && product?.isSubscribed == true
                ? RoundedContainer(
                  height: 50,
                  rounded: 40,
                  child: TextSemi(str: 'Already Subscribed'),
                )
                : SlideToPayButton(
                  index: index,
                  amount: grandTotal,
                  onSuccess: () {
                    print('object $startDateAPI $quantity $payableAmount ${address?.id}');
                    print('object $pricingId');
                    if (address == null) {
                      AppUtils.showToast('Please add delivery address');
                    } else {
                      if (index == 1) {
                        createOneTimeOrderAPI();
                      } else {
                        createSubscriptionAPI();
                      }
                    }
                  },
                ),
      ),
    );
  }

  void createOneTimeOrderAPI() {
    int? productId = widget.product?.id;
    _commonBloc.createOneTimeOrderAPI(
      productId,
      startDateAPI,
      quantity,
      address?.id,
      isApplyOffer,
    );
  }

  void createSubscriptionAPI() {
    int? productId = widget.product?.id;
    _commonBloc.createSubscriptionAPI(
      productId,
      pricingId,
      startDateAPI,
      quantity,
      address?.id,
      isApplyOffer,
    );
  }

  void getProductDetail() {
    _commonBloc.getProductDetail(productId);
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
        case ApiType.CREATE_SUBSCRIPTION:
          {
            AppUtils.launchScreenRemoveAll(
              context,
              SubscriptionSuccessScreen(subscriptionId: '1313123123123'),
            );
          }
        case ApiType.PRODUCT_DETAIL:
          {
            var res = ProductDetailResponse.fromJson(map);
            product = res.data;
            _dataStream.sink.add(res.data);
            setState(() {});
          }
        case ApiType.CREATE_ONE_TIME_ORDER:
          {
            AppUtils.launchScreenRemoveAll(
              context,
              SubscriptionSuccessScreen(subscriptionId: '1313123123123'),
            );
          }
        case ApiType.USER_ADDRESS_LIST:
          {
            var res = AddressResponse.fromJson(map);
            var addresses = res.data;
            address = AppUtils.getDefaultAddress(addresses);
            _addressStream.sink.add(address);
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
