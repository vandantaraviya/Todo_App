import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/Screens/Auth/Auth_controller.dart';

class EmailVerified extends StatelessWidget {
   EmailVerified({super.key});
  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
