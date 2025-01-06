import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_list/domain/entity/group.dart';
import 'package:todo_list/domain/entity/task.dart';
import 'package:todo_list/ui/navigation/route_names.dart';

class TasksModel extends ChangeNotifier {
  int groupKey;
  late final Future<Box<Group>> _groupsBox;
  var _tasks = <Task>[];

  List<Task> get tasks => _tasks.toList();

  Group? _group;

  Group? get group => _group;

  TasksModel({required this.groupKey}) {
    _setUp();
  }

  void toggleTask(int index) async {
    final task = _group?.tasks?[index];
    final currentState = task?.isDone ?? false;
    task?.isDone = !currentState;
    await task?.save();
    notifyListeners();
  }

  void deleteTask(int index) async {
    await _group?.tasks?.deleteFromHive(index);
    await _group?.save();
  }

  void openForm(BuildContext context) {
    Navigator.of(context)
        .pushNamed(RouteNames.groupsTasksForm, arguments: groupKey);
  }

  void _readTasks() {
    _tasks = _group?.tasks ?? <Task>[];
    notifyListeners();
  }

  _setUpListenTasks() async {
    final box = await _groupsBox;
    _readTasks();
    box.listenable(keys: [groupKey]).addListener(() => _readTasks());
  }

  void _loadGroup() async {
    final box = await _groupsBox;
    _group = box.get(groupKey);
    notifyListeners();
  }

  void _setUp() {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(GroupAdapter());
    }
    _groupsBox = Hive.openBox<Group>('groups_box');
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(TaskAdapter());
    }
    Hive.openBox<Task>('tasks_box');
    _loadGroup();
    _setUpListenTasks();
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
