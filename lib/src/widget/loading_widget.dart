import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shimmer/shimmer.dart';

import '../ui/dashboard/ai/ChatMessage.dart';

class LoadingWidget extends StatelessWidget {
  final ChatMessage? chat;

  LoadingWidget({this.chat});

  final StreamController<List<String>?> galleryListStream = BehaviorSubject();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade400,
      highlightColor: Colors.white,
      child: Text(
        chat?.text ?? '',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.white, // Important
        ),
      ),
    );
  }
}

//TypingEffectWidget()
