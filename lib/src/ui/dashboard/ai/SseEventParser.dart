import 'dart:convert';

class SseEventParser {
  String _buffer = "";

  String? processChunk(String chunk) {
    _buffer += chunk;

    String result = "";

    while (_buffer.contains("\n\n")) {
      final eventEnd = _buffer.indexOf("\n\n");

      final event = _buffer.substring(0, eventEnd);

      _buffer = _buffer.substring(eventEnd + 2);

      final lines = event.split("\n");

      for (final line in lines) {
        if (line.startsWith("data:")) {
          final data = line.substring(5);

          result += data;
        }
      }
    }

    if (result.isNotEmpty) {
      return result;
    }

    return null;
  }
}
