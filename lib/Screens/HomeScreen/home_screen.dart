import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../utils/Common/app_string.dart';
import '../AddTaskScreen/addtask_controller.dart';
import '../AddTaskScreen/addtask_screen.dart';
import '../Auth/Auth_controller.dart';
import '../Auth/SignUp/signup_screen.dart';
import 'home_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController homeController = Get.put(HomeController());
  final AddTaskcontroller addTaskcontroller = Get.put(AddTaskcontroller());
  final AuthController authController = Get.put(AuthController());
  // NotificationService notificationService = NotificationService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    homeController.getdata();
    homeController.userdata();
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    authController.userNameController.clear();
    authController.addressSignInController.clear();
    authController.bodSignInController.clear();
    authController.phoneNumberController.clear();
    authController.emailSignInController.clear();
    authController.passwordSignInController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppString.homescreen),
        actions: [
          IconButton(
            onPressed: (){
               authController.userNameController.text = homeController.loginUser!.username.toString();
               authController.addressSignInController.text = homeController.loginUser!.address.toString();
               authController.bodSignInController.text = homeController.loginUser!.birthofdate.toString();
               authController.phoneNumberController.text = homeController.loginUser!.phone.toString();
               authController.emailSignInController.text = homeController.loginUser!.email.toString();
               authController.passwordSignInController.text = homeController.loginUser!.password.toString();
               Get.to(const SignUpScreen(isEdit: true,));
            },
            icon: Icon(Icons.person_outline_rounded,size: 15.sp,),
            tooltip: 'Edit Profile',
          ),
          IconButton(
              onPressed: ()=> homeController.logout(),
              icon: Icon(Icons.logout,size: 15.sp,),
            tooltip: 'Log Out',
          ),
          // IconButton(
          //   onPressed: ()=> Get.to(const SearchScreen()),
          //   icon: Icon(Icons.search,size: 15.sp,),
          // ),
        ],
      ),
      body:
      // Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: const [
      //       // ElevatedButton(
      //       //     onPressed: (){
      //       //       notificationService.showNotification(
      //       //         title: "vandan", body: "hello world",
      //       //       );
      //       //     },
      //       //     child: const Text("notification"),
      //       // ),
      //     ],
      //   ),
      // ),
      Obx(() {
        return homeController.tasklist.isEmpty
            ? Center(
                child: Text(
                  AppString.taskisempty,
                  style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: AppColors.primaryColor),
                ),
              )
            : ListView.builder(
                itemCount: homeController.tasklist.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final item = homeController.tasklist[index];
                  return Dismissible(
                    key: Key(item.toString()),
                    onDismissed: (direction) {
                      homeController.deleteDialog(
                        docId: homeController.tasklist[index].id.toString(),
                        context: context,
                      );
                    },
                    background: const ColoredBox(
                      color: Colors.red,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                      ),
                    ),
                    child: Card(
                      shadowColor: Colors.indigo,
                      elevation: 5,
                      color: Colors.white,
                      child: ListTile(
                        leading: Text(
                          '${1 + index}',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        title: Text(
                          homeController.tasklist[index].task.toString(),
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 1.h,
                            ),
                            Text(
                                homeController.tasklist[index].description
                                    .toString(),
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: AppColors.primaryColor,
                                ),
                                overflow: TextOverflow.ellipsis),
                            SizedBox(
                              height: 1.h,
                            ),
                            Text(
                              homeController.tasklist[index].date.toString(),
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            CircleAvatar(
                              child: IconButton(
                                onPressed: () {
                                  addTaskcontroller.taskAddController.text = homeController.tasklist[index].task.toString();
                                  addTaskcontroller.descriptionAddController.text = homeController.tasklist[index].description.toString();
                                  addTaskcontroller.dateInputController.text = homeController.tasklist[index].date.toString();
                                  addTaskcontroller.timeInputController.text = homeController.tasklist[index].time.toString();
                                  Get.to(
                                    AddTaskScreen(
                                      isEdit: true,
                                      docId: homeController.tasklist[index].id.toString(),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.edit),
                              ),
                            ),
                            Text(
                              homeController.tasklist[index].time.toString(),
                              style: TextStyle(
                                  fontSize: 10.sp,
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                });
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(const AddTaskScreen(
          isEdit: false,
        )),
        child: const Icon(Icons.add),
      ),
    );
  }
}
