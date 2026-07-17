import 'package:flutter/material.dart';
import 'package:flutter_dc/src/widget/test_medium.dart';

import '../../../constants/color_constants.dart';
import '../../../model/base_error.dart';
import '../../../utils/app_constant.dart';
import '../../../utils/app_utils.dart';
import '../../common_bloc.dart';
import 'ChatBubble.dart';
import 'ai_repository.dart';

class AIPage extends StatefulWidget {
  const AIPage({Key? key}) : super(key: key);

  @override
  State<AIPage> createState() => _AIPageState();
}

class _AIPageState extends State<AIPage> {
  late CommonBloc _commonBloc;
  final TextEditingController controller = TextEditingController();
  final ScrollController scrollController = ScrollController();

  List<Map<String, dynamic>> messages = [
    {
      "isUser": false,
      "message": "Hi Umesh 👋\nI am your Tiffin AI Assistant.\nHow can I help you today?",
    },
  ];

  bool loading = false;

  @override
  void initState() {
    super.initState();
    _commonBloc = CommonBloc(context);
    WidgetsBinding.instance.addPostFrameCallback((_) => onPostFrameCallback(context));
  }

  onPostFrameCallback(BuildContext context) {
    setObservables();
    scrollBottom();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        backgroundColor: AppColor.color_bg,
        resizeToAvoidBottomInset: true,
        //  bottomSheet: _inputBox(),
        appBar: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: AppColor.color_bg,
          foregroundColor: Colors.black,
          title: Text(
            'Hello TIFIN AI, 👋',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        body: _widgetChat(),
      ),
    );
  }

  Widget _widgetChat() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: scrollController,
            padding: const EdgeInsets.only(bottom: 100),
            itemCount: 30,
            itemBuilder: (context, index) {
              return ChatBubble(
                isUser: false,
                message: 'q eqwej qpwoe jqpwoj eqwpoe qwe',
              );
            },
          ),
        ),
        if (loading)
          const Padding(
            padding: EdgeInsets.all(8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextMedium(str: "AI is typing..."),
            ),
          ),

        _inputBox(),
      ],
    );
  }

  void scrollBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,

          duration: const Duration(milliseconds: 300),

          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget _inputBox() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: TextField(
                  controller: controller,
                  minLines: 1,
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  decoration: const InputDecoration(
                    hintText: "Ask anything...",
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),

                  onTap: () {
                    scrollBottom();
                  },
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: sendMessage,
              child: Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: AppColor.colorBlue,
                  shape: BoxShape.circle,
                ),

                child: const Icon(Icons.send_rounded, color: Colors.white, size: 22),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> sendMessage() async {
    final text = controller.text.trim();

    if (text.isEmpty) {
      return;
    }

    setState(() {
      messages.add({"isUser": true, "message": text});

      // Empty AI bubble
      messages.add({"isUser": false, "message": ""});

      controller.clear();
    });

    final aiIndex = messages.length - 1;

    scrollBottom();

    /* await AIRepository.chatStream(
      message: text,

      onChunk: (chunk) {
        setState(() {
          messages[aiIndex]["message"] += chunk;
        });

        scrollBottom();
      },

      onDone: () {
        print("AI Completed");
      },

      onError: (error) {
        setState(() {
          messages[aiIndex]["message"] = "Error: $error";
        });
      },
    );*/
  }

  @override
  void dispose() {
    _commonBloc.onDispose();
    super.dispose();
  }

  void setObservables() {
    _commonBloc.apiResponse.listen((map) {
      var apiType = map[AppConstants.API_TYPE];

      switch (apiType) {}
    });

    _commonBloc.apiError.listen((error) {
      var baseError = BaseError.fromJson(error);
      AppUtils.showToast(baseError.message);
    });
    //validation error listener
  }
}
