import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../utils/Common/app_string.dart';
import '../../utils/Common_Widgets/custom_textfiled.dart';
import 'edit_controller.dart';

class EditScreen extends StatelessWidget {
  EditScreen({super.key, required this.docId});
  final String docId;
  final Editcontroler editcontroler = Get.put(Editcontroler());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppString.edit),
      ),
      body: Column(
        children: [
          CustomTextField(
            textEditingController: editcontroler.task,
            onChanged: (p0) => editcontroler.validator(),
            textInputAction: TextInputAction.next,
            readOnly: false,
            password: false,
          ),
          CustomTextField(
            textEditingController: editcontroler.description,
            onChanged: (p0) => editcontroler.validator(),
            textInputAction: TextInputAction.done,
            readOnly: false,
            password: false,
          ),
          SizedBox(
            height: 5.h,
          ),
          SizedBox(
            width: 150.w,
            child: ElevatedButton(
              onPressed: () =>
                  editcontroler.editTaskData(docId: docId),
              child: Text(AppString.update),
            ),
          ),
        ],
      ),
    );
  }
}
