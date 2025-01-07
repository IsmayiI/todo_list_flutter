import 'package:flutter/material.dart';
import 'package:todo_list/domain/data_provider/box_manager.dart';
import 'package:todo_list/domain/entity/group.dart';

class GroupFormWidgetModel extends ChangeNotifier {
  var _groupName = '';
  String? errorText;

  set groupName(String value) {
    if (errorText != null && value.trim().isNotEmpty) {
      errorText = null;
      notifyListeners();
    }
    _groupName = value;
  }

  void saveGroup(BuildContext context) async {
    final groupName = _groupName.trim();
    if (groupName.isEmpty) {
      errorText = 'Введите название группы';
      notifyListeners();
      return;
    }

    final group = Group(name: groupName);
    final box = await BoxManager.instance.openGroupBox();
    await box.add(group);
    Navigator.of(context).pop();
  }
}

class GroupFormWidgetModelProvider
    extends InheritedNotifier<GroupFormWidgetModel> {
  final GroupFormWidgetModel model;

  const GroupFormWidgetModelProvider({
    super.key,
    required this.model,
    required super.child,
  }) : super(notifier: model);

  static GroupFormWidgetModel? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<GroupFormWidgetModelProvider>()
        ?.model;
  }

  static GroupFormWidgetModel watch(BuildContext context) {
    final GroupFormWidgetModel? result = maybeOf(context);
    assert(result != null, 'No GroupFormWidgetModelProvider found in context');
    return result!;
  }

  static GroupFormWidgetModel? read(BuildContext context) {
    final element = context.getElementForInheritedWidgetOfExactType<
        GroupFormWidgetModelProvider>();
    return (element?.widget as GroupFormWidgetModelProvider?)?.model;
  }
}
