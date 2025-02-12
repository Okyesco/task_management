import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:task_management/provider/task_provider.dart';
import 'package:task_management/models/task.dart';
import 'package:task_management/utilities/constants.dart';

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key});

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

  final List<String> _categories = ["To Do", "In Progress", "Done"];

  void createTask() {
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
      category: _categories[_selectedCategoryIndex],
    );

    _selectedCategoryIndex == 0
        ? taskProvider.addTodoTask(task)
        : _selectedCategoryIndex == 1
            ? taskProvider.addInProgressTask(task)
            : taskProvider.addDoneTask(task);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button and title
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios, size: 20.sp),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    'Create New Task',
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
                        children: List.generate(_categories.length, (index) {
                          return ChoiceChip(
                            label: Text(
                              _categories[index],
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            selected: _selectedCategoryIndex == index,
                            onSelected: (bool selected) {
                              setState(() {
                                _selectedCategoryIndex = selected ? index : -1;
                              });
                              // print(_selectedCategoryIndex);
                              // print(_categories[_selectedCategoryIndex]);
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

                      // Start and End Time
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

                      // Create Task Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            createTask();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: EdgeInsets.symmetric(vertical: 15.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: Text(
                            'Create Task',
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

  // Widget _buildCategoryChip(String label, bool isSelected) {
  //   return GestureDetector(
  //     onTap: () => setState(() => selectedCategory = label),
  //     child: Container(
  //       padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
  //       decoration: BoxDecoration(
  //         color: isSelected ? Colors.blue : Colors.grey[50],
  //         borderRadius: BorderRadius.circular(20.r),
  //       ),
  //       child: Text(
  //         label,
  //         style: TextStyle(
  //           color: isSelected ? Colors.white : Colors.black,
  //           fontWeight: FontWeight.w500,
  //         ),
  //       ),
  //     ),
  //   );
  // }

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
