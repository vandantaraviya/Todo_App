import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/Screens/Auth/LogInScreen/login_screen.dart';
import '../../Services/Pref_Res.dart';
import '../../Services/ads_manger.dart';
import '../../utils/Common/app_string.dart';
import '../HomeScreen/home_controller.dart';
import '../HomeScreen/home_screen.dart';

class AuthController extends GetxController {
  final HomeController homeController = Get.put(HomeController());
  TextEditingController emailController = TextEditingController();
  TextEditingController resetEmailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailSignInController = TextEditingController();
  TextEditingController passwordSignInController = TextEditingController();
  TextEditingController addressSignInController = TextEditingController();
  TextEditingController bodSignInController = TextEditingController();
  TextEditingController oldPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  User? user =  FirebaseAuth.instance.currentUser;
  String userId = '';
  RxBool isLoading = false.obs;
  RxBool editLoading= false.obs;
  RxBool imageLoading= false.obs;
  RxBool loading = false.obs;
  RxBool resetloading = false.obs;
  RxBool newPasswordLoading = false.obs;
  RxBool passwordVisible = true.obs;
  RxBool newPasswordVisible = true.obs;
  RxBool confirmpasswordVisible = true.obs;
  RxBool passwordVisibleSignIN = true.obs;
  final formKey = GlobalKey<FormState>();
  File? file;
  UploadTask? uploadTask;
  PlatformFile? pickedFile;
  String imageUrl= '';
  String userIdEdit = PrefService.getString(PrefRes.userId);
  Timer? timer;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await AdManager.loadUnityIntAd();
      await AdManager.loadUnityRewardedAd();
    });
  }

  
  emailVerfiy() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user!.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  resetPassword() async {
    try{
      resetloading.value = true;
      await FirebaseAuth.instance.sendPasswordResetEmail(email: resetEmailController.text.trim(),);
      Get.back();
      Get.snackbar('Email', 'Password Reset Email Sent');
      resetEmailController.clear();
    }on FirebaseException catch(e){
      print(e.toString());
      errorSnackbar(title: 'Error', message: e.toString());
    }finally{
      resetloading.value = false;
    }
  }

  newPasswordUpdate() async {
    if (!forgotPasswordValidation()) {
      return;
    }
    try{
      newPasswordLoading.value = true;
      print('${user!.email}');
      user!.updatePassword(newPassword.text).then((_) async {
        newPassword.clear();
        print(newPassword.text.toString());
        print("Successfully changed password");
        Get.back();
      }).catchError((error){
        print("Password can't be changed" + error.toString());
      });
    }catch(e){
      print(e);
      rethrow;
    }finally{
      newPasswordLoading.value = false;
    }
  }


  editUserData() async {
    if (!editValidation()) {
      return;
    }
    try{
      editLoading.value = true;
      Reference reference = storage.ref().child(userIdEdit);
      if(file!=null) {
        uploadTask = reference.putFile(
          file!, SettableMetadata(contentType: "image/jpg",));
        await Future.value(uploadTask);
        imageUrl = await reference.getDownloadURL();
      }else{
        imageUrl = '${homeController.loginUser!.imageUrl}';
      }
      await firestore.collection(AppString.userCollection).doc(userIdEdit).update({
        'username': userNameController.text,
        'phone': phoneNumberController.text,
        'email': emailSignInController.text,
        'address': addressSignInController.text,
        'birth of date': bodSignInController.text,
        'imageUrl': imageUrl.toString(),
      }).then((value) {
        Get.back();
        homeController.userdata();
        userNameController.clear();
        phoneNumberController.clear();
        emailSignInController.clear();
        passwordSignInController.clear();
        addressSignInController.clear();
        bodSignInController.clear();
      });
    }catch(e){
      print(e);
      rethrow;
    }finally{
      editLoading.value = false;
    }
  }

  datePickerWidget(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(3000),
    );
    if(pickedDate != null ){
      print(pickedDate);
      String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
      print(formattedDate);
      bodSignInController.text = formattedDate;
    }else{
      print("Date is not selected");
    }
  }


  signUpUser(BuildContext context) async {
    if (!signInValidation()) {
      return;
    }
    try {
      isLoading.value = true;
      if(file!=null) {
        UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: emailSignInController.text,
          password: passwordSignInController.text,);
        await userCredential.user!.sendEmailVerification();
        print(userCredential.user!.email);
        userId = userCredential.user!.uid;
        PrefService.setValue(PrefRes.userId, userId);
        print('========================$userId===================');
        Reference reference = storage.ref().child(userId);
        uploadTask = reference.putFile(file!, SettableMetadata(contentType: "image/jpg",));
        await Future.value(uploadTask);
        var imageUrl = await reference.getDownloadURL();
        print('ImageURL:--${imageUrl.toString()}');
        if(imageUrl!=null){
          await firestore.collection(AppString.userCollection).doc(userCredential.user!.uid).set({
            'username': userNameController.text,
            'phone': phoneNumberController.text,
            'email': emailSignInController.text,
            'address': addressSignInController.text,
            'birth of date': bodSignInController.text,
            'imageUrl': imageUrl.toString(),
          });
          userNameController.clear();
          phoneNumberController.clear();
          emailSignInController.clear();
          passwordSignInController.clear();
          bodSignInController.clear();
          addressSignInController.clear();
        }
        await AdManager.showRewardedAd();
        Get.snackbar("Successfully","Successfully Registration ",
        backgroundColor: AppColors.primaryColor,colorText: AppColors.whiteColor,
        );
        alertDialog(context,email: userCredential.user!.email,);
        // Get.offAll( EmailVerified());
      }else{
        errorSnackbar(title: "Error", message: "Selected Your Profile Image");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        errorSnackbar(title: "Error", message: "The account already exists for that email.");
      } else {
        errorSnackbar(title: "Error", message: e.code.toString());
      }
    } catch (e) {
      print(e);
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  alertDialog(BuildContext context,{String? email,}) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Email Verification'),
            content: Text('Check your Email We have sent you a Email on ${email}'),
            actions: <Widget>[
            SizedBox(
            height: 35,
            width: 350,
            child: ElevatedButton(
                onPressed: () async {
                  Get.offAll(LogInScreen());
                  },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                ),
                child: Text('OK',style: const TextStyle(color: Colors.white),
                )),
              ),
            ],
          );
        });
    }

  logIn({String? email, String? password}) async {
    if (!logInValidation()) {
      return;
    }
    try {
      loading.value = true;
      UserCredential user = await auth.signInWithEmailAndPassword(
          email: email.toString(), password: password.toString());
      if(user.user!.emailVerified) {
        print("==============$email=========$password===========");
        print(user.user!.uid);
        userId = user.user!.uid;
        PrefService.setValue(PrefRes.userId, userId);
        print('========================$userId===================');
        Get.snackbar(
          "Successfully",
          "Successfully Log In",
          backgroundColor: AppColors.primaryColor,
          colorText: AppColors.whiteColor,
        );
        await AdManager.showRewardedAd();
        Get.offAll(HomeScreen());
      }else{
        errorSnackbar(title: 'error', message: 'Email Not Verifying.....',);
      }
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == 'network-request-failed') {
        return errorSnackbar(title: 'error', message: 'No Internet Connection.',);
      } else if (e.code == "wrong-password") {
        return errorSnackbar(title: 'error',message: 'Please Enter correct password.');
      } else if (e.code == 'user-not-found') {
        errorSnackbar(title: 'error', message:'Email not found');
      } else if (e.code == 'too-many-requests') {
        return errorSnackbar(title: 'error',message: 'Too many attempts please try later.');
      } else if (e.code == 'unknwon') {
        return errorSnackbar(title: 'error',message: 'Email and password field are required.');
      } else if (e.code == 'unknown') {
        return errorSnackbar(title: 'error',message: 'Email and Password Fields are required.');
      } else if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
        return errorSnackbar(title: 'error',message: 'No user found for that email.');
      } else {
        return errorSnackbar(title: 'error',message: e.code.toString());
      }
      rethrow;
    } finally {
      loading.value = false;
    }
  }

  editValidation() {
    Get.closeAllSnackbars();
    if(userNameController.text.isEmpty) {
      errorSnackbar(title: 'error',message: "Please enter UserName");
      return false;
    } else if (addressSignInController.text.isEmpty) {
      errorSnackbar(title: 'error',message: "Please enter Address");
      return false;
    }else if (bodSignInController.text.isEmpty) {
      errorSnackbar(title: 'error',message: "Please enter Birth Of Date");
      return false;
    } else if (phoneNumberController.text.isEmpty) {
      errorSnackbar(title: 'error',message: "Please enter Phone Number");
      return false;
    } else if(phoneNumberController.text.length<10){
      errorSnackbar(title: 'error',message: "Please enter Phone Number 10 Digit");
      return false;
    }
    return true;
  }

  logInValidation() {
    Get.closeAllSnackbars();
    if (emailController.text.isEmpty && passwordController.text.isEmpty) {
      errorSnackbar(title: "Data is empty", message: "please fill All data");
      return false;
    }else if (emailController.text.isEmpty) {
      errorSnackbar(title: 'error',message: "Please enter email");
      return false;
    } else if (!GetUtils.isEmail(emailController.text)) {
      errorSnackbar(title: 'error',message:  "please enter valid email");
      return false;
    } else if (passwordController.text.isEmpty) {
      errorSnackbar(title: 'error',message: "Please enter password");
      return false;
    }else if(passwordController.text.length<8){
      errorSnackbar(title: 'error',message: "Password Must be more than 8 characters");
      return false;
    }
    return true;
  }

  signInValidation() {
    Get.closeAllSnackbars();
     if(userNameController.text.isEmpty) {
      errorSnackbar(title: 'error',message: "Please enter UserName");
      return false;
    } else if (addressSignInController.text.isEmpty) {
       errorSnackbar(title: 'error',message: "Please enter Address");
       return false;
     }else if (bodSignInController.text.isEmpty) {
       errorSnackbar(title: 'error',message: "Please enter Birth Of Date");
       return false;
     } else if (phoneNumberController.text.isEmpty) {
      errorSnackbar(title: 'error',message: "Please enter Phone Number");
      return false;
    } else if(phoneNumberController.text.length<10){
      errorSnackbar(title: 'error',message: "Please enter Phone Number 10 Digit");
      return false;
    }else if (emailSignInController.text.isEmpty) {
      errorSnackbar(title: 'error',message: "Please enter email");
      return false;
    } else if (!GetUtils.isEmail(emailSignInController.text)) {
      errorSnackbar(title: 'error',message: "please enter valid email");
      return false;
    } else if (passwordSignInController.text.isEmpty) {
      errorSnackbar(title: 'error',message: "Please enter password");
      return false;
    }else if(passwordSignInController.text.length<8){
      errorSnackbar(title: 'error',message: "Password Must be m ore than 8 characters");
      return false;
    }
     // else if(auth.){
     //   errorSnackbar(title: 'error',message: "Email Not Verified");
     //   return false;
     // }
    return true;
  }

  forgotPasswordValidation(){
    Get.closeAllSnackbars();
    if (newPassword.text.isEmpty) {
      errorSnackbar(title: 'error',message: "Please enter password");
      return false;
    }else if(newPassword.text.length<8){
      errorSnackbar(title: 'error',message: "Password Must be more than 8 characters");
      return false;
    }
    return true;
  }

  errorSnackbar({required String title,required String message}){
    return Get.snackbar(title, message,  backgroundColor: AppColors.redColor, colorText: AppColors.whiteColor,);
  }

  Future<void> onTapSelectImage() async {
    var pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if(pickedImage!=null){
      file = File(pickedImage.path);
    }else{
      errorSnackbar(title: 'error',message: "No Image Picked");
    }
    update(['image']);
  }

 googleSignup(BuildContext context) async {
    try{
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential authCredential = GoogleAuthProvider.credential(
            idToken: googleSignInAuthentication.idToken,
            accessToken: googleSignInAuthentication.accessToken);

        UserCredential result = await auth.signInWithCredential(authCredential);
        User? user = result.user;
        print(user!.email);
        if (result != null) {
          Get.offAll(HomeScreen());
        }
        print(googleSignInAccount.email);
      }
    }on FirebaseException catch(e){
      print(e.code);
      errorSnackbar(title: 'error',message: e.code);
    }catch(e){
      print(e.toString());
      rethrow;
    }
  }


  @override
  void dispose() {
    super.dispose();
    userNameController.clear();
    phoneNumberController.clear();
    emailSignInController.clear();
    passwordSignInController.clear();
  }

}
