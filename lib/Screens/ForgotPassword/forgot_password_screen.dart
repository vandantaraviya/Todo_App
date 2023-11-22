import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:todo_app/Screens/Auth/Auth_controller.dart';
import 'package:todo_app/utils/Common/app_string.dart';
import 'package:todo_app/utils/Common_Widgets/custom_textfiled.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key,});
  AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppString.forgotPasswordTitle),
          centerTitle: true,
        ),
        body: Obx(() {
          return Column(
            children: [
              // CustomTextField(
              //   password: authController.newPasswordVisible.value,
              //   border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(5)),
              //   textEditingController: authController.oldPassword,
              //   hintText: AppString.pleaseChangePassword,
              //   labelText: AppString.oldPassword,
              //   keyboardType: TextInputType.visiblePassword,
              //   textInputAction: TextInputAction.done,
              //   readOnly: true,
              //   suffixIcon: IconButton(
              //     icon: Icon(authController.newPasswordVisible.value
              //         ? Icons.visibility_off
              //         : Icons.visibility),
              //     onPressed: () {
              //       authController.newPasswordVisible.value =
              //       !authController.newPasswordVisible.value;
              //     },
              //   ),
              // ),
              CustomTextField(
                password: authController.confirmpasswordVisible.value,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5)),
                textEditingController: authController.newPassword,
                hintText: AppString.pleaseNewPassword,
                labelText: AppString.newPassword,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                readOnly: false,
                suffixIcon: IconButton(
                  icon: Icon(authController.confirmpasswordVisible.value
                      ? Icons.visibility_off
                      : Icons.visibility),
                  onPressed: () {
                    authController.confirmpasswordVisible.value =
                    !authController.confirmpasswordVisible.value;
                  },
                ),
              ),
              SizedBox(height: 1.h,),
              SizedBox(
                height: 35,
                width: 350,
                child: ElevatedButton(
                    onPressed: () {
                      authController.newPasswordUpdate();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                    ),
                    child: (authController.newPasswordLoading.value)
                        ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                        : Text(
                      AppString.oldPassword,
                      style: const TextStyle(color: Colors.white),
                    )),
              ),
            ],
          );
        }),
      ),
    );
  }
}