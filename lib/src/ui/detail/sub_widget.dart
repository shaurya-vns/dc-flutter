import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
import 'package:flutter_dc/src/constants/color_constants.dart';
import 'package:flutter_dc/src/constants/drawable_constant.dart';
import 'package:flutter_dc/src/mixin/BaseMixin.dart';
import 'package:flutter_dc/src/utils/gap.dart';
import 'package:flutter_dc/src/widget/click_text.dart';
import 'package:flutter_dc/src/widget/custome_line.dart';
import 'package:flutter_dc/src/widget/fix_button_widget.dart';
import 'package:flutter_dc/src/widget/rounded_container.dart';
import 'package:flutter_dc/src/widget/test_medium.dart';
import 'package:flutter_dc/src/widget/test_regular.dart';
import 'package:flutter_dc/src/widget/test_semi.dart';

import '../../model/response/product/ProductModel.dart';
import '../../utils/app_utils.dart';
import '../../utils/date_picker_utils.dart';
import '../../utils/time_utils.dart';

class SubWidget extends StatefulWidget {
  final ProductModel? product;
  final Function(
    int quantity,
    int? pricingId,
    String? startDateAPI,
    double? payableAmount,
    bool? isOffer,
  )
  callback;

  const SubWidget({Key? key, required this.callback, required this.product})
    : super(key: key);

  @override
  State<SubWidget> createState() => _SubWidgetState();
}

class _SubWidgetState extends State<SubWidget> with BaseMixin {
  int quantity = 1;

  double currentAmount = 0;
  double payableAmount = 0;
  int? pricingId;
  int? productId;

  int index = 2;

  double planAmount = 0;
  double productPrice = 0;
  double discount = 0;
  bool isApplyOffer = false;

  ProductModel? product;

  String? startDateUI;
  String? startDateAPI;

  @override
  void initState() {
    product = widget.product;
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => onPostFrameCallback(context));
  }

  onPostFrameCallback(BuildContext context) {
    var now = DateTime.now().add(Duration(days: 0));
    startDateUI = TimeUtils.parseDateTime(now);
    startDateAPI = TimeUtils.parseDateApi(now);
    var option = product?.pricingOptions?[0];
    option?.isSelected = true;
    pricingId = option?.id;
    currentAmount = AppUtils.getDouble(option?.price);
    payableAmount = currentAmount;
    setCallback();
  }

  void setCallback() {
    widget.callback(quantity, pricingId, startDateAPI, getPayableAmount(), isApplyOffer);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _widgetSubscriptionUI(product),
        _widgetOfferUI(product),
        _widgetPlanUI(product),
        Padding(
          padding: const EdgeInsets.all(25.0),
          child: TextMedium(str: product?.description, size: 14, color: AppColor.black),
        ),
      ],
    );
  }

  Widget _widgetSubscriptionUI(ProductModel? product) {
    var pricingOptions = product?.pricingOptions;

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(h: 20),
              TextSemi(str: 'Select Pricing Option', color: AppColor.black, size: 15),
              ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: NeverScrollableScrollPhysics(),
                itemCount: AppUtils.getLength(pricingOptions?.length),
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  var priceOption = pricingOptions?[index];
                  double basePrice = AppUtils.getDouble(priceOption?.price);
                  double perPrice = basePrice / AppUtils.getInt(priceOption?.days);

                  double discount = perPrice + (index + 1) * 10;

                  double mrp = AppUtils.getDouble(basePrice + discount);
                  return Padding(
                    padding: const EdgeInsets.only(top: 10, right: 0),
                    child: FixButtonWidget(
                      height: 60,
                      radius: 10,
                      color:
                          priceOption?.isSelected == true
                              ? AppColor.color_F7CCB4.withOpacity(0.4)
                              : AppColor.white,
                      borderColor:
                          priceOption?.isSelected == true
                              ? AppColor.color_DE6262.withOpacity(0.4)
                              : AppColor.color_F7CCB4,
                      onPressed: () {
                        pricingOptions?.forEach((action) {
                          action.isSelected = false;
                        });
                        currentAmount = basePrice;

                        priceOption?.isSelected = true;
                        pricingId = priceOption?.id;

                        payableAmount = currentAmount * quantity;
                        setCallback();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Gap(w: 15),
                          Padding(
                            padding: const EdgeInsets.only(top: 13),
                            child: Icon(
                              size: 20,
                              priceOption?.isSelected == true
                                  ? Icons.radio_button_checked_outlined
                                  : Icons.radio_button_off,

                              color:
                                  priceOption?.isSelected == true
                                      ? AppColor.color_DE6262
                                      : AppColor.color_F7CCB4,
                            ),
                          ),
                          Gap(w: 8),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextSemi(
                                  str: '${priceOption?.days} Days Plan',
                                  size: 15,
                                  color: AppColor.black,
                                ),

                                TextRegular(
                                  str: '${AppUtils.formatPrice(perPrice)} per day',
                                  size: 11,
                                  color: AppColor.black,
                                ),
                              ],
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  TextSemi(
                                    str: AppUtils.formatPrice(basePrice),
                                    size: 15,
                                    color: AppColor.color_D25B17,
                                  ),
                                  Gap(w: 10),
                                  TextRegular(
                                    str: AppUtils.formatPrice(mrp),
                                    cross: true,
                                    size: 12,
                                    color: AppColor.black,
                                  ),
                                ],
                              ),

                              RoundedContainer(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 4,
                                    top: 2,
                                    bottom: 2,
                                    right: 4,
                                  ),
                                  child: TextSemi(
                                    str: 'Save ${AppUtils.formatPrice(discount)}',
                                    size: 9,
                                    color: AppColor.color_1E6F46,
                                  ),
                                ),
                                color: AppColor.color_1E6F46.withOpacity(0.3),
                              ),
                            ],
                          ),
                          Gap(w: 15),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          Gap(h: 15),
          TextSemi(str: 'Select Start Date', color: AppColor.black, size: 15),
          Gap(h: 5),
          FixButtonWidget(
            height: 46,
            radius: 8,
            borderColor: AppColor.color_DADADA,
            color: AppColor.color_DADADA.withOpacity(0.3),
            onPressed: () {
              _selectDate();
            },
            child: Row(
              children: [
                Gap(w: 12),
                Icon(Icons.calendar_month, size: 22, color: AppColor.black),
                Gap(w: 10),
                TextRegular(str: startDateUI, color: AppColor.black, size: 13),
              ],
            ),
          ),

          _widgetQuantity(product),
        ],
      ),
    );
  }

  Widget _widgetQuantity(ProductModel? product) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextSemi(str: 'Quantity', color: AppColor.black, size: 15),
          Gap(h: 4),
          Row(
            children: [
              RoundedContainer(
                color: AppColor.white,
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        quantity--;
                        if (quantity == 0) {
                          quantity = 1;
                        } else {
                          payableAmount = currentAmount * quantity;
                          setCallback();
                        }
                      },
                      child: RoundedContainer(
                        width: 44,
                        height: 44,
                        rounded: 10,
                        color: AppColor.color_F7CCB4,
                        child: Image.asset(
                          DrawableConstant.ic_minus,
                          width: 13,
                          height: 17,
                          color: AppColor.black,
                        ),
                        alignment: Alignment.center,
                      ),
                    ),
                    Container(
                      width: 50,
                      alignment: Alignment.center,
                      child: TextRegular(
                        str: ' $quantity ',
                        color: AppColor.colorBlue,
                        size: 16,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        quantity++;
                        payableAmount = currentAmount * quantity;
                        setCallback();
                      },
                      child: RoundedContainer(
                        width: 44,
                        height: 44,
                        rounded: 10,
                        color: AppColor.color_F7CCB4,
                        child: Image.asset(
                          DrawableConstant.ic_add_plus,
                          color: AppColor.black,
                          width: 13,
                          height: 13,
                        ),
                        alignment: Alignment.center,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _widgetOfferUI(ProductModel? product) {
    return product?.offer == null
        ? SizedBox(height: 25)
        : Padding(
          padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  TextSemi(str: 'Apply Offer', size: 16, color: AppColor.black),
                  TextRegular(str: ' ( optional )', size: 13, color: AppColor.black),
                ],
              ),
              Gap(h: 8),
              RoundedContainer(
                rounded: 6,
                padding: 2,
                color: AppColor.white,
                child: Row(
                  children: [
                    RoundedContainer(
                      width: 38,
                      height: 38,
                      rounded: 6,
                      color: AppColor.color_F7CCB4,
                      child: Icon(Icons.discount, size: 15, color: AppColor.color_DE6262),
                    ),
                    Gap(w: 10),
                    Expanded(
                      child: TextMedium(
                        str: product?.offer?.code?.toUpperCase(),
                        size: 14,
                        color: AppColor.black,
                      ),
                    ),

                    ClickText(
                      child: TextSemi(
                        str: isApplyOffer ? 'Remove' : 'Apply',
                        size: 14,
                        color: AppColor.color_D25B17,
                      ),
                      onPressed: () {
                        if (isApplyOffer) {
                          discount = 0;
                        } else {
                          discount = AppUtils.getDouble(product?.offer?.discountAmount);
                          openAnimation();
                        }
                        isApplyOffer = !isApplyOffer;
                        setCallback();
                      },
                    ),
                    Gap(w: 10),
                  ],
                ),
              ),
              Gap(h: 3),
              isApplyOffer
                  ? TextSemi(
                    str:
                        'You saved ${AppUtils.formatPrice(product?.offer?.discountAmount)}',
                    size: 14,
                    color: AppColor.color_1E6F46,
                  )
                  : SizedBox(),
              Gap(h: 15),
            ],
          ),
        );
  }

  Widget _widgetPlanUI(ProductModel? product) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: RoundedContainer(
        rounded: 5,

        color: AppColor.white,
        child: Padding(
          padding: const EdgeInsets.only(left: 15, top: 10, right: 15, bottom: 10),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextMedium(
                      str: index == 1 ? 'Order Amount' : 'Plan Amount',
                      size: 15,
                      color: AppColor.black,
                    ),
                  ),
                  TextSemi(
                    str: AppUtils.formatPrice(currentAmount),
                    size: 15,
                    color: AppColor.black,
                  ),
                ],
              ),
              Gap(h: 10),
              Row(
                children: [
                  Expanded(
                    child: TextMedium(str: 'Discount', size: 15, color: AppColor.black),
                  ),
                  TextSemi(
                    str: '-${AppUtils.formatPrice(discount)}',
                    size: 15,
                    color: AppColor.color_1E6F46,
                  ),
                ],
              ),
              Gap(h: 10),
              Row(
                children: [
                  Expanded(
                    child: TextMedium(
                      str: 'Delivery Charges',
                      size: 15,
                      color: AppColor.black,
                    ),
                  ),
                  TextSemi(
                    str: '-${AppUtils.formatPrice(0)}',
                    size: 15,
                    color: AppColor.color_1E6F46,
                  ),
                ],
              ),

              Gap(h: 12),
              CustomLine(),
              Gap(h: 10),
              Row(
                children: [
                  Expanded(
                    child: TextSemi(str: 'Total Amount', size: 18, color: AppColor.black),
                  ),
                  TextSemi(
                    str: '${AppUtils.formatPrice(getPayableAmount())}',
                    size: 18,
                    color: AppColor.color_EA645F,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  double getPayableAmount() {
    return payableAmount - discount;
  }

  // 2026-07-02 API
  Future<void> _selectDate() async {
    DatePickerUtils.selectCalendar(
      context: context,
      isPreviousDate: false,
      fromDate: 1,
      onDateCallback: (uiDate, apiDate) {
        print('SSSS uiDate $uiDate');
        print('SSSS apiDate $apiDate');
        startDateUI = uiDate;
        startDateAPI = apiDate;
        setState(() {});
      },
    );
  }

  void openAnimation() {
    AppUtils.showToast(
      'You have applied offer and saved ${AppUtils.formatPrice(discount)}!',
    );
    Confetti.launch(
      context,
      options: const ConfettiOptions(particleCount: 500, spread: 120, y: .9),
    );
  }
}
