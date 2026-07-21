import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dc/src/utils/app_constant.dart';
import 'package:flutter_dc/src/widget/rounded_container.dart';
import 'package:rxdart/rxdart.dart';

import '../../../bottomsheet/ai_help_bottom_sheet.dart';
import '../../../constants/color_constants.dart';
import '../../../constants/fonts.dart';
import '../../../model/base_error.dart';
import '../../../model/response/ai/AIResponse.dart';
import '../../../network/api_request_codes.dart';
import '../../../utils/app_utils.dart';
import '../../../utils/gap.dart';
import '../../../widget/loading_widget.dart';
import '../../../widget/message_widget.dart';
import '../../../widget/test_regular.dart';
import '../../../widget/test_semi.dart';
import '../../common_bloc.dart';
import 'AIMixin.dart';
import 'ChatMessage.dart';

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> with AIMixin {
  FocusNode messageNode = FocusNode();
  final StreamController<bool> isTypingStream = BehaviorSubject();

  late CommonBloc _commonBloc;

  @override
  void initState() {
    super.initState();
    _commonBloc = CommonBloc(context);

    var user = USER_DATA;
    userName = user?.name ?? '';
    super.initState();
    visibleStream.sink.add(true);
    WidgetsBinding.instance.addPostFrameCallback((_) => onPostFrameCallback(context));
  }

  onPostFrameCallback(BuildContext context) {
    setObservables();
    chatListStream.sink.add(messages);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        backgroundColor: AppColor.color_bg,
        resizeToAvoidBottomInset: true,
        bottomSheet: _widgetAIUI(),
        appBar: AppBar(
          toolbarHeight: 0,
          scrolledUnderElevation: 0,
          backgroundColor: AppColor.black,
          foregroundColor: Colors.black,
        ),
        body: Stack(
          children: [
            _widgetTab(),
            Padding(padding: const EdgeInsets.only(top: 42), child: _widgetList()),
          ],
        ),
      ),
    );
  }

  Widget _widgetTab() {
    return Container(
      color: AppColor.black,
      alignment: Alignment.center,
      height: 40,
      child: Row(
        children: [
          Gap(w: 20),
          TextSemi(str: 'AI TIFFIN', color: AppColor.white, size: 14),
          Spacer(flex: 1),
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.close, color: AppColor.white, size: 26),
          ),
        ],
      ),
    );
  }

  Widget _widgetAIUI() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _widgetHint(),
            Gap(h: 10),
            Row(
              children: [
                Gap(w: 3),
                IconButton(
                  onPressed: () {
                    showSheet();
                  },
                  icon: const Icon(Icons.auto_awesome),
                  tooltip: "Suggestions",
                ),
                Gap(w: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: TextField(
                      focusNode: messageNode,
                      controller: aiController,
                      minLines: 1,
                      maxLines: 5,
                      onTapOutside: (PointerDownEvent event) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      keyboardType: TextInputType.multiline,
                      style: TextStyle(
                        color: AppColor.black,
                        fontFamily: Fonts.MEDIUM,
                        fontSize: 14,
                      ),
                      textInputAction: TextInputAction.newline,
                      decoration: const InputDecoration(
                        hintText: "Ask about products, orders...",
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: AppColor.black,
                          fontFamily: Fonts.REGULAR,
                          fontSize: 15,
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                      ),

                      onTap: () {},
                    ),
                  ),
                ),
                Gap(w: 10),
                Material(
                  color: AppColor.colorBlue,
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () {
                      if (AppUtils.isNotBlank(aiController.text))
                        chatStreamAPI(aiController.text);
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(Icons.send_rounded, color: Colors.white, size: 22),
                    ),
                  ),
                ),
                Gap(w: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _widgetList() {
    return SingleChildScrollView(
      controller: scrollController,
      scrollDirection: Axis.vertical,
      child: StreamBuilder<List<ChatMessage>>(
        stream: chatListStream.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.data;
            if (data?.isEmpty == true) {
              return _widgetNoUI();
            }
            return ListView.builder(
              itemCount: data?.length,
              shrinkWrap: true,
              padding: EdgeInsets.only(bottom: 250),
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final chat = data?[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [userMessage(chat?.prompt ?? ''), aiMessage(chat)],
                );
              },
            );
          }
          return Container();
        },
      ),
    );
  }

  Widget userMessage(String chat) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(60, 8, 12, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextSemi(str: USER_DATA?.name ?? "You", size: 12, color: Colors.grey),

            const SizedBox(height: 6),

            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColor.colorBlue,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                ),
              ),
              child: TextRegular(str: chat, color: Colors.white, size: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget aiMessage(ChatMessage? chat) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 1, 20, 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(radius: 18, child: Icon(Icons.smart_toy)),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Tiffin Assistant",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: AppColor.black,
                    ),
                  ),
                  const SizedBox(height: 6),
                  chat?.isLoading == true
                      ? LoadingWidget(chat: chat)
                      : Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColor.color_bg,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(14),
                            bottomLeft: Radius.circular(14),
                            bottomRight: Radius.circular(14),
                          ),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: MessageWidget(msg: chat?.text),
                      ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showSheet() {
    showModalBottomSheet<dynamic>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return AIHelpBottomSheet(
          callback: (String data) {
            chatStreamAPI(data);
          },
        );
      },
    );
  }

  void chatStreamAPI(String message) {
    addMessage(message);
    _commonBloc.chatStreamAPI(message);
    scrollToBottom();
  }

  @override
  void dispose() {
    scrollController.dispose();
    messageNode.dispose();
    _commonBloc.onDispose();
    super.dispose();
  }

  void setObservables() {
    _commonBloc.apiResponse.listen((map) {
      var apiType = map[AppConstants.API_TYPE];

      switch (apiType) {
        case ApiType.CHAT_STREAM:
          {
            var res = AIResponse.fromJson(map);
            handleDecodedEvent(res.data);
            scrollToBottom();
          }
      }
    });

    _commonBloc.apiError.listen((error) {
      var baseError = BaseError.fromJson(error);
      AppUtils.showToast(baseError.message);
    });
    //validation error listener
  }

  Widget _widgetNoUI() {
    return Container(
      padding: const EdgeInsets.all(30),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          const Icon(Icons.auto_awesome, size: 60, color: Colors.orange),

          const SizedBox(height: 16),

          TextSemi(str: "I'm your Tiffin Assistant 🍱", size: 20),

          const SizedBox(height: 8),

          TextRegular(
            str: "Ask me anything about meals, orders, subscriptions, or support.",
            align: 2,
            size: 14,
          ),

          const SizedBox(height: 24),

          _aiHintCard("🍛 Track my today one time order"),

          _aiHintCard("📦 My subscription today order"),

          _aiHintCard("📅 Show my subscription"),

          _aiHintCard("👑 Show products"),

          _aiHintCard("🎁 Track my today on demand order"),

          _aiHintCard("🤝 Contact support"),
        ],
      ),
    );
  }

  Widget _aiHintCard(String text) {
    return InkWell(
      onTap: () {
        chatStreamAPI(text);
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: TextSemi(str: text, size: 15),
      ),
    );
  }

  Widget _widgetHint() {
    final hints = [
      {"icon": "📦", "text": "Track my today one time order"},
      {"icon": "🍱", "text": "My subscription today order"},
      {"icon": "📅", "text": "Show my subscription"},
      {"icon": "🍽️", "text": "Show products"},
      {"icon": "✨", "text": "Track my today on demand order"},
      {"icon": "🤝", "text": "Contact support"},
    ];

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: hints.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          return _aiHintCard1(hints[index]["icon"]!, hints[index]["text"]!);
        },
      ),
    );
  }

  Widget _aiHintCard1(String icon, String text) {
    return InkWell(
      borderRadius: BorderRadius.circular(25),
      onTap: () {
        chatStreamAPI(text);
      },

      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 3),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),

        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(icon, style: const TextStyle(fontSize: 13)),
            const SizedBox(width: 6),
            TextRegular(str: text, size: 13),
          ],
        ),
      ),
    );
  }

  void scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
        );
      }
    });
  }
}
