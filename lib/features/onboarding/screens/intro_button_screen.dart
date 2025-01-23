import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_button_widget.dart';
import 'package:provider/provider.dart';

import '../../../localization/language_constrants.dart';
import '../../../main.dart';
import '../../../utill/app_constants.dart';
import '../../maintenance/maintenance_screen.dart';
import '../../splash/controllers/splash_controller.dart';
import '../../splash/domain/models/config_model.dart';
import '../../update/screen/update_screen.dart';

class IntroButtonScreen extends StatefulWidget {
  const IntroButtonScreen({super.key});

  @override
  State<IntroButtonScreen> createState() => _IntroButtonScreenState();
}

class _IntroButtonScreenState extends State<IntroButtonScreen> {
  // void initState() {
  //   super.initState();
  //   bool firstTime = true;
  // var   _onConnectivityChanged = Connectivity()
  //       .onConnectivityChanged
  //       .listen((ConnectivityResult result) {
  //     if (!firstTime) {
  //       bool isNotConnected = result != ConnectivityResult.wifi &&
  //           result != ConnectivityResult.mobile;
  //       isNotConnected
  //           ? const SizedBox()
  //           : ScaffoldMessenger.of(context).hideCurrentSnackBar();
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //           backgroundColor: isNotConnected ? Colors.red : Colors.green,
  //           duration: Duration(seconds: isNotConnected ? 6000 : 3),
  //           content: Text(
  //               isNotConnected
  //                   ? getTranslated('no_connection', context)!
  //                   : getTranslated('connected', context)!,
  //               textAlign: TextAlign.center)));
  //       if (!isNotConnected) {
  //         _route();
  //       }
  //     }
  //     firstTime = false;
  //   } as void Function(List<ConnectivityResult> event)?);
  //
  //   _route();
  // }
  // void _route() {
  //   Provider.of<SplashController>(context, listen: false)
  //       .initConfig(context)
  //       .then((bool isSuccess) {
  //
  //     if (isSuccess) {
  //        String? minimumVersion = "0";
  //       UserAppVersionControl? appVersion =
  //           Provider.of<SplashController>(Get.context!, listen: false)
  //               .configModel
  //               ?.userAppVersionControl;
  //       if (Platform.isAndroid) {
  //         minimumVersion = appVersion?.forAndroid?.version ?? '0';
  //       } else if (Platform.isIOS) {
  //         minimumVersion = appVersion?.forIos?.version ?? '0';
  //       }
  //
  //
  //       Provider.of<SplashController>(Get.context!, listen: false)
  //           .initSharedPrefData();
  //       Timer(const Duration(seconds: 1), () {
  //         if (compareVersions(minimumVersion!, AppConstants.appVersion) == 1) {
  //           Navigator.of(Get.context!).pushReplacement(
  //               MaterialPageRoute(builder: (_) => const UpdateScreen()));
  //         } else if (Provider.of<SplashController>(Get.context!, listen: false)
  //             .configModel!
  //             .maintenanceMode!) {
  //           Navigator.of(Get.context!).pushReplacement(
  //               MaterialPageRoute(builder: (_) => const MaintenanceScreen()));
  //         } else if (Provider.of<AuthController>(Get.context!, listen: false)
  //             .isLoggedIn()) {
  //           Provider.of<AuthController>(Get.context!, listen: false)
  //               .updateToken(Get.context!);
  //           if (widget.body != null) {
  //             if (widget.body!.type == 'order') {
  //               Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(
  //                   builder: (BuildContext context) =>
  //                       OrderDetailsScreen(orderId: widget.body!.orderId)));
  //             } else if (widget.body!.type == 'notification') {
  //               Navigator.of(context).pushReplacement(MaterialPageRoute(
  //                   builder: (BuildContext context) =>
  //                   const NotificationScreen()));
  //             } else {
  //               Navigator.of(context).pushReplacement(MaterialPageRoute(
  //                   builder: (BuildContext context) => const InboxScreen(
  //                     isBackButtonExist: true,
  //                   )));
  //             }
  //           } else {
  //             Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(
  //                 builder: (BuildContext context) => const IntroButtonScreen()));
  //           }
  //         } else if (Provider.of<SplashController>(Get.context!, listen: false)
  //             .showIntro()!) {
  //           Navigator.of(Get.context!).pushReplacement(MaterialPageRoute(
  //               builder: (BuildContext context) => OnBoardingScreen(
  //                   indicatorColor: ColorResources.grey,
  //                   selectedIndicatorColor: Theme.of(context).primaryColor)));
  //         } else {
  //           if (Provider.of<AuthController>(context, listen: false)
  //               .getGuestToken() !=
  //               null &&
  //               Provider.of<AuthController>(context, listen: false)
  //                   .getGuestToken() !=
  //                   '1') {
  //             Navigator.of(context).pushReplacement(MaterialPageRoute(
  //                 builder: (BuildContext context) => const IntroButtonScreen()));
  //           } else {
  //             Provider.of<AuthController>(context, listen: false)
  //                 .getGuestIdUrl();
  //             Navigator.pushAndRemoveUntil(
  //                 context,
  //                 MaterialPageRoute(builder: (_) => const IntroButtonScreen()),
  //                     (route) => false);
  //           }
  //         }
  //       });
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(),
            SizedBox(),
            CustomButton(
              buttonText: "Item 1",
              onTap: () {},
            ),CustomButton(
              buttonText: "Item 2",
              onTap: () {},
            ),CustomButton(
              buttonText: "Item 3",
              onTap: () {},
            ),
            SizedBox(),
            SizedBox(),
          ],
        ),
      ),
    );
  }
}
