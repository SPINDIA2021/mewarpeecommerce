import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/flutter_user_app/pages/NavigatorPages/about.dart';
import 'package:flutter_sixvalley_ecommerce/flutter_user_app/pages/language/languages.dart';
import 'package:flutter_sixvalley_ecommerce/flutter_user_app/pages/login/login.dart';
import 'package:flutter_sixvalley_ecommerce/flutter_user_app/pages/noInternet/noInternet.dart';
import 'package:flutter_sixvalley_ecommerce/flutter_user_app/pages/onTripPage/booking_confirmation.dart';
import 'package:flutter_sixvalley_ecommerce/flutter_user_app/pages/onTripPage/invoice.dart';
import 'package:flutter_sixvalley_ecommerce/flutter_user_app/pages/onTripPage/map_page.dart';
import 'functions/functions.dart';
import 'functions/notifications.dart';
import 'pages/loadingPage/loadingpage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';

// void maindeo() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   SystemChrome.setPreferredOrientations(
//       [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
//   await Firebase.initializeApp();
//   checkInternetConnection();
//   initMessaging();
//   runApp(const MyApp());
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    platform = Theme.of(context).platform;
    return GestureDetector(
        onTap: () {
          //remove keyboard on touching anywhere on the screen.
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          }
        },
        child: ValueListenableBuilder(
            valueListenable: valueNotifierBook.value,
            builder: (context, value, child) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Product Name',
                theme: ThemeData(),
                home:  Languages(),
                builder: (context, child) {
                  return MediaQuery(
                    data: MediaQuery.of(context)
                        .copyWith(textScaler: const TextScaler.linear(1.0)),
                    child: child!,
                  );
                },
              );
            }));
  }
}
