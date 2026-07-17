import 'dart:convert';

import 'package:flutter_dc/src/network/api_request_codes.dart';
import 'package:flutter_dc/src/utils/app_constant.dart';
import 'package:http/http.dart' as http;

class AIRepository {
  static Future<void> chatStream({
    required String message,
    required Function(String chunk) onChunk,
    required Function() onDone,
    required Function(String error) onError,
  }) async {
    try {
      final request = http.Request(
        "POST",
        Uri.parse("${BaseUrl.BASE_URL}ai/chat-stream"),
      );

      request.headers.addAll({
        "token": ACCESS_TOKEN,
        "Content-Type": "application/json",
        "Accept": "text/event-stream",
      });

      print('response ${message}');

      request.body = jsonEncode({"message": message});

      final response = await request.send();

      print('response ${response.statusCode}');

      if (response.statusCode != 200) {
        onError("Something went wrong");
        return;
      }

      response.stream
          .transform(utf8.decoder)
          .listen(
            (data) {
              final lines = data.split("\n");

              for (final line in lines) {
                if (line.startsWith("data:")) {
                  final text = line.replaceFirst("data:", "").trim();

                  if (text.isNotEmpty) {
                    onChunk(text);
                  }
                }
              }
            },

            onDone: () {
              onDone();
            },

            onError: (error) {
              onError(error.toString());
            },
          );
    } catch (e) {
      onError(e.toString());
    }
  }
}
