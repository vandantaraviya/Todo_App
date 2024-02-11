import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/Services/ads_manger.dart';
import '../../Services/Pref_Res.dart';
import '../../utils/Common/app_string.dart';
import '../HomeScreen/home_controller.dart';

class AddTaskcontroller extends GetxController{
  TextEditingController taskAddController = TextEditingController();
  TextEditingController descriptionAddController = TextEditingController();
  TextEditingController dateInputController = TextEditingController();
  TextEditingController timeInputController = TextEditingController();
  bool isempty = false;
  RxBool isAddLoading = false.obs;
  RxBool isEditLoading = false.obs;
  final HomeController homeController = Get.find();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String userId = PrefService.getString(PrefRes.userId);

  addTask() async {
    if (!taskAddvalidator()) {
      return;
    }
    print(userId);
    try {
      isAddLoading.value = true;
      await AdManager.showRewardedAd();
      firestore.collection(AppString.userCollection).doc(userId).collection(AppString.taskCollection).add({
        "task": taskAddController.text,
        "description": descriptionAddController.text,
        "date":  dateInputController.text,
        "time":  timeInputController.text,
        "id": "",
      }).then(
        (value) async {
          firestore.collection(AppString.userCollection).doc(userId).collection(AppString.taskCollection).doc(value.id).update({
            "id": value.id,
          });
          print(value.id);
          print("-----------${taskAddController}--------${descriptionAddController}---------");
          Get.back();
          taskAddController.clear();
          descriptionAddController.clear();
          dateInputController.clear();
          timeInputController.clear();
          homeController.getdata();
        },
      );
    }catch(e){
      print('Addtask:------${e.toString()}');
      rethrow;
    }finally{
      isAddLoading.value = false;
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
         dateInputController.text = formattedDate;
     }else{
       errorSnackbar(title: 'error',message: "Date is not selected");
     }
  }

  timePickerWidget(BuildContext context) async {
    TimeOfDay? pickedTime =  await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );
    if(pickedTime != null ){
      String formattedTime = pickedTime.format(context);
      print(formattedTime);
        timeInputController.text = formattedTime.toString();
    }else{
      errorSnackbar(title: 'error',message: "Time is not selected");
    }
  }

  editTaskData({required String docId}) async {
    if(!taskEditValidator()){
      return;
    }
    try{
      isEditLoading.value = true;
      await firestore
          .collection(AppString.userCollection)
          .doc(userId)
          .collection(AppString.taskCollection)
          .doc(docId)
          .update({
        "task": taskAddController.text,
        "description": descriptionAddController.text,
        "date": dateInputController.text,
        "time": timeInputController.text,
      }).then((value) {
        Get.back();
        taskAddController.clear();
        descriptionAddController.clear();
        dateInputController.clear();
        timeInputController.clear();
        homeController.getdata();
      });
    }finally{
     isEditLoading.value = false;
    }
  }

  errorSnackbar({required String title,required String message}){
    return Get.snackbar(title, message,  backgroundColor: AppColors.redColor, colorText: AppColors.whiteColor,);
  }


  taskEditValidator() {
    Get.closeAllSnackbars();
    if (taskAddController.text.isEmpty) {
      errorSnackbar(title: 'error',message: "Please enter Task");
      return false;
    } else if (descriptionAddController.text.isEmpty) {
      errorSnackbar(title: 'error',message: "Please enter description");
      return false;
    } else if (dateInputController.text.isEmpty) {
      errorSnackbar(title: 'error',message: "Please enter Date");
      return false;
    } else if (timeInputController.text.isEmpty) {
      errorSnackbar(title: 'error',message: "Please enter Time");
      return false;
    }
    return true;
  }


  taskAddvalidator() {
    Get.closeAllSnackbars();
    if (taskAddController.text.isEmpty) {
      errorSnackbar(title: 'error',message: "Please enter Task");
      return false;
    } else if (descriptionAddController.text.isEmpty) {
      errorSnackbar(title: 'error',message: "Please enter description");
      return false;
    } else if (dateInputController.text.isEmpty) {
      errorSnackbar(title: 'error',message: "Please enter Date");
      return false;
    } else if (timeInputController.text.isEmpty) {
      errorSnackbar(title: 'error',message: "Please enter Time");
      return false;
    }
    return true;
  }

}