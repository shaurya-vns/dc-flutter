import 'package:flutter/material.dart';

class CommonStreamBuilder<T> extends StatelessWidget {
  final Stream<T> stream;
  final Widget Function(BuildContext context, T? data) builder;
  final Widget? loadingWidget;
  final Widget? noWidget;

  const CommonStreamBuilder({
    super.key,
    required this.stream,
    required this.builder,
    this.loadingWidget,
    this.noWidget,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var data = snapshot.data;
          return builder(context, data);
        } else
          return noWidget ?? SizedBox();
      },
    );
  }
}
