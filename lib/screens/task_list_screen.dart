import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:task_management/models/task.dart';
import 'package:task_management/provider/task_provider.dart';
import 'package:task_management/screens/add_task_screen.dart';
import 'package:task_management/utilities/constants.dart';
import 'package:intl/intl.dart';

class TaskListUI extends StatelessWidget {
  final int categoryIndex;

  const TaskListUI({
    super.key,
    required this.categoryIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        tooltip: "Add new task",
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CreateTaskScreen(
                categoryIndexForTaskCreation: categoryIndex,
              ),
            ),
          );
        },
        foregroundColor: Colors.white,
        backgroundColor: Colors.lightBlue,
        elevation: 1,
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Consumer<TaskProvider>(
            builder: (context, taskProvider, child) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios, size: 20.sp),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      categories[categoryIndex],
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Expanded(
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    itemCount: categoryIndex == 0
                        ? taskProvider.numOfTodoTask
                        : categoryIndex == 1
                            ? taskProvider.numOfInProgressTask
                            : taskProvider.numOfDoneTask,
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => CreateTaskScreen(
                                task: categoryIndex == 0
                                    ? taskProvider.allToDoTasks[index]
                                    : categoryIndex == 1
                                        ? taskProvider.allInProgressTasks[index]
                                        : taskProvider.allDoneTasks[index],
                                index: index,
                              ),
                            ),
                          );
                        },
                        child: TaskCard(
                          task: categoryIndex == 0
                              ? taskProvider.allToDoTasks[index]
                              : categoryIndex == 1
                                  ? taskProvider.allInProgressTasks[index]
                                  : taskProvider.allDoneTasks[index],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  final Task task;

  const TaskCard({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1.r,
            blurRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        leading: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: const Icon(
            Icons.task,
          ),
        ),
        title: Text(
          task.taskName,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text(
            //   formatDate(task.date),
            //   style: TextStyle(
            //     color: Colors.grey[600],
            //     fontSize: 12.sp,
            //   ),
            // ),
            Text(
              "${formatTimeOfDay(task.starTime)} - ${formatTimeOfDay(task.endTime)}",
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: Colors.grey,
        ),
      ),
    );
  }
}

String formatTimeOfDay(TimeOfDay time) {
  final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
  final minute = time.minute.toString().padLeft(2, '0');
  final period = time.period == DayPeriod.am ? "AM" : "PM";
  return "$hour:$minute $period";
}

String formatDate(DateTime date) {
  try {
    final String formattedDate = DateFormat('dd-MM-yyyy').format(date);
    return formattedDate;
  } catch (e) {
    return date.toString();
  }
}
