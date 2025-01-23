import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/cart/screens/cart_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/chat/controllers/chat_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/chat/screens/inbox_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/dashboard/models/navigation_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/dashboard/widgets/dashboard_menu_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/deal/controllers/flash_deal_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/home/screens/aster_theme_home_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/home/screens/fashion_theme_home_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/home/screens/home_screens.dart';
import 'package:flutter_sixvalley_ecommerce/features/more/screens/more_screen_view.dart';
import 'package:flutter_sixvalley_ecommerce/features/order/screens/order_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wishlist/controllers/wishlist_controller.dart';
import 'package:flutter_sixvalley_ecommerce/handyman/main.dart' as handymain;
import 'package:flutter_sixvalley_ecommerce/helper/network_info.dart';
import 'package:flutter_sixvalley_ecommerce/payment/payment_screen.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../../common/basewidget/show_custom_snakbar_widget.dart';
import '../../../data_store.dart';
import '../../../eclassify/Ui/screens/splash_screen.dart';
import '../../../eclassify/Utils/AppIcon.dart';
import '../../../eclassify/Utils/ui_utils.dart';
import '../../../eclassify/exports/main_export.dart';
import '../../../flutter_user_app/pages/language/languages.dart';
import '../../../main.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});
  @override
  DashBoardScreenState createState() => DashBoardScreenState();
}

class DashBoardScreenState extends State<DashBoardScreen> {
  int _pageIndex = 0;
  late List<NavigationModel> _screens;
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();
  final PageStorageBucket bucket = PageStorageBucket();

  bool singleVendor = false;

  @override
  void initState() {
    super.initState();

    if (Provider.of<AuthController>(context, listen: false).isLoggedIn()) {
      Provider.of<WishListController>(context, listen: false).getWishList();
      Provider.of<ChatController>(context, listen: false).getChatList(1, reload: false, userType: 0);
      Provider.of<ChatController>(context, listen: false).getChatList(1, reload: false, userType: 1);
    }

    final SplashController splashController = Provider.of<SplashController>(context, listen: false);
    singleVendor = splashController.configModel?.businessMode == "single";
    Provider.of<FlashDealController>(context, listen: false).getFlashDealList(true, true);

    if (splashController.configModel!.activeTheme == "default") {
      HomePage.loadData(false);
    } else if (splashController.configModel!.activeTheme == "theme_aster") {
      AsterThemeHomeScreen.loadData(false);
    } else {
      FashionThemeHomePage.loadData(false);
    }

    _screens = [
      NavigationModel(
        name: 'home',
        icon: Images.homeImage,
        screen: (splashController.configModel!.activeTheme == "default")
            ? const HomePage()
            : (splashController.configModel!.activeTheme == "theme_aster")
                ? const AsterThemeHomeScreen()
                : const FashionThemeHomePage(),
      ),
      NavigationModel(name: 'inbox', icon: Images.messageImage, screen: const InboxScreen(isBackButtonExist: false)),
      NavigationModel(name: 'cart', icon: Images.cartArrowDownImage, screen: const CartScreen(showBackButton: false), showCartIcon: true),
      NavigationModel(name: 'orders', icon: Images.shoppingImage, screen: const OrderScreen(isBacButtonExist: false)),
      NavigationModel(name: 'more', icon: Images.moreImage, screen: const MoreScreen()),
    ];

    // Padding(padding: const EdgeInsets.only(right: 12.0),
    //   child: IconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen())),
    //     icon: Stack(clipBehavior: Clip.none, children: [
    //
    //       Image.asset(Images.cartArrowDownImage, height: Dimensions.iconSizeDefault,
    //           width: Dimensions.iconSizeDefault, color: ColorResources.getPrimary(context)),
    //
    //       Positioned(top: -4, right: -4,
    //           child: Consumer<CartController>(builder: (context, cart, child) {
    //             return CircleAvatar(radius: ResponsiveHelper.isTab(context)? 10 :  7, backgroundColor: ColorResources.red,
    //                 child: Text(cart.cartList.length.toString(),
    //                     style: titilliumSemiBold.copyWith(color: ColorResources.white,
    //                         fontSize: Dimensions.fontSizeExtraSmall)));})),
    //     ]),
    //   ),
    // ),

    NetworkInfo.checkConnectivity(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: PageStorage(bucket: bucket, child: _screens[_pageIndex].screen),
        bottomNavigationBar: Container(
            height: 68,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.paddingSizeLarge)),
              color: Theme.of(context).cardColor,
              boxShadow: [BoxShadow(offset: const Offset(1, 1), blurRadius: 2, spreadRadius: 1, color: Theme.of(context).primaryColor.withOpacity(.125))],
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: _getBottomWidget(singleVendor))));
  }

  void _setPage(int pageIndex) {
    setState(() {
      if (pageIndex == 1 && _pageIndex != 1) {
        Provider.of<ChatController>(context, listen: false).setUserTypeIndex(context, 0);
        Provider.of<ChatController>(context, listen: false).resetIsSearchComplete();
      }
      _pageIndex = pageIndex;
    });
  }

  List<Widget> _getBottomWidget(bool isSingleVendor) {
    List<Widget> list = [];
    for (int index = 0; index < _screens.length; index++) {
      list.add(Expanded(child: CustomMenuWidget(isSelected: _pageIndex == index, name: _screens[index].name, icon: _screens[index].icon, showCartCount: _screens[index].showCartIcon ?? false, onTap: () => _setPage(index))));
    }
    return list;
  }
}

class BlankPage extends StatefulWidget {
  const BlankPage({super.key});

  @override
  State<BlankPage> createState() => _BlankPageState();
}

class _BlankPageState extends State<BlankPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseMessaging.onBackgroundMessage(NotificationService.onBackgroundMessageHandler);
    //ChatMessageHandler.handle();
    ChatGlobals.init();
    Future.delayed(
      Duration(seconds: 1),
      () async {
        // main23();
        // runApp(const EntryPoint());
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const SplashScreen(),
            ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (BuildContext context) {
      return Scaffold(
        body: Center(
          child: Container(
            height: 200,
            width: 200,
            child: UiUtils.getSvg(AppIcons.splashLogo),
          ),
        ),
      );
    });
  }
}

class ButtonScreen extends StatefulWidget {
  const ButtonScreen({super.key});

  @override
  State<ButtonScreen> createState() => _ButtonScreenState();
}

class _ButtonScreenState extends State<ButtonScreen> {
  final List<MenuItem> menuItems = [
    MenuItem(title: "Ecommerce"),
    MenuItem(title: "Eclassify"),
    MenuItem(title: "UserApp"),
    MenuItem(title: "HandyMan"),
    MenuItem(title: "Payment"),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("UserId${getData.read("UserId")}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Number of columns
            crossAxisSpacing: 10.0, // Space between columns
            mainAxisSpacing: 10.0, // Space between rows
          ),
          shrinkWrap: true,
          itemCount: menuItems.length,
          itemBuilder: (context, index) {
            final item = menuItems[index];
            return GestureDetector(
              onTap: () async {
                if (index == 0) {
                  Navigator.of(Get.context!).push(MaterialPageRoute(builder: (BuildContext context) => const DashBoardScreen()));
                } else if (index == 1) {
                  bool isSuccessful = await checkAutoLoginSalesService();
                  if (isSuccessful) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlankPage(),
                        ));
                  } else {
                    showCustomSnackBar("Auto Login Failed...", context);
                  }
                } else if (index == 2) {
                  bool isSuccessful = await checkAutoLoginUserService();
                  if (isSuccessful) {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Languages()));
                  } else {
                    showCustomSnackBar("Auto Login Failed...", context);
                  }
                } else if (index == 3) {
                  bool isSuccessful = await checkAutoLoginHomeService();
                  if (isSuccessful) {
                    await handymain.mainHandyMan();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => handymain.MyApp(),
                        ));
                  } else {
                    showCustomSnackBar("Auto Login Failed...", context);
                  }
                } else {
                  print("BearerToken${Provider.of<AuthController>(Get.context!, listen: false).getUserToken()}");
                  Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentScreen()));
                }
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //Icon(item.icon, size: 40, color: Colors.blue),
                    SizedBox(height: 10),
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<bool> checkAutoLoginHomeService() async {
    try {
      Map map = {
        "user_id": getData.read("UserId").toString(),
      };
      Uri uri = Uri.parse("https://mewarpe.com/homeservice/api/auto_login");
      var response = await http.post(
        uri,
        body: map,
      );
      var result = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (result.containsKey('data')) {
          //await saveUserData(result['data']);
          //print("Result${result['data']['api_token']}");

          // await handymain.appStore.setToken(result['data']['api_token']);
          //appStore.setLoggedIn(true);

          /*await appStore.setUserId(data.id.validate());
          await appStore.setUId(data.uid.validate());
          await appStore.setFirstName(data.firstName.validate());
          await appStore.setLastName(data.lastName.validate());
          await appStore.setUserEmail(data.email.validate());
          await appStore.setUserName(data.username.validate());
          await appStore.setCountryId(data.countryId.validate());
          await appStore.setStateId(data.stateId.validate());
          await appStore.setCityId(data.cityId.validate());
          await appStore.setContactNumber(data.contactNumber.validate());
          await appStore.setLoginType(data.loginType.validate(value: LOGIN_TYPE_USER));
          await appStore.setAddress(data.address.validate());

          await appStore.setUserProfile(data.profileImage.validate());

          /// Subscribe Firebase Topic
          subscribeToFirebaseTopic();

          // Sync new configurations for secret keys
          if (forceSyncAppConfigurations) await setValue(LAST_APP_CONFIGURATION_SYNCED_TIME, 0);
          getAppConfigurations();

          */

          //await handymain.appStore.setLoginType(LOGIN_TYPE_USER);
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      // Handle any errors and return false
      print('Error: $e');
      return false;
    }
  }

  Future<bool> checkAutoLoginSalesService() async {
    try {
      Map map = {
        "user_id": getData.read("UserId").toString(),
      };
      Uri uri = Uri.parse("https://mewarpe.com/sale/admin/api/auto_login");
      var response = await http.post(
        uri,
        body: map,
      );
      var result = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (result.containsKey('data')) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      // Handle any errors and return false
      print('Error: $e');
      return false;
    }
  }

  Future<bool> checkAutoLoginUserService() async {
    try {
      Map map = {
        "user_id": getData.read("UserId").toString(),
      };
      Uri uri = Uri.parse("https://mewarpe.com/rental/public/api/v1/auto_login");
      var response = await http.post(
        uri,
        body: map,
      );
      var result = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (result.containsKey('access_token')) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      // Handle any errors and return false
      print('Error: $e');
      return false;
    }
  }
}

class MenuItem {
  final String title;

  MenuItem({required this.title});
}
