import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../../Services/Pref_Res.dart';
import '../../../utils/Common/app_string.dart';
import '../../../utils/Common_Widgets/custom_textfiled.dart';
import '../../HomeScreen/home_controller.dart';
import '../Auth_controller.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key, this.isEdit});

  final bool? isEdit;

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final AuthController authController = Get.put(AuthController());
  final HomeController homeController = Get.put(HomeController());

  @override
  void dispose() {
    super.dispose();
    authController.userNameController.clear();
    authController.phoneNumberController.clear();
    authController.emailSignInController.clear();
    authController.passwordSignInController.clear();
    authController.bodSignInController.clear();
    authController.addressSignInController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          leading:widget.isEdit! ?
          IconButton(
            onPressed: (){
              if(authController.editLoading.value==true){
              }else{
                Get.back();
              }
            },
            icon: Icon(Icons.arrow_back_outlined,size: 15.sp,),
          ): IconButton(
              onPressed: (){
                if(authController.isLoading.value==true){
                }else{
                  Get.back();
                }
              },
              icon: Icon(Icons.arrow_back_outlined,size: 15.sp,),
          ),
          title: Text(
              widget.isEdit! ? AppString.editProfile : AppString.signUpScreen),
          centerTitle: true,
        ),
        body: Obx(() {
          return SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 1.h,
                  ),
                  profileImage(),
                  CustomTextField(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5)),
                    textEditingController: authController.userNameController,
                    hintText: AppString.signInPleaseUserName,
                    labelText: AppString.signInUserName,
                    textInputAction: TextInputAction.next,
                    readOnly: false,
                    password: false,
                  ),
                  CustomTextField(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5)),
                    textEditingController:
                        authController.addressSignInController,
                    hintText: AppString.signInPleaseAddress,
                    labelText: AppString.signInAddress,
                    textInputAction: TextInputAction.next,
                    readOnly: false,
                    password: false,
                  ),
                  CustomTextField(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5)),
                    textEditingController: authController.bodSignInController,
                    hintText: AppString.signInPleaseBirthOfDate,
                    labelText: AppString.signInBirthOfDate,
                    textInputAction: TextInputAction.next,
                    suffixIcon: IconButton(
                      onPressed: () {
                        widget.isEdit!
                            ? authController.datePickerWidget(context)
                            : authController.datePickerWidget(context);
                      },
                      icon: const Icon(Icons.calendar_month_outlined),
                    ),
                    readOnly: true,
                    onTap: () {
                      widget.isEdit!
                          ? authController.datePickerWidget(context)
                          : authController.datePickerWidget(context);
                    },
                    password: false,
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  CustomTextField(
                    maxLength: 10,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5)),
                    textEditingController: authController.phoneNumberController,
                    hintText: AppString.signInPleasePhoneNumber,
                    labelText: AppString.signInPhoneNumber,
                    textInputAction: TextInputAction.next,
                    readOnly: false,
                    password: false,
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  CustomTextField(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5)),
                    textEditingController: authController.emailSignInController,
                    hintText: AppString.pleaseEmali,
                    labelText: AppString.email,
                    textInputAction: TextInputAction.next,
                    readOnly: widget.isEdit! ? true : false,
                    password: false,
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  CustomTextField(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5)),
                    textEditingController:
                        authController.passwordSignInController,
                    hintText: AppString.pleasePassword,
                    labelText: AppString.password,
                    textInputAction: TextInputAction.done,
                    readOnly: widget.isEdit! ? true : false,
                    password: authController.passwordVisibleSignIN.value,
                    suffixIcon: IconButton(
                      icon: Icon(authController.passwordVisibleSignIN.value
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () {
                        authController.passwordVisibleSignIN.value =
                            !authController.passwordVisibleSignIN.value;
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
                          widget.isEdit!
                              ? authController.editUserData()
                              : authController.signUpUser();
                          PrefService.setValue(PrefRes.loginUser, true);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                        ),
                        child: widget.isEdit!
                            ? (authController.editLoading.value)
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : Text(
                                    AppString.update,
                                    style: const TextStyle(color: Colors.white),
                                  )
                            : (authController.isLoading.value)
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : Text(
                                    AppString.signUp,
                                    style: const TextStyle(color: Colors.white),
                                  )),
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget profileImage() {
    return GetBuilder<AuthController>(
      id: 'image',
      builder: (controller) => Stack(
        children: [
          controller.file != null
              ? GestureDetector(
                  onTap: () {
                    controller.onTapSelectImage();
                  },
                  child: Container(
                    height: 10.h,
                    width: 22.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                          color: AppColors.primaryColor, width: 0.8.w),
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: FileImage(
                          controller.file!,
                        ),
                      ),
                    ),
                  ),
                )
              : widget.isEdit!
                  ? CachedNetworkImage(
                      imageUrl: "${homeController.loginUser!.imageUrl}",
                      imageBuilder: (context, imageProvider,) => Container(
                        height: 10.h,
                        width: 22.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                              color: AppColors.primaryColor, width: 0.8.w),
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: imageProvider,
                          ),
                        ),
                      ),
                      fit: BoxFit.cover,
                      placeholder: (context,url,) => const CircularProgressIndicator(),
                    )
                  : Container(
                      height: 10.h,
                      width: 22.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: AppColors.primaryColor,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.camera_alt_outlined,
                          color: AppColors.whiteColor,
                        ),
                      ),
                    ),
              Padding(
            padding: EdgeInsets.only(top: 7.2.h, left: 6.5.h),
            child: InkWell(
              onTap: () {
                controller.onTapSelectImage();
              },
              child: Container(
                  height: 3.h,
                  width: 7.w,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: AppColors.whiteColor,
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.primaryColor,
                          blurStyle: BlurStyle.solid,
                          blurRadius: 1.0,
                        ),
                      ]),
                  child: Center(
                    child: Icon(Icons.add,
                        color: AppColors.primaryColor, size: 12.sp),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
