import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/Common/app_string.dart';
import '../HomeScreen/home_controller.dart';

class Editcontroler extends GetxController{
  TextEditingController task = TextEditingController();
  TextEditingController description = TextEditingController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final HomeController homeController = Get.find();
  bool isempty = false;

  validator() {
    if (task.text.isEmpty || description.text.isEmpty) {
      isempty = false;
    } else {
      isempty = true;
    }
    update();
  }


  editTaskData({required String docId,}) async {
    await firestore.collection(AppString.taskCollection).doc(docId).update({
      "task": task.text,
      "description": description.text,
      "date":  DateTime.now(),
    }).then((value) {
      Get.back();
      task.clear();
      description.clear();
      // homeController.getdata();
    });
  }

}