import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:todo_app/Services/google_ads.dart';
import '../../utils/Common/app_string.dart';
import '../../utils/Common_Widgets/custom_textfiled.dart';
import '../Auth/Auth_controller.dart';
import '../HomeScreen/home_controller.dart';
import 'addtask_controller.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key, this.docId, required this.isEdit});

  final String? docId;
  final bool isEdit;

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final AddTaskcontroller addTaskcontroller = Get.put(AddTaskcontroller());
  final HomeController homeController = Get.put(HomeController());
  final AuthController authController = Get.put(AuthController());
  final GoogleAdsManager googleAdsManager = Get.put(GoogleAdsManager());

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    addTaskcontroller.taskAddController.clear();
    addTaskcontroller.descriptionAddController.clear();
    addTaskcontroller.dateInputController.clear();
    addTaskcontroller.timeInputController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.isEdit ? AppString.edit : AppString.addtask),
          leading: IconButton(
            onPressed: () {
              if (googleAdsManager.interstitialAd != null) {
                googleAdsManager.interstitialAd!.show();
                googleAdsManager.InterstitialAds();
              }
              homeController.getdata();
              Get.back();
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              CustomTextField(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)),
                textEditingController: addTaskcontroller.taskAddController,
                hintText: AppString.pleaseTask,
                labelText: AppString.task,
                textInputAction: TextInputAction.next,
                readOnly: false,
                password: false,
              ),
              CustomTextField(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)),
                textEditingController:
                addTaskcontroller.descriptionAddController,
                hintText: AppString.pleaseDescription,
                labelText: AppString.description,
                textInputAction: TextInputAction.done,
                readOnly: false,
                password: false,
              ),
              CustomTextField(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)),
                textEditingController: addTaskcontroller.dateInputController,
                hintText: AppString.pleaseDate,
                labelText: AppString.date,
                password: false,
                suffixIcon: IconButton(
                  onPressed: () {
                    widget.isEdit
                        ? addTaskcontroller.datePickerWidget(context)
                        : addTaskcontroller.datePickerWidget(context);
                  },
                  icon: const Icon(Icons.calendar_month_outlined),
                ),
                readOnly: true,
                onTap: () {
                  widget.isEdit
                      ? addTaskcontroller.datePickerWidget(context)
                      : addTaskcontroller.datePickerWidget(context);
                },
              ),
              CustomTextField(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)),
                textEditingController: addTaskcontroller.timeInputController,
                hintText: AppString.pleaseTime,
                labelText: AppString.time,
                password: false,
                suffixIcon: IconButton(
                  onPressed: () {
                    widget.isEdit
                        ? addTaskcontroller.timePickerWidget(context)
                        : addTaskcontroller.timePickerWidget(context);
                  },
                  icon: const Icon(Icons.access_time_outlined),
                ),
                readOnly: true,
                onTap: () {
                  widget.isEdit
                      ? addTaskcontroller.timePickerWidget(context)
                      : addTaskcontroller.timePickerWidget(context);
                },
              ),
              SizedBox(
                height: 5.h,
              ),
              Obx(() {
                return SizedBox(
                  width: 150.w,
                  child: ElevatedButton(
                    onPressed: () {
                      widget.isEdit
                          ? addTaskcontroller.editTaskData(docId: widget
                          .docId!,)
                          : addTaskcontroller.addTask();
                      },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                    ),
                      child: widget.isEdit
                          ? (addTaskcontroller.isEditLoading.value)
                          ? const CircularProgressIndicator(
                        color: Colors.white,
                      ) : Text(
                        AppString.update,
                        style: const TextStyle(color: Colors.white),
                      )
                          : (addTaskcontroller.isAddLoading.value)
                          ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                          : Text(
                        AppString.add,
                        style: const TextStyle(color: Colors.white),
                      ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
