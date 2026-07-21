import 'package:flutter/material.dart';
import 'package:flutter_dc/src/constants/color_constants.dart';
import 'package:flutter_dc/src/widget/custome_line.dart';
import 'package:flutter_dc/src/widget/fix_button_widget.dart';
import 'package:flutter_dc/src/widget/test_medium.dart';

import '../utils/ai_data.dart';
import '../utils/gap.dart';

class AIHelpBottomSheet extends StatefulWidget {
  final Function(String model) callback;

  AIHelpBottomSheet({required this.callback});

  @override
  _AIHelpBottomSheetState createState() => _AIHelpBottomSheetState();
}

class _AIHelpBottomSheetState extends State<AIHelpBottomSheet> {
  @override
  @override
  Widget build(BuildContext context) {
    final data = CHATBOT_QUERIES;
    final categories = data.keys.toList();
    return DefaultTabController(
      length: categories.length,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * .72,
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              width: 45,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(20),
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              "AI Tooltips Suggestions",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 5),

            TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              tabs: categories.map((e) => Tab(text: e.replaceAll("_", " "))).toList(),
            ),

            Expanded(
              child: TabBarView(
                children:
                    categories.map((category) {
                      final queries = data[category]!;

                      return ListView.builder(
                        itemCount: queries.length,
                        itemBuilder: (context, index) {
                          final query = queries[index];

                          return Column(
                            children: [
                              FixButtonWidget(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Gap(w: 25),
                                    Expanded(
                                      child: TextMedium(
                                        str: query,
                                        size: 14,
                                        color: AppColor.black,
                                      ),
                                    ),
                                    Icon(Icons.arrow_forward_ios, size: 16),
                                    Gap(w: 20),
                                  ],
                                ),
                                onPressed: () {
                                  widget.callback(query);
                                  Navigator.pop(context);
                                },
                                borderColor: AppColor.trans,
                                color: AppColor.trans,
                              ),
                              CustomLine(),
                            ],
                          );
                        },
                      );
                    }).toList(),
              ),
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}
