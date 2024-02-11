import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:todo_app/Screens/Auth/Auth_controller.dart';
import 'package:todo_app/utils/Common/app_string.dart';
import 'package:todo_app/utils/Common_Widgets/custom_textfiled.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({
    super.key,
    this.isEdit,
  });

  final bool? isEdit;
  final AuthController authController = Get.put(AuthController());

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
                 isEdit! ?
                 Text(
                    AppString.receivePassword,
                    style: TextStyle(
                        color: Colors.indigo,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold),
                  ):SizedBox(),
              // CustomTextField(
              //   password: authController.newPasswordVisible.value,
              //   border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(5)),
              //   textEditingController: authController.oldPassword,
              //   hintText: AppString.pleaseChangePassword,
              //   labelText: AppString.oldPassword,
              //   keyboardType: TextInputType.visiblePassword,
              //   textInputAction: TextInputAction.done,
              //   readOnly: false,
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
              isEdit!
                  ? CustomTextField(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5)),
                      textEditingController:
                          authController.resetEmailController,
                      hintText: AppString.pleaseEmali,
                      labelText: AppString.email,
                      textInputAction: TextInputAction.next,
                      readOnly: false,
                      password: false,
                    )
                  : CustomTextField(
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
              SizedBox(
                height: 1.h,
              ),
              isEdit!
                  ? SizedBox(
                      height: 35,
                      width: 350,
                      child: ElevatedButton(
                          onPressed: () {
                            authController.resetPassword();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                          ),
                          child: (authController.resetloading.value)
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  AppString.resetPassword,
                                  style: const TextStyle(color: Colors.white),
                                )),
                    )
                  : SizedBox(
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
