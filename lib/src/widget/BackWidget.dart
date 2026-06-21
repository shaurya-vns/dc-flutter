import 'package:flutter/material.dart';

class BackWidget extends StatelessWidget {
  final String title;
  final String hint;

  BackWidget({required this.title, this.hint = ''});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 3), // 3 px downwards
            blurRadius: 6,
            spreadRadius: 0,
          ),
        ],
      ),
      child: AppBar(
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: BackButton(),
        actions: [],
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: Colors.black87)),
            Text(hint, style: TextStyle(fontSize: 14, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
