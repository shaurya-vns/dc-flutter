import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dc/src/constants/color_constants.dart';
import 'package:flutter_dc/src/mixin/BaseMixin.dart';
import 'package:flutter_dc/src/ui/common_bloc.dart';
import 'package:flutter_dc/src/utils/cache_image.dart';
import 'package:flutter_dc/src/utils/gap.dart';
import 'package:flutter_dc/src/widget/fill_button_widget.dart';
import 'package:flutter_dc/src/widget/fix_button_widget.dart';
import 'package:flutter_dc/src/widget/test_regular.dart';
import 'package:flutter_dc/src/widget/test_semi.dart';
import 'package:rxdart/rxdart.dart';

import '../../model/base_error.dart';
import '../../model/response/product/ProductModel.dart';
import '../../network/api_request_codes.dart';
import '../../utils/app_constant.dart';
import '../../utils/app_utils.dart';
import '../../widget/SlideToPayButton.dart';
import '../../widget/all_field_widget.dart';
import '../../widget/scaffold_widget.dart';

class SubscriptionPage extends StatefulWidget {
  final ProductModel? product;

  const SubscriptionPage({Key? key, required this.product}) : super(key: key);

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> with BaseMixin {
  late CommonBloc _loginBloc;
  TextEditingController controller = TextEditingController();
  ProductModel? product;
  final StreamController<ProductModel?> _productStream = BehaviorSubject();

  @override
  void initState() {
    product = widget.product;
    totalAmount = 3500;
    currentAmount = totalAmount;
    controller.text = '1';
    super.initState();
    _loginBloc = CommonBloc(context);
    WidgetsBinding.instance.addPostFrameCallback((_) => onPostFrameCallback(context));
  }

  onPostFrameCallback(BuildContext context) {
    setObservables();
    _productStream.sink.add(widget.product);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      isBottom: false,
      bottom: _widgetBottomUI(),
      back: widgetBackUI(context, product?.planName),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_widgetBannerUI(), _widgetUI(), _widgetPriceUI(), Gap(h: 100)],
        ),
      ),
    );
  }

  Widget _widgetBannerUI() {
    print('object product?.images ${product?.images?.length}');
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: CarouselSlider.builder(
        itemCount: AppUtils.getLength(product?.images?.length),
        itemBuilder: (context, index, realIndex) {
          var image = product?.images?[index];
          return Padding(
            padding: const EdgeInsets.only(left: 4),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CacheImage(url: image, w: SCREEN_WIDTH, h: 200),
            ),
          );
        },
        options: CarouselOptions(
          height: 210,
          viewportFraction: 0.9,
          enlargeCenterPage: true,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 10),
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          enableInfiniteScroll: false,
        ),
      ),
    );
  }

  Widget _widgetUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextSemi(str: product?.name, size: 20, color: AppColor.black),
          Gap(h: 2),
          TextRegular(
            str: product?.shortDescription,
            size: 15,
            color: AppColor.colorBlue,
          ),
          Gap(h: 15),
          TextSemi(str: product?.description, size: 16, color: AppColor.black),
        ],
      ),
    );
  }

  int index = 1;
  int quantity = 1;

  Widget _widgetPriceUI() {
    var pricingOptions = product?.pricingOptions;
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 15, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextSemi(str: 'Best offer', size: 18, color: AppColor.black),
          ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: AppUtils.getLength(pricingOptions?.length),
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              var price = pricingOptions?[index];
              return Padding(
                padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
                child: FixButtonWidget(
                  height: 50,
                  color: AppColor.white,
                  borderColor: AppColor.color_156CD7,
                  onPressed: () {
                    currentAmount = 3500;
                    totalAmount = currentAmount * quantity;
                    isSelected = true;
                    setState(() {});
                  },
                  child: Row(
                    children: [
                      Gap(w: 15),
                      Icon(
                        size: 22,
                        index == 1
                            ? Icons.radio_button_checked_outlined
                            : Icons.radio_button_off,
                        color: AppColor.color_156CD7,
                      ),
                      Gap(w: 6),
                      TextSemi(
                        str:
                            '${price?.days} days ${AppUtils.formatPrice(price?.price)} / person',
                        size: 18,
                        color: AppColor.color_156CD7,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          Row(
            children: [
              Expanded(
                child: TextSemi(str: 'Add Person', size: 18, color: AppColor.black),
              ),
              FixButtonWidget(
                onPressed: () {
                  if (quantity != 1) {
                    quantity--;
                  }
                  totalAmount = currentAmount * quantity;
                  controller.text = '$quantity';
                  setState(() {});
                },
                child: TextSemi(str: '-', size: 30, color: AppColor.black),
              ),
              Gap(w: 20),
              Container(
                alignment: Alignment.center,
                width: 80,
                child: AllFieldWidget(
                  controller: controller,
                  field: 'Quantity',
                  preNode: null,
                  nextNode: null,
                  max: 3,
                  onTypeChange: (String value) {
                    quantity = AppUtils.getInt4(value);
                    totalAmount = currentAmount * quantity;
                    setState(() {});
                  },
                ),
              ),
              Gap(w: 20),
              FixButtonWidget(
                onPressed: () {
                  print('quantity $quantity');
                  print('currentAmount $currentAmount');
                  print('totalAmount $totalAmount');
                  quantity++;
                  controller.text = '$quantity';
                  totalAmount = currentAmount * quantity;
                  setState(() {});
                },
                child: TextSemi(str: '+', size: 30, color: AppColor.black),
              ),
            ],
          ),

          Gap(h: 20),
          Container(
            width: SCREEN_WIDTH,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColor.color_0D47A1, AppColor.black],
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x33FF5722),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.white, fontSize: 16),
                children: [
                  const TextSpan(text: 'You have subscribed plan for '),
                  TextSpan(
                    text: ' $quantity person.',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const TextSpan(text: '\nTotal payable amount '),
                  TextSpan(
                    text: ' ${AppUtils.formatPrice(totalAmount)}',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  double totalAmount = 0;
  double currentAmount = 0;

  Widget _widgetBottomUI() {
    String grandTotal = AppUtils.formatPrice(totalAmount);
    return grandTotal == 0
        ? SizedBox()
        : Container(
          width: SCREEN_WIDTH,
          color: AppColor.white,
          child: Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 20, left: 20, right: 20),
            child: SlideToPayButton(amount: grandTotal, onSuccess: () {}),
          ),
        );
  }

  Widget _widgetBottomUI1() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: FillButtonWidget(
            bgColor: AppColor.red,
            title: 'Subscription',
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _loginBloc.onDispose();
  }

  void setObservables() {
    //success listener
    _loginBloc.apiResponse.listen((map) {
      var apiType = map[AppConstants.API_TYPE];
      switch (apiType) {
        case ApiType.LOGIN:
          {}
      }
    });
    //error listener
    _loginBloc.apiError.listen((error) {
      var baseError = BaseError.fromJson(error);
      AppUtils.showToast(baseError.message);
    });
    //validation error listener
  }
}
