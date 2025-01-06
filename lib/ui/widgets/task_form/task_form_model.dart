import 'package:flutter/material.dart';
import 'package:todo_list/domain/data_provider/box_manager.dart';
import 'package:todo_list/domain/entity/task.dart';

class TaskFormModel {
  int groupKey;
  var taskText = '';

  TaskFormModel({required this.groupKey});

  void saveTask(BuildContext context) async {
    if (taskText.isEmpty) return;

    final task = Task(text: taskText);
    final box = await BoxManager.instance.openTaskBox(groupKey);
    await box.add(task);
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
