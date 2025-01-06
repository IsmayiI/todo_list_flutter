import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_list/domain/data_provider/box_manager.dart';
import 'package:todo_list/domain/entity/group.dart';
import 'package:todo_list/ui/navigation/route_names.dart';
import 'package:todo_list/ui/widgets/tasks/tasks_model.dart';

class GroupsModel extends ChangeNotifier {
  late final Future<Box<Group>> _box;
  ValueListenable<Object>? _listenableBox;
  var _groups = <Group>[];

  List<Group> get groups => _groups.toList();

  GroupsModel() {
    _setUp();
  }

  void openForm(BuildContext context) {
    Navigator.of(context).pushNamed(RouteNames.groupsForm);
  }

  Future<void> openTasks(BuildContext context, int index) async {
    final group = (await _box).getAt(index);
    if (group == null) return;
    final config = TasksConfiguration(group.key as int, group.name);

    Navigator.of(context).pushNamed(RouteNames.groupsTasks, arguments: config);
  }

  Future<void> deleteGroup(int index) async {
    final box = await _box;
    final groupKey = box.keyAt(index) as int;
    final taskBoxName = BoxManager.instance.makeTaskBoxName(groupKey);
    await Hive.deleteBoxFromDisk(taskBoxName);
    await box.deleteAt(index);
  }

  Future<void> _readGroupsFromHive() async {
    _groups = (await _box).values.toList();
    notifyListeners();
  }

  Future<void> _setUp() async {
    _box = BoxManager.instance.openGroupBox();
    await _readGroupsFromHive();
    _listenableBox = (await _box).listenable();
    _listenableBox?.addListener(_readGroupsFromHive);
  }
}

class GroupsModelProvider extends InheritedNotifier<GroupsModel> {
  final GroupsModel model;

  const GroupsModelProvider({
    super.key,
    required this.model,
    required super.child,
  }) : super(notifier: model);

  static GroupsModel? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<GroupsModelProvider>()
        ?.model;
  }

  static GroupsModel watch(BuildContext context) {
    final GroupsModel? result = maybeOf(context);
    assert(result != null, 'No GroupsModelProvider found in context');
    return result!;
  }

  static GroupsModel? read(BuildContext context) {
    final element =
        context.getElementForInheritedWidgetOfExactType<GroupsModelProvider>();
    return (element?.widget as GroupsModelProvider?)?.model;
  }
}
