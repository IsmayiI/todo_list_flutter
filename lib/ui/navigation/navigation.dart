import 'package:flutter/material.dart';
import 'package:todo_list/ui/navigation/route_names.dart';
import 'package:todo_list/ui/widgets/group_form/group_form_widget.dart';
import 'package:todo_list/ui/widgets/groups/groups_widget.dart';
import 'package:todo_list/ui/widgets/task_form/task_form_widget.dart';
import 'package:todo_list/ui/widgets/tasks/tasks_model.dart';
import 'package:todo_list/ui/widgets/tasks/tasks_widget.dart';

abstract class Navigation {
  static final initialRoute = RouteNames.groups;

  static final routes = <String, Widget Function(BuildContext)>{
    RouteNames.groups: (_) => const GroupsWidget(),
    RouteNames.groupsForm: (_) => const GroupFormWidget(),
  };

  static Route<Object> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.groupsTasks:
        final config = settings.arguments as TasksConfiguration;
        return MaterialPageRoute(
          builder: (_) => TasksWidget(config: config),
        );

      case RouteNames.groupsTasksForm:
        final groupKey = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => TaskFormWidget(groupKey: groupKey),
        );

      default:
        return MaterialPageRoute(builder: (_) => const Text('404'));
    }
  }
}
