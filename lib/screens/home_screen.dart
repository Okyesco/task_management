import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:task_management/models/task.dart';
import 'package:task_management/provider/task_provider.dart';
import 'package:task_management/provider/theme_provider.dart';
import 'package:task_management/screens/add_task_screen.dart';
import 'package:task_management/screens/task_list_screen.dart';
import 'package:task_management/utilities/constants.dart';

class HomeUI extends StatefulWidget {
  const HomeUI({super.key});

  @override
  State<HomeUI> createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> {
  late Box<Task> todoBox;
  late Box<Task> inProgressBox;
  late Box<Task> completedBox;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _initHiveBoxes();
  }

  Future<void> _initHiveBoxes() async {
    setState(() {
      isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 500));

    todoBox = Hive.box<Task>(todoTaskBox);
    inProgressBox = Hive.box<Task>(inProgressTaskBox);
    completedBox = Hive.box<Task>(completedTaskBox);

    if (mounted) {
      final taskProvider = context.read<TaskProvider>();
      taskProvider.loadTasks();
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        tooltip: "Add new task",
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const CreateTaskScreen(),
            ),
          );
        },
        foregroundColor: Colors.white,
        backgroundColor: Colors.lightBlue,
        elevation: 1,
        child: const Icon(Icons.add),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: themeColor,
              ),
            )
          : SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 20.0.h, horizontal: 20.0.w),
                  child: Consumer<TaskProvider>(
                    builder: (context, taskProvider, child) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  formatDateShowWeekDay(DateTime.now()),
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14.sp,
                                  ),
                                ),
                                Text(
                                  formatDateShowDayAndMonth(DateTime.now()),
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Switch(
                                  activeColor: Colors.blueGrey,
                                  inactiveTrackColor: Colors.white,
                                  inactiveThumbColor: Colors.black,
                                  value:
                                      themeProvider.themeMode == ThemeMode.dark,
                                  onChanged: (value) {
                                    themeProvider.toggleTheme(value);
                                  },
                                ),
                                SizedBox(
                                  width: 8.w,
                                ),
                                Container(
                                  width: 40.w,
                                  height: 40.h,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.pink[100],
                                  ),
                                  child: Center(
                                    child: Text(
                                      '👤',
                                      style: TextStyle(fontSize: 20.sp),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),

                        // Tasks Header
                        Text(
                          'Hi, George',
                          style: TextStyle(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        // Information Architecture Card
                        SizedBox(height: 20.h),
                        _buildTotalTaskCountCard(taskProvider),

                        // Monthly Preview Section
                        SizedBox(height: 30.h),
                        Text(
                          'Task Categories',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20.h),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const TaskListUI(
                                  categoryIndex: 1,
                                ),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              Expanded(
                                child: _buildStatCard(
                                  taskProvider.numOfInProgressTask.toString(),
                                  categories[1],
                                  Colors.pink[300]!,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => const TaskListUI(
                                        categoryIndex: 0,
                                      ),
                                    ),
                                  );
                                },
                                child: _buildStatCard(
                                  taskProvider.numOfTodoTask.toString(),
                                  categories[0],
                                  Colors.orange[300]!,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => const TaskListUI(
                                        categoryIndex: 2,
                                      ),
                                    ),
                                  );
                                },
                                child: _buildStatCard(
                                  taskProvider.numOfCompletedTask.toString(),
                                  categories[2],
                                  Colors.greenAccent,
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Container _buildTotalTaskCountCard(TaskProvider taskProvider) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF7165E3),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                taskProvider.numOfAllTask.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'Total Tasks',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String number, String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 16.w),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            number,
            style: TextStyle(
              fontSize: 32.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}
