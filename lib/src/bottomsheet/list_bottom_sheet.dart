import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../constants/fonts.dart';
import '../constants/color_constants.dart';
import '../constants/drawable_constant.dart';
import '../widget/click_widget.dart';

class ListBottomSheet extends StatefulWidget {
  final String? title;
  final List<String>? resourceList;
  final Function(String? model, bool isClear) onTypeClick;

  ListBottomSheet({
    required this.title,
    required this.resourceList,
    required this.onTypeClick,
  });

  @override
  _ListBottomSheetState createState() => _ListBottomSheetState();
}

class _ListBottomSheetState extends State<ListBottomSheet> {
  @override
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
          child: Container(
            color: AppColor.white,
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 6),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        width: 50,
                        height: 5,
                        decoration: BoxDecoration(
                          color: AppColor.color_E8E8E8,
                          border: Border.all(color: AppColor.color_D6D6D6, width: .6),
                          borderRadius: const BorderRadius.all(Radius.circular(15)),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 2),
                        child: ClickWidget(
                          child: Image.asset(
                            DrawableConstant.ic_cross,
                            width: 30,
                            height: 30,
                          ),
                          onClick: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.title ?? '',
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColor.color_041526,
                            fontFamily: Fonts.BOLD,
                          ),
                        ),
                      ),
                      ClickWidget(
                        onClick: () {},
                        child: Text(
                          'Clear',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColor.color_041526,
                            fontFamily: Fonts.REGULAR,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                ),

                SizedBox(height: 20),
                _widgetList(),
                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _widgetList() {
    var dataList = widget.resourceList;
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: dataList?.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        var d = dataList?[index];
        return SizedBox();
      },
    );
  }
}
