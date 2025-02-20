import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:task_management/models/task.dart';
import 'package:task_management/provider/task_provider.dart';
import 'package:task_management/screens/add_task_screen.dart';
import 'package:task_management/utilities/constants.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:task_management/widgets/task_card_widget.dart';

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
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) => SafeArea(
          child: categoryIndex == 0 && taskProvider.numOfTodoTask == 0
              ? _buildEmptyTasList(categories[0], context, categoryIndex)
              : categoryIndex == 1 && taskProvider.numOfInProgressTask == 0
                  ? _buildEmptyTasList(categories[1], context, categoryIndex)
                  : categoryIndex == 2 && taskProvider.numOfCompletedTask == 0
                      ? _buildEmptyTasList(
                          categories[2], context, categoryIndex)
                      : Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 16.h,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    icon:
                                        Icon(Icons.arrow_back_ios, size: 20.sp),
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
                                          : taskProvider.numOfCompletedTask,
                                  separatorBuilder: (context, index) =>
                                      SizedBox(height: 12.h),
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                CreateTaskScreen(
                                              task: categoryIndex == 0
                                                  ? taskProvider
                                                      .allToDoTasks[index]
                                                  : categoryIndex == 1
                                                      ? taskProvider
                                                              .allInProgressTasks[
                                                          index]
                                                      : taskProvider
                                                              .allCompletedTasks[
                                                          index],
                                              taskIndex: index,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Slidable(
                                        key: const Key('item_key'),
                                        endActionPane: ActionPane(
                                          motion: const ScrollMotion(),
                                          children: [
                                            SlidableAction(
                                              onPressed:
                                                  (BuildContext context) {
                                                categoryIndex == 0
                                                    ? taskProvider
                                                        .deleteTodoTask(index)
                                                    : categoryIndex == 1
                                                        ? taskProvider
                                                            .deleteInProgressTask(
                                                                index)
                                                        : taskProvider
                                                            .deleteCompletedTask(
                                                                index);
                                              },
                                              backgroundColor: Colors.red,
                                              icon: Icons.delete,
                                              label: 'Delete',
                                            ),
                                          ],
                                        ),
                                        child: TaskCard(
                                          task: categoryIndex == 0
                                              ? taskProvider.allToDoTasks[index]
                                              : categoryIndex == 1
                                                  ? taskProvider
                                                      .allInProgressTasks[index]
                                                  : taskProvider
                                                      .allCompletedTasks[index],
                                        ),
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

Widget _buildEmptyTasList(
  String category,
  BuildContext context,
  int categoryIndex,
) {
  return Padding(
    padding: EdgeInsets.symmetric(
      horizontal: 16.w,
      vertical: 16.h,
    ),
    child: Column(
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
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.list_alt_outlined,
                size: 80.w,
                color: Colors.grey,
              ),
              SizedBox(height: 16.h),
              Text(
                '$category task is empty',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
