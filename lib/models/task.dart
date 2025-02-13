import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task {
  @HiveField(0)
  final String taskName;

  @HiveField(1)
  final DateTime date;

  @HiveField(2)
  final TimeOfDay starTime;

  @HiveField(3)
  final TimeOfDay endTime;

  @HiveField(4)
  final String description;

  @HiveField(5)
  final String category;

  Task({
    required this.taskName,
    required this.date,
    required this.starTime,
    required this.endTime,
    required this.description,
    required this.category,
  });
}
