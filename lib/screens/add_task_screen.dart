import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:task_management/provider/task_provider.dart';
import 'package:task_management/models/task.dart';
import 'package:task_management/utilities/constants.dart';

class CreateTaskScreen extends StatefulWidget {
  final Task? task;
  final int? taskIndex;
  final int? categoryIndexForTaskCreation;
  const CreateTaskScreen({
    super.key,
    this.task,
    this.taskIndex,
    this.categoryIndexForTaskCreation,
  });

  @override
  CreateTaskScreenState createState() => CreateTaskScreenState();
}

class CreateTaskScreenState extends State<CreateTaskScreen> {
  int _selectedCategoryIndex = 0;
  DateTime selectedDate = DateTime.now();
  TimeOfDay startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay endTime = const TimeOfDay(hour: 11, minute: 0);
  final TextEditingController taskNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  // final _taskBox = Hive.box(taskBox);

  void createTask() async {
    if (taskNameController.text.trim().isEmpty) {
      showToast("Task name field cannot be empty");
      return;
    }
    if (descriptionController.text.trim().isEmpty) {
      showToast("Description field cannot be empty");
      return;
    }

    TaskProvider taskProvider = context.read<TaskProvider>();
    Task task = Task(
      taskName: taskNameController.text.trim(),
      date: selectedDate,
      starTime: startTime,
      endTime: endTime,
      description: descriptionController.text.trim(),
      category: categories[_selectedCategoryIndex],
    );

    _selectedCategoryIndex == 0
        ? taskProvider.addTodoTask(task)
        : _selectedCategoryIndex == 1
            ? taskProvider.addInProgressTask(task)
            : taskProvider.addDoneTask(task);
    if (mounted) {
      Navigator.pop(context);
    }
  }

  void updateTask() {
    if (taskNameController.text.trim().isEmpty) {
      showToast("Task name field cannot be empty");
      return;
    }
    if (descriptionController.text.trim().isEmpty) {
      showToast("Description field cannot be empty");
      return;
    }

    TaskProvider taskProvider = context.read<TaskProvider>();
    Task task = Task(
      taskName: taskNameController.text.trim(),
      date: selectedDate,
      starTime: startTime,
      endTime: endTime,
      description: descriptionController.text.trim(),
      category: categories[_selectedCategoryIndex],
    );
    if (categories[_selectedCategoryIndex] == widget.task!.category) {
      _selectedCategoryIndex == 0
          ? taskProvider.updateTodoTask(index: widget.taskIndex!, task: task)
          : _selectedCategoryIndex == 1
              ? taskProvider.updateInProgressTask(
                  index: widget.taskIndex!, task: task)
              : taskProvider.updateDoneTask(
                  index: widget.taskIndex!, task: task);
    }

    if (categories[_selectedCategoryIndex] != widget.task!.category) {
      _selectedCategoryIndex == 0
          ? taskProvider.addTodoTask(task)
          : _selectedCategoryIndex == 1
              ? taskProvider.addInProgressTask(task)
              : taskProvider.addDoneTask(task);

      _setCategory(widget.task!.category) == 0
          ? taskProvider.deleteTodoTask(widget.taskIndex!)
          : _setCategory(widget.task!.category) == 1
              ? taskProvider.deleteInProgressTask(widget.taskIndex!)
              : taskProvider.deleteDoneTask(widget.taskIndex!);
    }

    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();

    if (widget.task != null) {
      setState(() {
        taskNameController.text = widget.task!.taskName;
        descriptionController.text = widget.task!.description;
        startTime = widget.task!.starTime;
        endTime = widget.task!.endTime;
        selectedDate = widget.task!.date;
        _selectedCategoryIndex = _setCategory(widget.task!.category);
      });
    }

    if (widget.categoryIndexForTaskCreation != null) {
      setState(() {
        _selectedCategoryIndex = widget.categoryIndexForTaskCreation!;
      });
    }
  }

  @override
  void dispose() {
    taskNameController.clear();
    descriptionController.clear();
    super.dispose();
  }

  int _setCategory(String category) {
    if (category == categories[0]) {
      return 0;
    } else if (category == categories[1]) {
      return 1;
    } else {
      return 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios, size: 20.sp),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    widget.task == null ? 'Create New Task' : 'Update Task',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),

              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Task Name',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      TextField(
                        controller: taskNameController,
                        decoration: InputDecoration(
                          hintText: 'UI Design',
                          filled: true,
                          // fillColor: Colors.grey[50],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),

                      Text(
                        'Category',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 4.0,
                        children: List.generate(categories.length, (index) {
                          return ChoiceChip(
                            label: Text(
                              categories[index],
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            selected: _selectedCategoryIndex == index,
                            onSelected: (bool selected) {
                              setState(() {
                                _selectedCategoryIndex = selected ? index : -1;
                              });
                            },
                          );
                        }),
                      ),

                      SizedBox(height: 20.h),

                      // Date & Time
                      Text(
                        'Date & Time',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      TextField(
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: '05 April, Tuesday',
                          filled: true,
                          // fillColor: Colors.grey[50],
                          suffixIcon: Icon(
                            Icons.calendar_today,
                            size: 20.sp,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2035),
                          );
                          if (picked != null) {
                            setState(
                              () => selectedDate = picked,
                            );
                          }
                        },
                      ),

                      SizedBox(height: 20.h),

                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Start time',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                _buildTimeField(
                                  startTime,
                                  (time) => setState(
                                    () => startTime = time,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'End time',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                _buildTimeField(
                                  endTime,
                                  (time) => setState(
                                    () => endTime = time,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 20.h),

                      // Description
                      Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      TextField(
                        controller: descriptionController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Task description here...',
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      SizedBox(height: 30.h),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            widget.task == null ? createTask() : updateTask();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: EdgeInsets.symmetric(vertical: 15.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: Text(
                            widget.task == null ? 'Create Task' : 'Update Task',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Task Name
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeField(TimeOfDay time, Function(TimeOfDay) onTimeSelected) {
    return GestureDetector(
      onTap: () async {
        final TimeOfDay? picked = await showTimePicker(
          context: context,
          initialTime: time,
        );
        if (picked != null) {
          onTimeSelected(picked);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} ${time.period.name.toUpperCase()}',
              style: TextStyle(fontSize: 14.sp),
            ),
            Icon(Icons.arrow_drop_down, size: 20.sp),
          ],
        ),
      ),
    );
  }
}
