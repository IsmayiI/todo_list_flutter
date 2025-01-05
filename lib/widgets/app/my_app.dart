import 'package:flutter/material.dart';
import 'package:todo_list/widgets/group_form/group_form_widget.dart';
import 'package:todo_list/widgets/groups/groups_widget.dart';
import 'package:todo_list/widgets/task_form/task_form_widget.dart';
import 'package:todo_list/widgets/tasks/tasks_widget.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme:
            AppBarTheme(backgroundColor: Colors.blue, centerTitle: true),
        useMaterial3: false,
      ),
      routes: {
        '/groups': (context) => const GroupsWidget(),
        '/groups/form': (context) => const GroupFormWidget(),
        '/groups/tasks': (context) => const TasksWidget(),
        '/groups/tasks/form': (context) => const TaskFormWidget(),
      },
      initialRoute: '/groups',
    );
  }
}
