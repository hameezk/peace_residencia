import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:peace_residencia/screens/dashboard.dart';

class BasicSplashScreen extends StatefulWidget {
  const BasicSplashScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<BasicSplashScreen> createState() => _BasicSplashScreenState();
}

class _BasicSplashScreenState extends State<BasicSplashScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Stack(
          children: [
            SizedBox(
              width: size.width,
              height: size.height,
              child: Image.asset(
                'assets/images/bg.png',
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              width: size.width,
              height: size.height,
              child: Center(
                  child: AnimatedSplashScreen(
                duration: 1200,
                backgroundColor: Colors.transparent,
                splashTransition: SplashTransition.rotationTransition,
                animationDuration:
                    const Duration(seconds: 1, milliseconds: 100),
                pageTransitionType: PageTransitionType.fade,
                splash: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset("assets/images/logo.png"),
                  ],
                ),
                nextScreen: const Dashboard(),
                splashIconSize: 350,
              )),
            ),
          ],
        ),
      ),
    );
  }
}
