import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../constants/fonts.dart';
import '../constants/color_constants.dart';
import '../constants/drawable_constant.dart';

class CacheImage extends StatelessWidget {
  final String? url;
  final double? w;
  final double? h;
  final double round;
  final String placeholder;
  final String name;
  final double fontSize;
  final Uint8List? filePhoto;

  CacheImage({
    required this.url,
    this.placeholder = DrawableConstant.ic_placeholder,
    this.w = null,
    this.h = null,
    this.name = '',
    this.fontSize = 15,
    this.filePhoto,
    this.round = 0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: w,
      height: h,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(round),
        child: _widgetGetImageName(url, name, filePhoto),
      ),
    );
  }

  Widget _widgetGetImageName(String? url, String? name, Uint8List? filePhoto) {
    if (url != null && url.isNotEmpty && url.contains('http') && url.contains('https')) {
      return CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.cover,
        placeholder:
            (context, url) => Container(
              color: AppColor.borderColor,
              width: w,
              height: h,
              child: Image.asset(fit: BoxFit.cover, placeholder, width: w, height: h),
            ),
        errorWidget:
            (context, url, error) => Container(
              color: AppColor.borderColor,
              width: w,
              height: h,
              child: Container(
                child: Image.asset(fit: BoxFit.cover, placeholder, width: w, height: h),
              ),
            ),
      );
    } else if (filePhoto != null) {
      return Image.memory(filePhoto, width: w, height: h, fit: BoxFit.cover);
    } else {
      return _widgetRectUI(name, w, h);
    }
  }

  Widget _widgetMemberCircleUI(String? name, double w, double h) {
    return Container(
      alignment: Alignment.center,
      height: h,
      width: w,
      decoration:
          name?.isEmpty == true
              ? null
              : BoxDecoration(
                color: AppColor.color_D6D6D6,
                border: Border.all(color: AppColor.white, width: 2),
                borderRadius: BorderRadius.all(Radius.circular(w / 2)),
              ),
      child:
          name?.isEmpty == true
              ? Image.asset(fit: BoxFit.cover, placeholder, width: w, height: h)
              : Text(
                name ?? '',
                style: TextStyle(
                  fontFamily: Fonts.SEMI_BOLD,
                  fontSize: fontSize,
                  color: AppColor.black,
                ),
              ),
    );
  }

  Widget _widgetRectUI(String? name, double? w, double? h) {
    return Container(
      alignment: Alignment.center,
      height: h,
      width: w,
      decoration:
          name?.isEmpty == true
              ? null
              : BoxDecoration(
                color: AppColor.color_D6D6D6,
                border: Border.all(color: AppColor.white, width: 2),
                borderRadius: BorderRadius.all(Radius.circular(round)),
              ),
      child:
          name?.isEmpty == true
              ? Image.asset(fit: BoxFit.cover, placeholder, width: w, height: h)
              : Text(
                name ?? '',
                style: TextStyle(
                  fontFamily: Fonts.SEMI_BOLD,
                  fontSize: fontSize,
                  color: AppColor.black,
                ),
              ),
    );
  }
}
