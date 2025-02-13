import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

const themeColor = Colors.blue;
const errorColor = Color(0xFFCF6679);
const kWhiteColor = Color(0xffFFFFFF);

final List<String> categories = ["To Do", "In Progress", "Done"];

void showToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: errorColor,
    textColor: Colors.white,
    fontSize: 16.0.sp,
  );
}
