import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';

import '../payment/mobile_recharge_screen/mobile_recharge_screen.dart';

part 'app_routes.dart';

Duration transitionDuration = const Duration(milliseconds: 300);

class AppPages {
  static final pages = [
    GetPage(
      name: Routes.mobilerecharge,
      page: () => MobileRechargeScreen(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: transitionDuration,
    ),
  ];
}
