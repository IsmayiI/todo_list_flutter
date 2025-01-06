import 'package:flutter/material.dart';
import 'package:todo_list/ui/navigation/route_names.dart';
import 'package:todo_list/ui/widgets/group_form/group_form_widget.dart';
import 'package:todo_list/ui/widgets/groups/groups_widget.dart';
import 'package:todo_list/ui/widgets/task_form/task_form_widget.dart';
import 'package:todo_list/ui/widgets/tasks/tasks_widget.dart';

abstract class Navigation {
  static final initialRoute = RouteNames.groups;

  static final routes = <String, Widget Function(BuildContext)>{
    RouteNames.groups: (context) => const GroupsWidget(),
    RouteNames.groupsForm: (context) => const GroupFormWidget(),
    RouteNames.groupsTasks: (context) => const TasksWidget(),
    RouteNames.groupsTasksForm: (context) => const TaskFormWidget(),
  };
}
