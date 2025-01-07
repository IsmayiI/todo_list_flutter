import 'package:flutter/material.dart';
import 'package:todo_list/domain/data_provider/box_manager.dart';
import 'package:todo_list/domain/entity/task.dart';

class TaskFormModel extends ChangeNotifier {
  int groupKey;
  var _taskText = '';
  String? errorText;

  set taskText(String value) {
    if (errorText != null && value.trim().isNotEmpty) {
      errorText = null;
      notifyListeners();
    }
    _taskText = value;
  }

  TaskFormModel({required this.groupKey});

  void saveTask(BuildContext context) async {
    final taskText = _taskText.trim();
    if (taskText.isEmpty) {
      errorText = 'Введите задачу';
      notifyListeners();
      return;
    }

    final task = Task(text: taskText);
    final box = await BoxManager.instance.openTaskBox(groupKey);
    await box.add(task);
    Navigator.of(context).pop();
  }
}

class TaskFormModelProvider extends InheritedNotifier<TaskFormModel> {
  final TaskFormModel model;

  const TaskFormModelProvider({
    super.key,
    required this.model,
    required super.child,
  }) : super(notifier: model);

  static TaskFormModel? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<TaskFormModelProvider>()
        ?.model;
  }

  static TaskFormModel watch(BuildContext context) {
    final TaskFormModel? result = maybeOf(context);
    assert(result != null, 'No TaskFormModelProvider found in context');
    return result!;
  }

  static TaskFormModel? read(BuildContext context) {
    final element = context
        .getElementForInheritedWidgetOfExactType<TaskFormModelProvider>();
    return (element?.widget as TaskFormModelProvider?)?.model;
  }
}
