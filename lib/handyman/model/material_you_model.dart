import 'package:flutter_sixvalley_ecommerce/handyman/main.dart';
import 'package:flutter_sixvalley_ecommerce/handyman/utils/colors.dart';
import 'package:flutter_sixvalley_ecommerce/handyman/utils/configs.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

Future<Color> getMaterialYouData() async {
  if (appStore.useMaterialYouTheme && await isAndroid12Above()) {
    primaryColor = await getMaterialYouPrimaryColor();
  } else {
    primaryColor = defaultPrimaryColor;
  }

  return primaryColor;
}
