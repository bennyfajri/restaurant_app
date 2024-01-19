import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/api/ApiService.dart';
import 'package:restaurant_app/provider/restaurant_provider.dart';
import 'package:restaurant_app/ui/home_page.dart';
import 'package:restaurant_app/ui/restaurant_detail_page.dart';
import 'package:restaurant_app/ui/splash_screen.dart';

import 'common/styles.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RestaurantProvider(apiService: ApiService()),
      child: MaterialApp(
        title: 'Restaurant App',
        theme: ThemeData(
          colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: primaryColor,
              onPrimary: Colors.black,
              secondary: secondaryColor),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: secondaryColor,
              foregroundColor: Colors.white,
              textStyle: const TextStyle(),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(0))),
            ),
          ),
        ),
        initialRoute: SplashScreen.routeName,
        routes: {
          SplashScreen.routeName: (context) => const SplashScreen(),
          HomePage.routeName: (context) => const HomePage(),
          RestaurantDetailPage.routeName: (context) => RestaurantDetailPage(
                restaurantId:
                    ModalRoute.of(context)?.settings.arguments as String,
              ),
        },
      ),
    );
  }
}
