import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_dc/src/network/api_request_codes.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

import '../../../utils/app_constant.dart';
import 'ChatMessage.dart';
import 'SseEventParser.dart';

mixin AIMixin {
  TextEditingController aiController = TextEditingController();

  final StreamController<List<ChatMessage>> chatListStream = BehaviorSubject();
  final StreamController<bool> visibleStream = BehaviorSubject();

  final List<ChatMessage> messages = [];
  ScrollController scrollController = ScrollController();
  ChatMessage? currentAIMessage;
  String? currentMes = '';
  String userName = '';

  final parser = SseEventParser();

  Future<void> startSSEStream(String message) async {
    currentMes = message;
    currentAIMessage = ChatMessage(
      isLoading: true,
      prompt: currentMes,
      text: '',
      type: 'Loading....',
    );
    messages.add(currentAIMessage!);
    //  aiController.text = '';

    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent + 300,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
    chatListStream.sink.add(messages);

    final uri = Uri.parse('${BaseUrl.BASE_URL}ai/chat-stream');

    final client = http.Client();

    final request = http.Request('POST', uri);

    request.headers.addAll({
      "token": ACCESS_TOKEN,

      "Accept": "*/*",

      "Content-Type": "application/json",
    });

    request.body = jsonEncode({"message": message});

    try {
      final response = await client.send(request);

      if (response.statusCode != 200) {
        print(await response.stream.bytesToString());
        return;
      }

      final stream = response.stream.transform(utf8.decoder);

      String buffer = "";

      await for (final chunk in stream) {
        final lines = chunk.split('\n');
        print('response lines $lines');

        for (final line in lines) {
          if (!line.startsWith('data:')) continue;

          final text = line.substring(5);
          print('response text $text');

          if (text.trim().isEmpty) continue;

          buffer += text;
        }
      }

      print('EEEEEEE buffer $buffer');

      if (buffer.isNotEmpty) {
        handleDecodedEvent(buffer);
      }
    } catch (e) {
    } finally {
      client.close();
    }
  }

  void handleDecodedEvent(String text) {
    currentAIMessage = ChatMessage(
      isLoading: false,
      prompt: currentMes,
      text: currentAIMessage!.text + text,
      type: currentAIMessage!.type,
    );

    messages[messages.length - 1] = currentAIMessage!;
    chatListStream.sink.add(messages);
  }

  void handleDecodedEvent1(Map<String, dynamic> decoded) {
    try {
      final type = decoded['type'] ?? '';
      var messageText = '';

      if (type == AI_TYPE.PARTIAL_TEXT) {
        messageText = decoded['data']['label'];
      }

      currentAIMessage = ChatMessage(
        isLoading: false,
        prompt: currentMes,
        text: currentAIMessage!.text + " " + messageText,
        type: currentAIMessage!.type,
      );

      messages[messages.length - 1] = currentAIMessage!;
      chatListStream.sink.add(messages);
    } catch (e) {}
  }
}
