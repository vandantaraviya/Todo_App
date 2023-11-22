import 'package:flutter/material.dart';
import 'package:todo_app/utils/Common/app_string.dart';
import 'package:todo_app/utils/Common_Widgets/custom_textfiled.dart';

class forgotPasswordScreen extends StatelessWidget {
  const forgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppString.forgotpasswordtitle),
        centerTitle: true,
      ),
      body: Column(
        children: [],
      ),
    );
  }
}