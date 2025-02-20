import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_management/models/task.dart';
import 'package:task_management/utilities/constants.dart';

class TaskProvider extends ChangeNotifier {
  final List<Task> _todoTaskList = [];
  final List<Task> _inProgressTaskList = [];
  final List<Task> _completedTaskList = [];

  final Box<Task> _todoBox = Hive.box<Task>(todoTaskBox);
  final Box<Task> _inProgressBox = Hive.box<Task>(inProgressTaskBox);
  final Box<Task> _completedBox = Hive.box<Task>(completedTaskBox);

  List<Task> get allInProgressTasks =>
      UnmodifiableListView(_inProgressTaskList);

  List<Task> get allToDoTasks => UnmodifiableListView(_todoTaskList);

  List<Task> get allCompletedTasks => UnmodifiableListView(_completedTaskList);

  int get numOfAllTask =>
      _inProgressTaskList.length +
      _todoTaskList.length +
      _completedTaskList.length;

  int get numOfTodoTask => _todoTaskList.length;

  int get numOfInProgressTask => _inProgressTaskList.length;

  int get numOfCompletedTask => _completedTaskList.length;

  void addTodoTask(Task task) async {
    try {
      _todoTaskList.add(task);
      await _todoBox.add(task);
      debugPrint('${task.taskName} added successfully');

      notifyListeners();
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void addInProgressTask(Task task) async {
    try {
      _inProgressTaskList.add(task);
      await _inProgressBox.add(task);
      debugPrint('${task.taskName} added successfully');

      notifyListeners();
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void addCompletedTask(Task task) async {
    try {
      _completedTaskList.add(task);
      await _completedBox.add(task);
      debugPrint('${task.taskName} added successfully');

      notifyListeners();
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void updateTodoTask({
    required int index,
    required Task task,
  }) async {
    try {
      _todoTaskList[index] = task;
      await _todoBox.putAt(index, task);
      debugPrint('${task.taskName} updated successfully');

      notifyListeners();
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void updateInProgressTask({
    required int index,
    required Task task,
  }) async {
    try {
      _inProgressTaskList[index] = task;
      await _inProgressBox.putAt(index, task);
      debugPrint('${task.taskName} updated successfully');

      notifyListeners();
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void updateCompletedTask({
    required int index,
    required Task task,
  }) async {
    try {
      _completedTaskList[index] = task;
      await _completedBox.putAt(index, task);
      debugPrint('${task.taskName} updated successfully');

      notifyListeners();
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void deleteTodoTask(int index) async {
    try {
      _todoTaskList.removeAt(index);
      await _todoBox.deleteAt(index);
      debugPrint('Todo Removed Successfully');

      notifyListeners();
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void deleteInProgressTask(int index) async {
    try {
      _inProgressTaskList.removeAt(index);
      await _inProgressBox.deleteAt(index);
      debugPrint('Todo Removed Successfully');

      notifyListeners();
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void deleteCompletedTask(int index) async {
    try {
      _completedTaskList.removeAt(index);
      await _completedBox.deleteAt(index);
      debugPrint('Todo Removed Successfully');

      notifyListeners();
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void clearTasks() async {
    _todoTaskList.clear();
    _inProgressTaskList.clear();
    _completedTaskList.clear();

    await _todoBox.clear();
    await _inProgressBox.clear();
    await _completedBox.clear();

    notifyListeners();
  }

  void loadTasks() {
    _todoTaskList.clear();
    _inProgressTaskList.clear();
    _completedTaskList.clear();

    _todoTaskList.addAll(_todoBox.values);
    _inProgressTaskList.addAll(_inProgressBox.values);
    _completedTaskList.addAll(_completedBox.values);

    notifyListeners();
  }
}
