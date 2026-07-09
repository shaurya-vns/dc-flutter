import 'package:flutter/material.dart';
import 'package:flutter_dc/src/constants/color_constants.dart';
import 'package:flutter_dc/src/constants/drawable_constant.dart';
import 'package:flutter_dc/src/mixin/BaseMixin.dart';
import 'package:flutter_dc/src/utils/gap.dart';
import 'package:flutter_dc/src/utils/time_utils.dart';
import 'package:flutter_dc/src/widget/custome_line.dart';
import 'package:flutter_dc/src/widget/fix_button_widget.dart';
import 'package:flutter_dc/src/widget/rounded_container.dart';
import 'package:flutter_dc/src/widget/test_bold.dart';
import 'package:flutter_dc/src/widget/test_medium.dart';
import 'package:flutter_dc/src/widget/test_regular.dart';
import 'package:flutter_dc/src/widget/test_semi.dart';

import '../../model/response/product/ProductModel.dart';
import '../../utils/app_utils.dart';
import '../../utils/date_picker_utils.dart';

class OneWidget extends StatefulWidget {
  final Function(int quantity, String? startDateAPI, double? payableAmount) callback;
  final ProductModel? product;

  const OneWidget({Key? key, required this.callback, required this.product})
    : super(key: key);

  @override
  State<OneWidget> createState() => _OneWidgetState();
}

class _OneWidgetState extends State<OneWidget> with BaseMixin {
  int quantity = 1;
  double payableAmount = 0;
  double productPrice = 0;
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
    var now = DateTime.now();
    startDateUI = TimeUtils.parseDateTime(now);
    startDateAPI = TimeUtils.parseDateApi(now);
    productPrice = AppUtils.getDouble(product?.productPrice);
    payableAmount = productPrice;
    setCallback();
  }

  void setCallback() {
    widget.callback(quantity, startDateAPI, getPayableAmount());
    setState(() {});
  }

  double getPayableAmount() {
    return payableAmount;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(h: 15),
          Row(
            children: [
              TextSemi(str: 'Price ', color: AppColor.black, size: 15),
              TextRegular(str: '( one time order )', color: AppColor.black, size: 14),
            ],
          ),
          TextBold(
            str: AppUtils.formatPrice(productPrice),
            color: AppColor.colorBlue,
            size: 15,
          ),
          Gap(h: 15),
          TextSemi(str: 'Select Delivery Date', color: AppColor.black, size: 15),
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
          Gap(h: 15),
          TextSemi(str: 'Quantity', color: AppColor.black, size: 15),
          Gap(h: 5),
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
                          payableAmount = productPrice * quantity;
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
                        payableAmount = productPrice * quantity;
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
          Gap(h: 25),
          RoundedContainer(
            rounded: 5,
            color: AppColor.grayborder,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, top: 15, right: 20, bottom: 15),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextMedium(str: 'Items', size: 15, color: AppColor.black),
                      ),
                      TextSemi(
                        str: '$quantity X ${AppUtils.formatPrice(productPrice)}',
                        size: 15,
                        color: AppColor.color_B0B0B0,
                      ),
                    ],
                  ),
                  Gap(h: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextMedium(
                          str: 'Order Amount',
                          size: 15,
                          color: AppColor.black,
                        ),
                      ),
                      TextSemi(
                        str: AppUtils.formatPrice(payableAmount),
                        size: 15,
                        color: AppColor.black,
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
                      TextSemi(str: 'FREE', size: 15, color: AppColor.color_1E6F46),
                    ],
                  ),

                  Gap(h: 12),
                  CustomLine(),
                  Gap(h: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextSemi(
                          str: 'Total Amount',
                          size: 18,
                          color: AppColor.black,
                        ),
                      ),
                      TextSemi(
                        str: '${AppUtils.formatPrice(payableAmount)}',
                        size: 18,
                        color: AppColor.color_EA645F,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Gap(h: 20),
          TextMedium(str: product?.description, size: 14, color: AppColor.black),
        ],
      ),
    );
  }

  // 2026-07-02 API
  Future<void> _selectDate() async {
    DatePickerUtils.selectCalendar(
      context: context,
      isPreviousDate: false,
      onDateCallback: (uiDate, apiDate) {
        print('SSSS uiDate $uiDate');
        print('SSSS apiDate $apiDate');
        startDateUI = uiDate;
        startDateAPI = apiDate;

        widget.callback(quantity, startDateAPI, getPayableAmount());
        setState(() {});
      },
    );
  }
}
