import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:range_wave/core/navigation/app_pages.dart';
import 'package:range_wave/core/navigation/app_routes.dart';
import 'package:range_wave/core/utils/app_helper.dart';

import 'core/app_credentials.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  //  Stripe init
  Stripe.publishableKey = AppCredentials.stripePublishableKey;
  await Stripe.instance.applySettings();

  // Check login status and role
  final accessToken = await AppHelper.instance.getAccessToken();
  final role = await AppHelper.instance.getAuthRole();

  String initialRoute = AppRoutes.selectUser;

  if (accessToken != null && accessToken.isNotEmpty) {
    if (role == 'mechanic') {
      initialRoute = AppRoutes.mechanicBottomNav;
    } else if (role == 'customer') {
      initialRoute = AppRoutes.userBottomNav;
    }
  }

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Wrench wave',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
          initialRoute: initialRoute,
          getPages: AppPages.pages,
          scaffoldMessengerKey: scaffoldMessengerKey,
        );
      },
    );
  }
}