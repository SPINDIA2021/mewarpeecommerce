import 'dart:io';

import 'package:flutter_sixvalley_ecommerce/eclassify/Utils/ui_utils.dart';
import 'package:flutter/material.dart';

class ImageAdapter extends StatelessWidget {
  final dynamic image;

  const ImageAdapter({super.key, this.image});

  @override
  Widget build(BuildContext context) {
    if (image is String) {
      return UiUtils.getImage(
        image,
        fit: BoxFit.cover,
      );
    } else if (image is File) {
      return Image.file(
        image,
        fit: BoxFit.cover,
      );
    }
    return Container();
  }
}