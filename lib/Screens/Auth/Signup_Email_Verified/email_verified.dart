import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/Screens/Auth/Auth_controller.dart';
import 'package:todo_app/Screens/HomeScreen/home_screen.dart';
import 'package:todo_app/utils/Common/app_string.dart';

class EmailVerified extends StatefulWidget {
   EmailVerified({super.key});

  @override
  State<EmailVerified> createState() => _EmailVerifiedState();
}

class _EmailVerifiedState extends State<EmailVerified> {
  final AuthController authController = Get.put(AuthController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('An Email has been sent to ${authController.user!.email} Please Verfiy'),
            SizedBox(
              height: 35,
              width: 350,
              child: ElevatedButton(
                  onPressed: () {
                    authController.user!.emailVerified ? Get.offAll(HomeScreen()) : authController.user!.sendEmailVerification();;
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                  ),
                  child: Text('Verifying Email',
                    style: const TextStyle(color: Colors.white),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
