import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double fontSize;
  final TextAlign? textAlign;
  final Color? color;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  final TextOverflow? overflow;
  CustomText({super.key, required this.text, required this.fontSize,this.textAlign,this.color,this.fontStyle,this.fontWeight,this.overflow});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        fontSize: fontSize.sp,
      ),
      textAlign: textAlign,
      overflow: overflow,
    );
  }
}
