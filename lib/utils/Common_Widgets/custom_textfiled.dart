import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


// ignore: must_be_immutable
class CustomTextField extends StatelessWidget {
  final TextEditingController? textEditingController;
  void Function(String)? onChanged;
  TextInputAction? textInputAction;
  Widget? suffixIcon;
  String? labelText;
  String? hintText;
  bool readOnly;
  bool password;
  void Function()? onTap;
  InputBorder? border;
  int? maxLength;
  TextInputType? keyboardType;
  String? Function(String?)? validator;


  CustomTextField({super.key,
    this.textEditingController,
    this.onChanged,
    this.textInputAction,
    this.suffixIcon,
    this.labelText,
    this.hintText,
    required this.readOnly,
    this.onTap,
    this.border,
    this.maxLength,
    this.keyboardType,required this.password,this.validator});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 2.h,
            ),
            TextFormField(
              obscureText: password,
              maxLength: maxLength,
              decoration: InputDecoration(
                border: border,
                suffixIcon: suffixIcon,
                labelText: labelText,
                hintText: hintText,
              ),
              onChanged: onChanged,
              readOnly: readOnly,
              onTap: onTap,
              controller: textEditingController,
              textInputAction: textInputAction,
              keyboardType: keyboardType,
              validator: validator,
            ),
          ],
        ),
      );
  }
}
