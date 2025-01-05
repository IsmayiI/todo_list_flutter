import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_list/domain/entity/group.dart';

class GroupFormWidgetModel {
  var groupName = '';

  void saveGroup(BuildContext context) async {
    if (groupName.isEmpty) return;
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(GroupAdapter());
    }
    var box = await Hive.openBox<Group>('groups_box');
    final group = Group(name: groupName);
    await box.add(group);
    Navigator.of(context).pop();
  }
}

class GroupFormWidgetModelProvider extends InheritedWidget {
  const GroupFormWidgetModelProvider({
    super.key,
    required this.model,
    required super.child,
  });

  final GroupFormWidgetModel model;

  static GroupFormWidgetModelProvider? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<GroupFormWidgetModelProvider>();
  }

  static GroupFormWidgetModelProvider watch(BuildContext context) {
    final GroupFormWidgetModelProvider? result = maybeOf(context);
    assert(result != null, 'No GroupFormWidgetModelProvider found in context');
    return result!;
  }

  static GroupFormWidgetModelProvider? read(BuildContext context) {
    final element = context.getElementForInheritedWidgetOfExactType<
        GroupFormWidgetModelProvider>();
    return (element?.widget as GroupFormWidgetModelProvider?);
  }

  @override
  bool updateShouldNotify(GroupFormWidgetModelProvider oldWidget) => false;
}
