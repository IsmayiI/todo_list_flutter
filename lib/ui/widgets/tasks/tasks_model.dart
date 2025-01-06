import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_list/domain/data_provider/box_manager.dart';
import 'package:todo_list/domain/entity/task.dart';
import 'package:todo_list/ui/navigation/route_names.dart';

class TasksModel extends ChangeNotifier {
  TasksConfiguration config;
  late final Future<Box<Task>> _box;
  var _tasks = <Task>[];

  List<Task> get tasks => _tasks.toList();

  TasksModel({required this.config}) {
    _setUp();
  }

  void openForm(BuildContext context) {
    Navigator.of(context)
        .pushNamed(RouteNames.groupsTasksForm, arguments: config.groupKey);
  }

  Future<void> toggleTask(int index) async {
    final task = (await _box).getAt(index);
    task?.isDone = !task.isDone;
    task?.save();
  }

  Future<void> deleteTask(int index) async {
    await (await _box).deleteAt(index);
  }

  Future<void> _readTasksFromHive() async {
    _tasks = (await _box).values.toList();
    notifyListeners();
  }

  Future<void> _setUp() async {
    _box = BoxManager.instance.openTaskBox(config.groupKey);
    await _readTasksFromHive();
    (await _box).listenable().addListener(_readTasksFromHive);
  }
}

class TasksModelProvider extends InheritedNotifier<TasksModel> {
  final TasksModel model;

  const TasksModelProvider({
    super.key,
    required this.model,
    required super.child,
  }) : super(notifier: model);

  static TasksModel? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<TasksModelProvider>()
        ?.model;
  }

  static TasksModel watch(BuildContext context) {
    final TasksModel? result = maybeOf(context);
    assert(result != null, 'No TasksModelProvider found in context');
    return result!;
  }

  static TasksModel? read(BuildContext context) {
    final element =
        context.getElementForInheritedWidgetOfExactType<TasksModelProvider>();
    return (element?.widget as TasksModelProvider?)?.model;
  }
}

class TasksConfiguration {
  final int groupKey;
  final String title;

  TasksConfiguration(this.groupKey, this.title);
}
