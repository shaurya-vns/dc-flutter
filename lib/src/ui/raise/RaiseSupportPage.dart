import 'package:flutter/material.dart';
import 'package:flutter_dc/src/model/common_response.dart';
import 'package:flutter_dc/src/utils/app_utils.dart';
import 'package:flutter_dc/src/widget/base_widget.dart';
import 'package:flutter_dc/src/widget/fill_button_widget.dart';
import 'package:flutter_dc/src/widget/message_field_widget.dart';

import '../../constants/color_constants.dart';
import '../../model/base_error.dart';
import '../../network/api_request_codes.dart';
import '../../utils/app_constant.dart';
import '../../widget/rounded_container.dart';
import '../../widget/scaffold_widget.dart';
import '../../widget/test_regular.dart';
import '../../widget/test_semi.dart';
import '../common_bloc.dart';

class RaiseSupportPage extends StatefulWidget {
  final int orderId;
  final int orderType;

  const RaiseSupportPage({super.key, required this.orderId, required this.orderType});

  @override
  State<RaiseSupportPage> createState() => _RaiseSupportPageState();
}

class _RaiseSupportPageState extends State<RaiseSupportPage> {
  late CommonBloc _commonBloc;
  FocusNode titleNode = FocusNode();
  FocusNode desdNode = FocusNode();

  TextEditingController descriptionController = TextEditingController();

  int issueType = 1;

  final List<Map<String, dynamic>> issueList = [
    {"id": 1, "title": "Order"},
    {"id": 2, "title": "Payment"},
    {"id": 3, "title": "Delivery"},
    {"id": 4, "title": "Food Quality"},
    {"id": 5, "title": "Refund"},
    {"id": 6, "title": "Other"},
  ];

  @override
  void initState() {
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
        title: "Raise Issue Order",
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _orderCard(),
              const SizedBox(height: 15),
              TextSemi(str: "Issue Type", size: 15, color: AppColor.black),
              const SizedBox(height: 5),
              Wrap(
                spacing: 10,
                runSpacing: 3,
                children:
                    issueList.map((e) {
                      bool selected = issueType == e["id"];
                      return ChoiceChip(
                        label: Text(e["title"]),
                        selected: selected,
                        onSelected: (_) {
                          setState(() {
                            issueType = e["id"];
                          });
                        },
                      );
                    }).toList(),
              ),

              const SizedBox(height: 15),
              TextSemi(str: 'Describe Issue'),
              const SizedBox(height: 5),
              MessageFieldWidget(
                maxLines: 4,
                maxLength: 500,
                preNode: desdNode,
                controller: descriptionController,
                onTypeChange: (String value) {},
                hint: 'Describe your issue...',
              ),

              const SizedBox(height: 25),
              FillButtonWidget(
                title: 'Submit',
                onPressed: () {
                  submit();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _orderCard() {
    return RoundedContainer(
      rounded: 14,
      padding: 15,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextSemi(str: "Order Information", size: 16, color: AppColor.black),
          const SizedBox(height: 10),
          _row("Order ID", "#${widget.orderId}"),
          _row("Order Type", getOrderType(widget.orderType)),
        ],
      ),
    );
  }

  Widget _row(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: TextRegular(size: 15, str: title, color: AppColor.color_B0B0B0),
          ),
          TextSemi(str: value, color: AppColor.black, size: 15),
        ],
      ),
    );
  }

  String getOrderType(int type) {
    switch (type) {
      case 1:
        return "Subscription";
      case 2:
        return "One Time";
      case 3:
        return "On Demand";
      default:
        return "";
    }
  }

  void submit() {
    var des = descriptionController.text.trim();
    if (des.isEmpty) {
      AppUtils.showToast("Describe your issue.");
      return;
    }

    _commonBloc.createRaiseIssueAPI(widget.orderId, widget.orderType, issueType, des);
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
        case ApiType.CREATE_ISSUE_TICKET:
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
