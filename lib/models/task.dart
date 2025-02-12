import 'package:flutter/material.dart';

class Task {
  final String taskName;
  final DateTime date;
  final TimeOfDay starTime;
  final TimeOfDay endTime;
  final String description;
  final String category;
  // final IconData icon;
  // final Color iconBackgroundColor;

  Task({
    required this.taskName,
    required this.date,
    required this.starTime,
    required this.endTime,
    required this.description,
    required this.category,
    // required this.timeRange,
    // required this.icon,
    // required this.iconBackgroundColor,
  });
}
