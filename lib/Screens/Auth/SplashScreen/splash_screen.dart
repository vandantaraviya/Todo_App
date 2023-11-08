import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import '../../../Services/Pref_Res.dart';
import '../../../generated/assets.dart';
import '../../../utils/Common/app_string.dart';
import '../../HomeScreen/home_screen.dart';
import '../LogInScreen/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override

  void initState() {
    // TODO: implement initState
    super.initState();
    bool isLogin = PrefService.getBool(PrefRes.loginUser);
    Timer(
      const Duration(seconds: 3),
          () {
            Get.off(() =>isLogin ? const HomeScreen() :LogInScreen());
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:  [
            SizedBox(
              height: 35.h,
              child: Lottie.asset(Assets.lottieSplashScreen),
            ),
          ],
        ),
      ),
    );
  }
}
