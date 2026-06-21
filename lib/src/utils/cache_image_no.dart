import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../constants/fonts.dart';
import '../constants/color_constants.dart';
import '../constants/drawable_constant.dart';

class CacheImageNo extends StatelessWidget {
  final String url;
  final String placeholder;
  final Uint8List? filePhoto;

  CacheImageNo({
    required this.url,
    this.placeholder = DrawableConstant.ic_placeholder,
    this.filePhoto,
  });

  @override
  Widget build(BuildContext context) {
    return _widgetGetImageName(url, filePhoto);
  }

  Widget _widgetGetImageName(String? url, Uint8List? filePhoto) {
    if (url != null && url.isNotEmpty && url.contains('http') && url.contains('https')) {
      return CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.contain,
        placeholder:
            (context, url) => Container(
              color: AppColor.borderColor,
              child: Image.asset(fit: BoxFit.cover, placeholder),
            ),
        errorWidget:
            (context, url, error) => Container(
              color: AppColor.borderColor,
              child: Container(child: Image.asset(fit: BoxFit.cover, placeholder)),
            ),
      );
    } else if (filePhoto != null) {
      return Image.memory(filePhoto, fit: BoxFit.cover);
    } else {
      return _widgetRectUI();
    }
  }

  Widget _widgetRectUI() {
    return Container(
      alignment: Alignment.center,
      child: Image.asset(fit: BoxFit.cover, placeholder),
    );
  }
}
