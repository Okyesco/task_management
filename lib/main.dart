import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:task_management/models/task.dart';
import 'package:task_management/models/time_of_day_adapter.dart';
import 'package:task_management/provider/task_provider.dart';
import 'package:task_management/provider/theme_provider.dart';
import 'package:task_management/screens/home_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:task_management/utilities/constants.dart';
import 'package:task_management/utilities/theme_data.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  await Hive.initFlutter();
  Hive.registerAdapter(TimeOfDayAdapter());
  Hive.registerAdapter(TaskAdapter());

  await Hive.openBox<Task>(todoTaskBox);
  await Hive.openBox<Task>(inProgressTaskBox);
  await Hive.openBox<Task>(doneTaskBox);
  await Hive.openBox(themeBox);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<TaskProvider>(
          create: (context) => TaskProvider(),
        ),
        ChangeNotifierProvider<ThemeProvider>(
          create: (context) => ThemeProvider(),
        ),
      ],
      child: const MainUI(),
    ),
  );
}

class MainUI extends StatelessWidget {
  const MainUI({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          theme: lightThemeData,
          darkTheme: darkThemeData,
          themeMode: context.watch<ThemeProvider>().themeMode,
          home: const HomeUI(),
        );
      },
    );
  }
}
