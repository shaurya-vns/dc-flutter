import 'package:flutter/material.dart';

import '../constants/color_constants.dart';
import '../constants/drawable_constant.dart';

class BaseWidget extends StatefulWidget {
  final Widget child;
  final bool? showProgressLoader;
  final Stream<bool>? progressLoaderStream;

  const BaseWidget({
    required this.child,
    this.showProgressLoader,
    this.progressLoaderStream,
  });

  @override
  _BaseWidgetState createState() => _BaseWidgetState();
}

class _BaseWidgetState extends State<BaseWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Stack(
      children: <Widget>[
        StreamBuilder<Object>(
          stream: widget.progressLoaderStream,
          initialData: false,
          builder: (context, snapshot) {
            print('object $snapshot');
            return AbsorbPointer(absorbing: snapshot.data as bool, child: widget.child);
          },
        ),
        StreamBuilder<Object>(
          stream: widget.progressLoaderStream,
          builder: (context, snapshot) {
            print('object ww $snapshot');
            return snapshot.data == true
                ? Container(
                  color: AppColor.black.withOpacity(0.6),
                  width: w,
                  height: h,
                  child: Center(
                    child: Container(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          ClipOval(
                            child: Image.asset(
                              DrawableConstant.ic_splash,
                              width: 50,
                              height: 50,
                            ),
                          ),
                          Transform.scale(
                            scale: 1.5,
                            child: const CircularProgressIndicator(
                              backgroundColor: AppColor.white,
                              valueColor: AlwaysStoppedAnimation<Color>(AppColor.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                : Container();
          },
        ),
      ],
    );
  }
}
