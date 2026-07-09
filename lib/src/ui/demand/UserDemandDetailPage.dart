import 'package:flutter/material.dart';
import 'package:flutter_dc/src/constants/color_constants.dart';
import 'package:flutter_dc/src/model/common_response.dart';
import 'package:flutter_dc/src/utils/AppStatus.dart';
import 'package:flutter_dc/src/utils/app_utils.dart';
import 'package:flutter_dc/src/utils/ext.dart';
import 'package:flutter_dc/src/utils/time_utils.dart';
import 'package:flutter_dc/src/widget/base_widget.dart';
import 'package:flutter_dc/src/widget/fill_button_widget.dart';
import 'package:flutter_dc/src/widget/rounded_container.dart';
import 'package:flutter_dc/src/widget/test_bold.dart';
import 'package:flutter_dc/src/widget/test_regular.dart';
import 'package:flutter_dc/src/widget/test_semi.dart';

import '../../model/base_error.dart';
import '../../model/response/ondemand/list/OnDemandData.dart';
import '../../network/api_request_codes.dart';
import '../../utils/app_constant.dart';
import '../../utils/dialog_utils.dart';
import '../../utils/gap.dart';
import '../../widget/scaffold_widget.dart';
import '../common_bloc.dart';

class UserDemandDetailPage extends StatefulWidget {
  final OnDemandData? data;

  const UserDemandDetailPage({super.key, required this.data});

  @override
  State<UserDemandDetailPage> createState() => _UserDemandDetailPageState();
}

class _UserDemandDetailPageState extends State<UserDemandDetailPage> {
  OnDemandData? data;

  late CommonBloc _commonBloc;

  @override
  void initState() {
    data = widget.data;
    super.initState();
    _commonBloc = CommonBloc(context);
    WidgetsBinding.instance.addPostFrameCallback((_) => onPostFrameCallback(context));
  }

  onPostFrameCallback(BuildContext context) {
    setObservables();
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      progressLoaderStream: _commonBloc.progressLoaderStream,
      child: ScaffoldWidget(
        title: 'Order# ${data?.orderNumber}',
        bottom: _bottomAction(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: [
              _foodHeader(data),
              const SizedBox(height: 10),
              _userCard(data),
              const SizedBox(height: 10),
              _userAddressCard(data),
              const SizedBox(height: 10),
              _detailCard(data),
              const SizedBox(height: 10),
              _priceCard(data),
              const SizedBox(height: 10),
              _noteCard(data),
              const SizedBox(height: 10),
              _cancelReasonCard(data),
              const SizedBox(height: 10),
              _rejectReasonCard(data),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _foodHeader(OnDemandData? data) {
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
            child: const Icon(Icons.restaurant, color: Color(0xffff6b35), size: 30),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextBold(str: data?.itemName, size: 16),
                TextSemi(
                  str: AppStatus.getStatus(data?.status),
                  color: AppColor.red,
                  size: 13,
                ),
                if (data?.status == AppStatus.waiting) ...[
                  Gap(h: 4),
                  Row(
                    children: [
                      RoundedContainer(
                        padding: 2,
                        alignment: Alignment.topLeft,
                        child: TextRegular(
                          str: 'You can approve or cancel vendor amount.',
                          size: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
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

  Widget _detailCard(OnDemandData? data) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title("Order Details", Icons.shopping_bag),
          const SizedBox(height: 15),
          _row("Quantity", '${data?.quantity}'),
          _row("Delivery Date", TimeUtils.parseDate2(data?.deliveryDate)),
          _row("Meal Type", data?.mealType?.toTitleCase()),
        ],
      ),
    );
  }

  Widget _priceCard(OnDemandData? data) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title("Price Details", Icons.currency_rupee),
          const SizedBox(height: 10),
          _priceRow(
            "User Amount",
            AppUtils.formatPrice(AppUtils.getDouble2(data?.userAmount)),
          ),
          const SizedBox(height: 8),
          if (AppUtils.isBlank(data?.vendorAmount) || data?.vendorAmount == '0.00') ...[
            _priceRow("Vendor Amount", 'Waiting from Vendor', valueColor: Colors.black),
          ] else ...[
            _priceRow(
              "Vendor Amount",
              AppUtils.formatPrice(AppUtils.getDouble2(data?.vendorAmount)),
              valueColor: Colors.green,
            ),
          ],

          const SizedBox(height: 10),

          if (AppUtils.isBlank(data?.vendorAmount) || data?.vendorAmount == '0.00') ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
              ),

              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Final Payable Amount",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                  ),

                  Text(
                    "${AppUtils.formatPrice(AppUtils.getDouble2(data?.userAmount))}",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                ],
              ),
            ),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
              ),

              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Final Payable Amount",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                  ),

                  Text(
                    "${AppUtils.formatPrice(AppUtils.getDouble2(data?.vendorAmount))}",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _noteCard(OnDemandData? data) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title("Additional Note", Icons.note),
          const SizedBox(height: 10),
          TextRegular(str: data?.note, size: 13),
        ],
      ),
    );
  }

  Widget _cancelReasonCard(OnDemandData? data) {
    if (AppUtils.isNotBlank(data?.cancelReason))
      return _card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _title("Cancel Reason", Icons.cancel_presentation),
            const SizedBox(height: 10),
            TextRegular(str: data?.cancelReason, size: 13),
          ],
        ),
      );
    return SizedBox();
  }

  Widget _rejectReasonCard(OnDemandData? data) {
    if (AppUtils.isNotBlank(data?.rejectReason))
      return _card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _title("Reject Reason by Vendor", Icons.remove_done),
            const SizedBox(height: 10),
            TextRegular(str: data?.rejectReason, size: 13),
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
        Icon(icon, color: const Color(0xffff6b35), size: 16),
        const SizedBox(width: 6),
        TextBold(str: text, color: AppColor.black, size: 16),
      ],
    );
  }

  Widget _row(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: TextSemi(str: title, size: 13)),
          TextRegular(str: value, align: 1, size: 13),
        ],
      ),
    );
  }

  Widget _priceRow(String title, String value, {Color? valueColor}) {
    return Row(
      children: [
        Expanded(child: TextRegular(str: title, size: 14)),
        TextSemi(str: value, color: valueColor, size: 13),
      ],
    );
  }

  Widget _bottomAction() {
    return data?.status == AppStatus.paid || data?.status == AppStatus.cancelled
        ? SizedBox()
        : Container(
          padding: const EdgeInsets.all(20),
          color: Colors.white,
          child: Row(
            children: [
              Expanded(
                child: FillButtonWidget(
                  bgColor: AppColor.black,
                  onPressed: () {
                    widgetCancelConfirm();
                  },
                  title: 'Cancel',
                ),
              ),
              const SizedBox(width: 12),
              data?.status == AppStatus.waiting
                  ? Expanded(
                    child: FillButtonWidget(
                      onPressed: () {
                        userApproveOnDemandAPI();
                      },
                      title: 'Accept Order',
                    ),
                  )
                  : SizedBox(),
            ],
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

  void userApproveOnDemandAPI() {
    _commonBloc.userApproveOnDemandAPI(data?.id);
  }

  void userCancelOnDemandAPI(String reason) {
    _commonBloc.userCancelOnDemandAPI(data?.id, reason);
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
        case ApiType.ON_DEMAND_USER_APPROVE:
          {
            var res = CommonResponse.fromJson(map);
            AppUtils.showToast(
              'You have confirm to approved your order. Now make your payment for this Order. Vendor Contact to You',
            );
            Navigator.pop(context);
          }

        case ApiType.ON_DEMAND_USER_CANCEL:
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
