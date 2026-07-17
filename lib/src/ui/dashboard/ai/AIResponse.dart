class AIResponse {
  final String title;
  final String message;
  final String type;
  final List data;

  AIResponse({
    required this.title,
    required this.message,
    required this.type,
    required this.data,
  });

  factory AIResponse.fromJson(Map<String, dynamic> json) {
    return AIResponse(
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      type: json['type'] ?? 'text',
      data: json['data'] ?? [],
    );
  }
}
