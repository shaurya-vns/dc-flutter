import 'package:flutter/material.dart';

class CommonStreamBuilder<T> extends StatelessWidget {
  final Stream<T> stream;
  final Widget Function(BuildContext context, T? data) builder;
  final Widget? nothing;
  final Widget? shimmer;

  const CommonStreamBuilder({
    super.key,
    required this.stream,
    required this.builder,
    this.nothing,
    this.shimmer,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return shimmer ?? const SizedBox();
        }

        if (!snapshot.hasData) {
          return nothing ?? SizedBox();
        }

        final data = snapshot.data;

        if (data is List && data.isEmpty) {
          return nothing ?? SizedBox();
        }

        return builder(context, data);
      },
    );
  }
}
