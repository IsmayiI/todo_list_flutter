import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_list/domain/entity/group.dart';

class GroupsModel extends ChangeNotifier {
  var _groups = <Group>[];

  List<Group> get groups => _groups.toList();

  GroupsModel() {
    _setUp();
  }

  void openForm(BuildContext context) {
    Navigator.of(context).pushNamed('/groups/form');
  }

  void deleteGroup(int index) async {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(GroupAdapter());
    }
    var box = await Hive.openBox<Group>('groups_box');
    await box.deleteAt(index);
  }

  void _readGroupsFromHive(Box<Group> box) {
    _groups = box.values.toList();
    notifyListeners();
  }

  void _setUp() async {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(GroupAdapter());
    }
    var box = await Hive.openBox<Group>('groups_box');
    _readGroupsFromHive(box);
    box.listenable().addListener(() => _readGroupsFromHive(box));
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
