import 'package:flutter/material.dart';
import 'package:flutter_dc/src/constants/color_constants.dart';
import 'package:flutter_dc/src/utils/AppStatus.dart';
import 'package:flutter_dc/src/utils/app_utils.dart';
import 'package:flutter_dc/src/utils/ext.dart';
import 'package:flutter_dc/src/utils/time_utils.dart';
import 'package:flutter_dc/src/widget/fill_button_widget.dart';
import 'package:flutter_dc/src/widget/test_regular.dart';
import 'package:flutter_dc/src/widget/test_semi.dart';

import '../../../model/base_error.dart';
import '../../../model/common_response.dart';
import '../../../model/response/ondemand/list/OnDemandData.dart';
import '../../../network/api_request_codes.dart';
import '../../../utils/app_constant.dart';
import '../../../utils/dialog_utils.dart';
import '../../../utils/gap.dart';
import '../../../widget/scaffold_widget.dart';
import '../../../widget/test_bold.dart';
import '../../common_bloc.dart';

class VendorOnDemandDetailPage extends StatefulWidget {
  final OnDemandData? demand;

  const VendorOnDemandDetailPage({super.key, required this.demand});

  @override
  State<VendorOnDemandDetailPage> createState() => _VendorOnDemandDetailPageState();
}

class _VendorOnDemandDetailPageState extends State<VendorOnDemandDetailPage> {
  final TextEditingController priceController = TextEditingController();
  OnDemandData? demand;

  late CommonBloc _commonBloc;

  @override
  void initState() {
    demand = widget.demand;
    super.initState();
    _commonBloc = CommonBloc(context);
    WidgetsBinding.instance.addPostFrameCallback((_) => onPostFrameCallback(context));
  }

  onPostFrameCallback(BuildContext context) {
    setObservables();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      bottom: _bottomButton(),
      title: 'View Demand Request',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            _customerCard(demand),
            const SizedBox(height: 10),
            _userCard(demand),
            const SizedBox(height: 10),
            _userAddressCard(demand),
            const SizedBox(height: 10),
            _requirementCard(demand),
            const SizedBox(height: 10),
            _expectedPriceCard(demand),
            const SizedBox(height: 10),
            _vendorPriceCard(demand),
            const SizedBox(height: 10),
            _userReasonCard(demand),
            const SizedBox(height: 10),
            _vendorReasonCard(demand),
            const SizedBox(height: 140),
          ],
        ),
      ),
    );
  }

  Widget _customerCard(OnDemandData? demand) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xfffff1e8),
        borderRadius: BorderRadius.circular(18),
      ),

      child: Row(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),

            child: const Icon(Icons.restaurant_menu, color: Color(0xffff6b35), size: 30),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextBold(str: demand?.itemName),
              TextRegular(str: AppStatus.getStatus(demand?.status)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _requirementCard(OnDemandData? demand) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          _title("Customer Requirement", Icons.shopping_bag),
          const SizedBox(height: 15),
          _row("Quantity", '${demand?.quantity}'),
          _row("Delivery Date", TimeUtils.parseDate2(demand?.deliveryDate)),
          _row("Meal", demand?.mealType?.toTitleCase()),
        ],
      ),
    );
  }

  Widget _expectedPriceCard(OnDemandData? demand) {
    return _card(
      child: Column(
        children: [
          _title("Customer Expected Price", Icons.currency_rupee),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(14),
            ),

            child: TextBold(
              color: AppColor.color_0C2C1C,
              str: AppUtils.formatPrice(AppUtils.getDouble2(demand?.userAmount)),
              align: 2,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _vendorPriceCard(OnDemandData? demand) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title("Vendor New Price", Icons.edit),
          const SizedBox(height: 10),
          if (demand?.status == AppStatus.approved ||
              demand?.status == AppStatus.paid) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(14),
              ),

              child: TextBold(
                color: AppColor.color_0C2C1C,
                str: AppUtils.formatPrice(AppUtils.getDouble2(demand?.vendorAmount)),
                align: 2,
                size: 20,
              ),
            ),
          ] else ...[
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              maxLength: 4,
              maxLines: 1,
              decoration: InputDecoration(
                counterText: '',
                prefixIcon: const Icon(Icons.currency_rupee, size: 18),
                hintText: "Enter final amount",
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],

          TextRegular(
            size: 14,
            str: "This price will be sent to customer for approval",
            color: AppColor.red,
          ),
        ],
      ),
    );
  }

  Widget _userCard(OnDemandData? demand) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title("User Information", Icons.verified_user),
          SizedBox(height: 13),
          Row(
            children: [
              Expanded(child: TextSemi(size: 14, str: 'Name', color: AppColor.black)),
              TextRegular(size: 14, str: demand?.userName, color: AppColor.black),
            ],
          ),
          SizedBox(height: 5),
          InkWell(
            onTap: () {
              AppUtils.makePhoneCall(demand?.userPhone);
            },
            child: Row(
              children: [
                Expanded(
                  child: TextSemi(size: 14, str: 'Phone Number', color: AppColor.black),
                ),
                Icon(Icons.call, size: 16),
                Gap(w: 4),
                TextRegular(
                  line: true,
                  size: 14,
                  str: demand?.userPhone,
                  color: AppColor.black,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _userAddressCard(OnDemandData? demand) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title("User Address", Icons.location_city_outlined),
          SizedBox(height: 13),
          InkWell(
            onTap: () {
              AppUtils.openGoogleMap(
                demand?.addressDetail?.latitude,
                demand?.addressDetail?.longitude,
              );
            },
            child: Row(
              children: [
                Expanded(
                  child: TextRegular(
                    size: 14,
                    str: demand?.addressDetail?.fullAddress,
                    color: AppColor.black,
                  ),
                ),
                Gap(w: 20),
                Icon(Icons.maps_home_work_outlined, size: 20, color: AppColor.red),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _userReasonCard(OnDemandData? demand) {
    if (AppUtils.isNotBlank(demand?.cancelReason))
      return _card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _title("User Cancellation Reason", Icons.cancel_presentation),
            const SizedBox(height: 10),
            TextRegular(size: 14, str: demand?.cancelReason, color: AppColor.black),
          ],
        ),
      );
    return SizedBox();
  }

  Widget _vendorReasonCard(OnDemandData? demand) {
    if (AppUtils.isNotBlank(demand?.rejectReason))
      return _card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _title("Vendor Cancellation Reason", Icons.cancel_presentation),
            const SizedBox(height: 10),
            TextRegular(size: 14, str: demand?.rejectReason, color: AppColor.black),
          ],
        ),
      );
    return SizedBox();
  }

  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(18),
      ),

      child: child,
    );
  }

  Widget _title(String text, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xffff6b35), size: 17),
        const SizedBox(width: 5),
        TextSemi(str: text, size: 15),
      ],
    );
  }

  Widget _row(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: TextSemi(size: 15, str: title)),
          Expanded(child: TextRegular(str: value, align: 1, size: 14)),
        ],
      ),
    );
  }

  Widget _bottomButton() {
    if (demand?.status == AppStatus.cancelled || demand?.status == AppStatus.rejected)
      return SizedBox();
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (demand?.status == AppStatus.approved) ...[
              FillButtonWidget(
                bgColor: AppColor.colorBlue,
                title: 'Mark as Payment',
                onPressed: () {
                  vendorPaymentOnDemandAPI();
                },
              ),
            ] else if (demand?.status == AppStatus.paid) ...[
              FillButtonWidget(
                bgColor: AppColor.colorBlue,
                title: 'Mark as Delivered',
                onPressed: () {},
              ),
            ] else ...[
              Row(
                children: [
                  Expanded(
                    child: FillButtonWidget(
                      bgColor: AppColor.black,
                      title: 'Reject',
                      onPressed: () {
                        widgetCancelConfirm();
                      },
                    ),
                  ),
                  Gap(w: 10),
                  Expanded(
                    child: FillButtonWidget(
                      bgColor: AppColor.color_1E6F46,
                      title: 'Approve',
                      onPressed: () {
                        userApproveOnDemandAPI();
                      },
                    ),
                  ),
                ],
              ),
              Gap(h: 10),
              FillButtonWidget(
                bgColor: AppColor.colorBlue,
                width: 250,
                title: 'Update Amount',
                onPressed: () {
                  var vendorPrice = priceController.text.trim();
                  if (AppUtils.isBlank(vendorPrice)) {
                    AppUtils.showToast('Please enter vendor new price');
                  } else {
                    vendorAmountOnDemandAPI(vendorPrice);
                  }
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  void widgetCancelConfirm() {
    DialogUtils().widgetCancelUserOnDemandDialog(
      context: context,
      callback: (String reason) async {
        Navigator.pop(context);
        userCancelOnDemandAPI(reason);
      },
    );
  }

  void vendorAmountOnDemandAPI(String vendorPrice) {
    _commonBloc.vendorAmountOnDemandAPI(demand?.id, vendorPrice);
  }

  void vendorPaymentOnDemandAPI() {
    _commonBloc.vendorPaymentOnDemandAPI(demand?.id);
  }

  void userApproveOnDemandAPI() {
    _commonBloc.vendorApproveOnDemandAPI(demand?.id);
  }

  void userCancelOnDemandAPI(String reason) {
    _commonBloc.vendorRejectOnDemandAPI(demand?.id, reason);
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
        case ApiType.ON_DEMAND_VENDOR_APPROVE:
          {}

        case ApiType.ON_DEMAND_VENDOR_PAYMENT:
          {}

        case ApiType.ON_DEMAND_VENDOR_AMOUNT:
          {}

        case ApiType.ON_DEMAND_VENDOR_REJECT:
          {
            var res = CommonResponse.fromJson(map);
            AppUtils.showToast(res.message);
            Navigator.pop(context);
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
