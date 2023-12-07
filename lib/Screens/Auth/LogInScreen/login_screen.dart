import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:todo_app/Screens/ForgotPassword/forgot_password_screen.dart';
import 'package:todo_app/Screens/HomeScreen/home_screen.dart';
import 'package:todo_app/Services/google_ads.dart';
import '../../../Services/Pref_Res.dart';
import '../../../Services/ads_manger.dart';
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
  final GoogleAdsManager googleAdsManager = Get.put(GoogleAdsManager());
  Map<String, dynamic>? userData;
  AccessToken? accessToken;
  bool checking = true;

  // checkIfisLoggedIn() async {
  //    accessToken = await FacebookAuth.instance.accessToken;
  //   setState(() {
  //     checking = false;
  //   });
  //   if (accessToken != null) {
  //     print(accessToken!.toJson());
  //      userData = await FacebookAuth.instance.getUserData();
  //     accessToken = accessToken;
  //     setState(() {
  //       userData = userData;
  //     });
  //   } else {
  //     _login();
  //   }
  // }

  _login() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        accessToken = result.accessToken;
        userData = await FacebookAuth.instance.getUserData();
        userData = userData;
      } else {
        print('result:------------------------------${result.status}');
        print('result:------------------------------${result.message}');
      }
      setState(() {
        checking = false;
      });
    } catch (e) {
      print("Error:------------------------${e.toString()}");
      rethrow;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    googleAdsManager.RewardedAds();
    googleAdsManager.InterstitialAds();
  }

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
          backgroundColor:  Colors.indigo,
          automaticallyImplyLeading: false,
          title: const Text("LogIn Screen",style: TextStyle(color: Colors.white),),
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
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
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
                        if (googleAdsManager.interstitialAd != null) {
                          googleAdsManager.interstitialAd!.show();
                          googleAdsManager.InterstitialAds();
                        }
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
                              password: authController.passwordController.text);
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
                        onPressed: () {
                          Get.to(ForgotPasswordScreen(
                            isEdit: true,
                          ));
                        },
                        child: Text(
                          AppString.forgotPassword,
                          style: TextStyle(
                              color: AppColors.primaryColor, fontSize: 11.sp),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppString.creatAccount,
                        style: TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.bold),
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
                  SizedBox(
                    height: 1.h,
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     InkWell(
                  //       onTap: ()async {
                  //         authController.googleSignup(context);
                  //       },
                  //       child: CircleAvatar(
                  //         radius: 25.0,
                  //         backgroundColor: AppColors.primaryColor,
                  //         backgroundImage: AssetImage(Assets.imageGoogle),
                  //       ),
                  //     ),
                  //     SizedBox(width: 5.w,),
                  //     InkWell(
                  //       onTap: (){
                  //         _login();
                  //       },
                  //       child: CircleAvatar(
                  //         radius: 25.0,
                  //         backgroundColor: AppColors.whiteColor,
                  //         backgroundImage: AssetImage(Assets.imageFacebook),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
