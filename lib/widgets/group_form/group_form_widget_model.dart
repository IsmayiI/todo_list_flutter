import 'package:flutter/material.dart';

class GroupFormWidgetModel {
  var groupName = '';
  void saveGroup(BuildContext context) {}
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
  bool updateShouldNotify(GroupFormWidgetModelProvider oldWidget) =>
      model != oldWidget.model;
}
