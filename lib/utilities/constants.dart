import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

const themeColor = Colors.blue;
const errorColor = Color(0xFFCF6679);
const kWhiteColor = Color(0xffFFFFFF);
const String todoTaskBox = "todotaskbox";
const String inProgressTaskBox = "inprogresstaskbox";
const String doneTaskBox = "donetaskbox";
const String themeBox = "themebox";

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

String formatDateShowWeekDay(DateTime date) {
  return DateFormat('EEEE').format(date);
}

String formatDateShowDayAndMonth(DateTime date) {
  return DateFormat('d MMMM').format(date);
}

String formatTimeOfDay(TimeOfDay time) {
  final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
  final minute = time.minute.toString().padLeft(2, '0');
  final period = time.period == DayPeriod.am ? "AM" : "PM";
  return "$hour:$minute $period";
}

// String formatDate(DateTime date) {
//   try {
//     final String formattedDate = DateFormat('dd-MM-yyyy').format(date);
//     return formattedDate;
//   } catch (e) {
//     return date.toString();
//   }
// }

String formatDate(DateTime date) {
  return DateFormat('EEEE, d MMMM yyyy').format(date);
}
