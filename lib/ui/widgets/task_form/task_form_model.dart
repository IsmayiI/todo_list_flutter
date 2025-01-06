import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_list/domain/entity/group.dart';
import 'package:todo_list/domain/entity/task.dart';

class TaskFormModel {
  int groupKey;
  var taskText = '';

  TaskFormModel({required this.groupKey});

  void saveTask(BuildContext context) async {
    if (taskText.isEmpty) return;

    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(TaskAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(GroupAdapter());
    }
    final taskBox = await Hive.openBox<Task>('tasks_box');
    final task = Task(text: taskText);
    await taskBox.add(task);

    final groupBox = await Hive.openBox<Group>('groups_box');
    final group = groupBox.get(groupKey);
    group?.addTask(taskBox, task);

    Navigator.of(context).pop();
  }
}

class TaskFormModelProvider extends InheritedWidget {
  const TaskFormModelProvider({
    super.key,
    required this.model,
    required super.child,
  });

  final TaskFormModel model;

  static TaskFormModelProvider? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TaskFormModelProvider>();
  }

  static TaskFormModelProvider watch(BuildContext context) {
    final TaskFormModelProvider? result = maybeOf(context);
    assert(result != null, 'No TaskFormModelProvider found in context');
    return result!;
  }

  static TaskFormModelProvider? read(BuildContext context) {
    final element = context
        .getElementForInheritedWidgetOfExactType<TaskFormModelProvider>();
    return (element?.widget as TaskFormModelProvider?);
  }

  @override
  bool updateShouldNotify(TaskFormModelProvider oldWidget) => false;
}
