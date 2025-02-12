import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:task_management/provider/task_provider.dart';
import 'package:task_management/screens/add_task_screen.dart';

class Task {
  final String title;
  final String timeRange;
  final IconData icon;
  final Color iconBackgroundColor;

  Task({
    required this.title,
    required this.timeRange,
    required this.icon,
    required this.iconBackgroundColor,
  });
}

class TaskListUI extends StatelessWidget {
  final List<Task> tasks = [
    Task(
      title: 'UI Design',
      timeRange: '09:00 AM - 11:00 AM',
      icon: Icons.palette,
      iconBackgroundColor: Colors.orange.shade100,
    ),
    Task(
      title: 'Web Development',
      timeRange: '11:30 AM - 12:30 PM',
      icon: Icons.code,
      iconBackgroundColor: Colors.blue.shade100,
    ),
    Task(
      title: 'Office Meeting',
      timeRange: '02:00 PM - 03:00 PM',
      icon: Icons.people,
      iconBackgroundColor: Colors.green.shade100,
    ),
    Task(
      title: 'Dashboard Design',
      timeRange: '03:30 PM - 05:00 PM',
      icon: Icons.lightbulb,
      iconBackgroundColor: Colors.yellow.shade100,
    ),
  ];

  TaskListUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Consumer<TaskProvider>(
            builder: (context, tasks, child) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios, size: 20.sp),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      "Ongoing Task",
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
                    itemCount: tasks.length,
                    separatorBuilder: (context, index) => SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const CreateTaskScreen(),
                            ),
                          );
                        },
                        child: TaskCard(
                          task: tasks[index],
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
          task.title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          task.timeRange,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12.sp,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: Colors.grey,
        ),
      ),
    );
  }
}
