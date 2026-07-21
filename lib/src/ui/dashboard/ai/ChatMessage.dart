class ChatMessage {
  final String? prompt;
  final String text;
  final String type;
  final bool isLoading;

  ChatMessage({
    required this.text,
    required this.isLoading,
    required this.prompt,
    required this.type,
  });
}
