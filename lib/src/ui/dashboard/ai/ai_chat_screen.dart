import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dc/src/utils/app_constant.dart';
import 'package:flutter_dc/src/utils/widgetUtils.dart';
import 'package:rxdart/rxdart.dart';

import '../../../constants/color_constants.dart';
import '../../../constants/drawable_constant.dart';
import '../../../widget/ai_field_widget.dart';
import '../../../widget/click_widget.dart';
import '../../../widget/icon_widget.dart';
import '../../../widget/loading_widget.dart';
import '../../../widget/rounded_container.dart';
import '../../../widget/test_regular.dart';
import '../../../widget/test_semi.dart';
import 'AIMixin.dart';
import 'ChatMessage.dart';
import 'message_widget.dart';

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> with AIMixin {
  FocusNode messageNode = FocusNode();
  final StreamController<bool> isTypingStream = BehaviorSubject();

  @override
  void initState() {
    var user = USER_DATA;
    userName = user?.name ?? '';
    super.initState();
    visibleStream.sink.add(true);
  }

  double GAP_BOTTOM = 0;

  @override
  Widget build(BuildContext context) {
    aiController.text = 'Give me my subscription';
    if (Platform.isAndroid) {
      GAP_BOTTOM = 12;
    } else if (Platform.isIOS) {
      GAP_BOTTOM = 40;
    }
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        bottomSheet: _widgetAIUI(context),
        appBar: AppBar(toolbarHeight: 0, backgroundColor: AppColor.black),
        backgroundColor: AppColor.color_bg,
        body: Stack(
          children: [
            _widgetCrossUI(),
            Padding(
              padding: const EdgeInsets.only(top: 110, bottom: 100),
              child: _widgetList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _widgetCrossUI() {
    return Container(
      color: AppColor.black,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Row(
                children: [
                  SizedBox(width: 10),
                  Image.asset(DrawableConstant.ic_test, width: 30, height: 30),
                  SizedBox(width: 10),
                  Expanded(child: TextSemi(str: 'AI ', color: AppColor.white, size: 16)),
                  IconButton(
                    icon: Icon(Icons.close, size: 30),
                    color: AppColor.white,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
          Container(height: 0.25, color: AppColor.borderColor),
        ],
      ),
    );
  }

  Widget _widgetAIUI(context1) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          color: AppColor.black,
          child: Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
            child: Column(
              children: [
                Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColor.white,
                    border: Border.all(color: AppColor.white, width: 2),
                    borderRadius: BorderRadius.all(Radius.circular(3)),
                  ),

                  child: Row(
                    children: [
                      Expanded(
                        child: AIFieldWidget(
                          messageNode: messageNode,
                          isAIAssistant: true,
                          controller: aiController,
                          autoFocus: true,
                          onChanged: (str) {
                            var isShow = str?.length == 0;
                            isTypingStream.sink.add(!isShow);
                          },
                          onSubmitted: () {
                            startSSEStream(aiController.text);
                          },
                        ),
                      ),
                      ClickWidget(
                        paddingRight: 5,
                        paddingLeft: 5,
                        paddingTop: 5,
                        onClick: () {
                          startSSEStream(aiController.text);
                        },
                        child: StreamBuilder<bool>(
                          stream: isTypingStream.stream,
                          builder: (context, snapshot) {
                            bool isFocus = false;
                            if (snapshot.hasData) {
                              isFocus = snapshot.data ?? false;
                            }
                            return Container(
                              padding: EdgeInsets.all(8),
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: isFocus ? AppColor.black : AppColor.color_EEEFE9,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Image.asset(
                                color:
                                    isFocus
                                        ? AppColor.color_7ED96C
                                        : AppColor.color_9F9F9B,
                                DrawableConstant.ic_sent_chat,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                WidgetUtils.getAICheck(),
                SizedBox(height: GAP_BOTTOM),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _widgetList() {
    return SingleChildScrollView(
      controller: scrollController,
      scrollDirection: Axis.vertical,
      child: StreamBuilder<List<ChatMessage>>(
        stream: chatListStream.stream,
        builder: (context, snapshot) {
          print('data data dd ');
          if (snapshot.hasData) {
            var data = snapshot.data;

            print('data data ${data?.length}');

            return ListView.builder(
              itemCount: data?.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final chat = data?[index];

                print('data data ${chat?.text}');
                print('data data ${chat?.prompt}');
                print('data data ${chat?.type}');

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RoundedContainer(
                            width: 40,
                            height: 40,
                            rounded: 20,
                            border: AppColor.black,
                            color: AppColor.black,
                            stroke: 1,
                            child: TextSemi(str: 'U', color: AppColor.white, size: 14),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 12, right: 12),
                      child: TextRegular(
                        str: chat?.prompt,
                        color: AppColor.black,
                        size: 16.5,
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.only(
                        left: 12,
                        right: 12,
                        top: 15,
                        bottom: 10,
                      ),
                      width: SCREEN_WIDTH,
                      color: AppColor.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RoundedContainer(
                            width: 32,
                            height: 32,
                            rounded: 20,
                            padding: 8,
                            border: AppColor.color_C2C2C2,
                            color: AppColor.white,
                            stroke: 1,
                            child: Image.asset(DrawableConstant.ic_tab_5),
                          ),
                          SizedBox(height: 8),
                          chat?.isLoading == true
                              ? LoadingWidget()
                              : MessageWidget(msg: chat?.text),
                          SizedBox(height: 15),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          }
          return Container();
        },
      ),
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    messageNode.dispose();
    super.dispose();
  }
}
