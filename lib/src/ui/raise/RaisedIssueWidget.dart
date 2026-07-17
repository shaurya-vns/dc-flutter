import 'package:flutter/material.dart';
import 'package:flutter_dc/src/widget/test_regular.dart';

import '../../constants/color_constants.dart';
import '../../utils/app_utils.dart';
import '../../widget/test_semi.dart';
import 'RaiseSupportPage.dart';

class RaisedIssueWidget extends StatefulWidget {
  const RaisedIssueWidget({super.key});

  @override
  State<RaisedIssueWidget> createState() => _RaisedIssueWidgetState();
}

class _RaisedIssueWidgetState extends State<RaisedIssueWidget> {
  @override
  Widget build(BuildContext context) {
    return _widgetRaiseIssue();
  }

  Widget _widgetRaiseIssue() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 5, 16, 15),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          AppUtils.launchScreen(context, RaiseSupportPage(orderId: 1, orderType: 1));
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.red.shade100),
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.support_agent, color: Colors.red, size: 28),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextSemi(str: "Need Help?", size: 17, color: AppColor.black),
                    const SizedBox(height: 4),
                    TextRegular(
                      str: "Report an issue with this order or contact support.",
                      size: 14,
                      color: AppColor.color_B0B0B0,
                    ),
                  ],
                ),
              ),

              const Icon(Icons.arrow_forward_ios_rounded, size: 18, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
