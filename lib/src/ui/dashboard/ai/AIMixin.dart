import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

import '../../../model/response/ai/AIData.dart';
import 'ChatMessage.dart';

mixin AIMixin {
  TextEditingController aiController = TextEditingController();

  final StreamController<List<ChatMessage>> chatListStream = BehaviorSubject();
  final StreamController<bool> visibleStream = BehaviorSubject();

  final List<ChatMessage> messages = [];
  ScrollController scrollController = ScrollController();
  ChatMessage? currentAIMessage;
  String? currentMes = '';
  String userName = '';

  void addMessage(String message) {
    currentMes = message;
    currentAIMessage = ChatMessage(
      isLoading: true,
      prompt: message,
      text: '',
      type: 'Loading....',
    );
    messages.add(currentAIMessage!);
    chatListStream.sink.add(messages);
  }

  void handleDecodedEvent(AIData? data) {
    var currentAIMessage = ChatMessage(
      isLoading: false,
      prompt: currentMes,
      text: data?.message ?? '',
      type: data?.type ?? 'text',
    );
    messages[messages.length - 1] = currentAIMessage!;
    chatListStream.sink.add(messages);
  }
}
