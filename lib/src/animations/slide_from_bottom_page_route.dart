import 'package:flutter/material.dart';

class SlideFromBottomPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  SlideFromBottomPageRoute({required this.page})
    : super(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionDuration: Duration(milliseconds: 500),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final begin = Offset(0.0, 1.0); // bottom
          final end = Offset.zero;
          final curve = Curves.easeInOut;

          final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          final offsetAnimation = animation.drive(tween);

          return SlideTransition(position: offsetAnimation, child: child);
        },
      );
}
