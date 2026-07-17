import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final bool isUser;

  final String message;

  const ChatBubble({super.key, required this.isUser, required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,

      child: Container(
        margin: const EdgeInsets.only(bottom: 10),

        padding: const EdgeInsets.all(14),

        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .75),

        decoration: BoxDecoration(
          color: isUser ? Colors.green.shade400 : Colors.grey.shade200,

          borderRadius: BorderRadius.circular(16),
        ),

        child: Text(
          message,

          style: TextStyle(color: isUser ? Colors.white : Colors.black87, fontSize: 15),
        ),
      ),
    );
  }
}
