import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:task_management/models/task.dart';

class TaskProvider extends ChangeNotifier {
  final List<Task> _todoTaskList = [];
  final List<Task> _inProgressTaskList = [];
  final List<Task> _doneTaskList = [];

  List<Task> get allInProgressTasks =>
      UnmodifiableListView(_inProgressTaskList);

  List<Task> get allToDoTasks => UnmodifiableListView(_todoTaskList);

  List<Task> get allDoneTasks => UnmodifiableListView(_doneTaskList);

  int get numOfAllTask =>
      _inProgressTaskList.length + _todoTaskList.length + _doneTaskList.length;

  int get numOfTodoTask => _todoTaskList.length;

  int get numOfInProgressTask => _inProgressTaskList.length;

  int get numOfDoneTask => _doneTaskList.length;

  void addTodoTask(Task task) {
    _todoTaskList.add(task);
    notifyListeners();
  }

  void addInProgressTask(Task task) {
    _inProgressTaskList.add(task);
    notifyListeners();
  }

  void addDoneTask(Task task) {
    _doneTaskList.add(task);
    notifyListeners();
  }

  void updateTodoTask({
    required int index,
    required Task task,
  }) {
    _todoTaskList[index] = task;
    notifyListeners();
  }

  void updateInProgressTask({
    required int index,
    required Task task,
  }) {
    _inProgressTaskList[index] = task;
    notifyListeners();
  }

  void updateDoneTask({
    required int index,
    required Task task,
  }) {
    _doneTaskList[index] = task;
    notifyListeners();
  }

  void deleteTodoTask(int index) {
    _todoTaskList.removeAt(index);
    notifyListeners();
  }

  void deleteInProgressTask(int index) {
    _inProgressTaskList.removeAt(index);
    notifyListeners();
  }

  void deleteDoneTask(int index) {
    _doneTaskList.removeAt(index);
    notifyListeners();
  }
}
