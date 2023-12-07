import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:todo_app/Services/ads_manger.dart';
import '../../Model/Usermodel.dart';
import '../../Model/taskadd_model.dart';
import '../../Services/Pref_Res.dart';
import '../../utils/Common/app_string.dart';
import '../../utils/Common_Widgets/custom_text.dart';
import '../Auth/LogInScreen/login_screen.dart';


class HomeController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  RxBool isLoading = false.obs;
  var tasklist = <TaskAddModel>[].obs;
  String userId = PrefService.getString(PrefRes.userId);
  UserModel? loginUser;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await AdManager.loadUnityIntAd();
      await AdManager.loadUnityRewardedAd();
    });
  }


  userdata() async {
    try{
      firestore.collection(AppString.userCollection).doc(userId).get().then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          Map<String, dynamic>? userData = documentSnapshot.data() as Map<String, dynamic>?;
          loginUser = UserModel.fromJson(userData!);
        }else {
          print('Document does not exist on the database');
        }
      });
    }
    catch(e){
      print(e.toString());
    }
  }

  logout() async {
    await FirebaseAuth.instance.signOut();
    PrefService.setValue(PrefRes.loginUser, false);
    Get.snackbar("Successfully", "Successfully Log Out",
      backgroundColor: AppColors.primaryColor,
      colorText: AppColors.whiteColor,
    );
    Get.offAll(LogInScreen());
  }

   getdata() async {
    try {
      tasklist.clear();
      isLoading.value = true;
      await firestore.collection(AppString.userCollection).doc(userId).collection(AppString.taskCollection).get().then((value) {
        for (var element in value.docs) {
          tasklist.add(
            TaskAddModel.fromJson(
              element.data()
            ),
          );
          print(element.data());
        }
      });
    }catch(e){
      print('getdata:---${e.toString()}');
      rethrow;
    }finally {
      isLoading.value = false;
    }
  }


  Future<void> deleteDialog({required String docId,required BuildContext context,}) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: SizedBox(
            height: 18.h,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                   Text(AppString.deleteDialog,style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: AppColors.primaryColor),),
                   SizedBox(height: 2.h,),
                  Text(AppString.deleteTitle,style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: AppColors.primaryColor),),
                  SizedBox(height: 2.h,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: (){
                          deleteTask(id: docId,);
                        },
                        child: Container(
                          height: 5.h,
                          width: 20.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.redColor,),
                          ),
                          child: Center(
                            child: CustomText(
                              text: AppString.delete,
                              fontSize: 12,
                              color: AppColors.redColor,
                            ),
                          ),
                        ),
                      ),
                       SizedBox(width: 15.w,),
                      GestureDetector(
                        onTap: (){
                          getdata();
                          Get.back();
                        },
                        child: Container(
                          height: 5.h,
                          width: 20.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.primaryColor,),
                          ),
                          child: Center(
                            child: CustomText(
                              text: AppString.cancel,
                              fontSize: 12,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  deleteTask({required String id}) async {
   await firestore.collection(AppString.userCollection).doc(userId).collection(AppString.taskCollection).doc(id).delete().then((value) {
      getdata();
      Get.back();
    });
  }

}
