import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../Services/Pref_Res.dart';
import '../../utils/Common/app_string.dart';
import '../HomeScreen/home_controller.dart';
import '../HomeScreen/home_screen.dart';

class AuthController extends GetxController {
  final HomeController homeController = Get.put(HomeController());
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailSignInController = TextEditingController();
  TextEditingController passwordSignInController = TextEditingController();
  TextEditingController addressSignInController = TextEditingController();
  TextEditingController bodSignInController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  String userId = '';
  RxBool isLoading = false.obs;
  RxBool editLoading= false.obs;
  RxBool imageLoading= false.obs;
  RxBool loading = false.obs;
  RxBool passwordVisible = true.obs;
  RxBool passwordVisibleSignIN = true.obs;
  final formKey = GlobalKey<FormState>();
  File? file;
  UploadTask? uploadTask;
  PlatformFile? pickedFile;
  String imageUrl= '';
  String userIdEdit = PrefService.getString(PrefRes.userId);


  editUserData() async {
    if (!editValidation()) {
      return;
    }
    try{
      editLoading.value = true;
      Reference reference = storage.ref().child(userIdEdit);
      if(file!=null) {
        uploadTask = reference.putFile(
            file!, SettableMetadata(contentType: "image/jpeg",));
        await Future.value(uploadTask);
        imageUrl = await reference.getDownloadURL();
      }else{
        imageUrl = '${homeController.loginUser!.imageUrl}';
      }
      await firestore.collection(AppString.userCollection).doc(userIdEdit).update({
        'username': userNameController.text,
        'phone': phoneNumberController.text,
        'email': emailSignInController.text,
        'password': passwordSignInController.text,
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


  signUpUser() async {
    if (!signInValidation()) {
      return;
    }
    try {
      isLoading.value = true;
      if(file!=null) {
        UserCredential user = await auth.createUserWithEmailAndPassword(
            email: emailSignInController.text,
            password: passwordSignInController.text);
        print(user.user!.uid);
        userId = user.user!.uid;
        PrefService.setValue(PrefRes.userId, userId);
        print('========================$userId===================');
        Reference reference = storage.ref().child(userId);
        uploadTask = reference.putFile(file!, SettableMetadata(contentType: "image/jpeg",));
        await Future.value(uploadTask);
        var imageUrl = await reference.getDownloadURL();
        print('ImageURL:--${imageUrl.toString()}');
        if(imageUrl!=null){
          await firestore.collection(AppString.userCollection).doc(user.user!.uid).set({
            'username': userNameController.text,
            'phone': phoneNumberController.text,
            'email': emailSignInController.text,
            'password': passwordSignInController.text,
            'address': addressSignInController.text,
            'birth of date': bodSignInController.text,
            'imageUrl': imageUrl.toString(),
          });
        }
        Get.snackbar(
          "Successfully",
          "Successfully Sign Up",
          backgroundColor: AppColors.primaryColor,
          colorText: AppColors.whiteColor,
        );
        Get.offAll(const HomeScreen());
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
    } finally {
      isLoading.value = false;
    }
  }

  logIn({String? email, String? password}) async {
    if (!logInValidation()) {
      return;
    }
    try {
      loading.value = true;
      UserCredential user = await auth.signInWithEmailAndPassword(
          email: email.toString(), password: password.toString());
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
      Get.off(() => const HomeScreen());
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == 'network-request-failed') {
        return errorSnackbar(title: 'error', message: 'No Internet Connection',);
      } else if (e.code == "wrong-password") {
        return errorSnackbar(title: 'error',message: 'Please Enter correct password');
      } else if (e.code == 'user-not-found') {
        errorSnackbar(title: 'error', message:'Email not found');
      } else if (e.code == 'too-many-requests') {
        return errorSnackbar(title: 'error',message: 'Too many attempts please try later');
      } else if (e.code == 'unknwon') {
        return errorSnackbar(title: 'error',message: 'Email and password field are required');
      } else if (e.code == 'unknown') {
        return errorSnackbar(title: 'error',message: 'Email and Password Fields are required');
      } else if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
        return errorSnackbar(title: 'error',message: 'No user found for that email.');
      } else {
        return errorSnackbar(title: 'error',message: e.code.toString());
      }
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


  @override
  void dispose() {
    super.dispose();
    userNameController.clear();
    phoneNumberController.clear();
    emailSignInController.clear();
    passwordSignInController.clear();
  }
}
