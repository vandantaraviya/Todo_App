import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:todo_app/Screens/ForgotPassword/forgot_password_screen.dart';
import '../../../Services/Pref_Res.dart';
import '../../../generated/assets.dart';
import '../../../utils/Common/app_string.dart';
import '../../../utils/Common_Widgets/custom_textfiled.dart';
import '../Auth_controller.dart';
import '../SignUp/signup_screen.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final AuthController authController = Get.put(AuthController());

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    authController.emailController.clear();
    authController.passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("LogIn Screen"),
          centerTitle: true,
        ),
        body: Obx(() {
          return SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 35.h,
                    child: Lottie.asset(Assets.lottieLogInScreen),
                  ),
                  CustomTextField(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5)),
                    textEditingController: authController.emailController,
                    hintText: AppString.pleaseEmali,
                    labelText: AppString.email,
                    textInputAction: TextInputAction.next,
                    readOnly: false,
                    password: false,
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  CustomTextField(
                    password: authController.passwordVisible.value,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5)),
                    textEditingController: authController.passwordController,
                    hintText: AppString.pleasePassword,
                    labelText: AppString.password,
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.done,
                    readOnly: false,
                    suffixIcon: IconButton(
                      icon: Icon(authController.passwordVisible.value
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () {
                        authController.passwordVisible.value =
                            !authController.passwordVisible.value;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  SizedBox(
                    height: 35,
                    width: 350,
                    child: ElevatedButton(
                        onPressed: () {
                          authController.logIn(
                            email: authController.emailController.text,
                            password: authController.passwordController.text,
                          );
                          PrefService.setValue(PrefRes.loginUser, true);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                        ),
                        child: (authController.loading.value)
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                AppString.login,
                                style: const TextStyle(color: Colors.white),
                              )),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: (){
                          Get.to(ForgotPasswordScreen(isEdit: true,));
                        },
                        child: Text(AppString.forgotPassword,
                        style: TextStyle(
                            color: AppColors.primaryColor, fontSize: 11.sp),
                      ),),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppString.creatAccount,
                        style: TextStyle(
                            color: AppColors.primaryColor, fontSize: 11.sp,fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.to(const SignUpScreen(
                            isEdit: false,
                          ));
                        },
                        child: Text(
                          AppString.signUp,
                          style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
