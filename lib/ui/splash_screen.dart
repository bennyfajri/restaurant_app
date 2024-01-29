import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:restaurant_app/ui/home_page.dart';

class SplashScreen extends StatelessWidget {
  static const String routeName = "/splash_screen";

  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: "assets/coffee_shop_amico.png",
      splashIconSize: MediaQuery.sizeOf(context).width / 2,
      nextScreen: const HomePage(),
      splashTransition: SplashTransition.fadeTransition,
    );
  }
}
