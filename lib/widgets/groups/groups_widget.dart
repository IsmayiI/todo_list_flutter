import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_list/widgets/groups/groups_model.dart';

class GroupsWidget extends StatefulWidget {
  const GroupsWidget({super.key});

  @override
  State<GroupsWidget> createState() => _GroupsWidgetState();
}

class _GroupsWidgetState extends State<GroupsWidget> {
  final model = GroupsModel();
  @override
  Widget build(BuildContext context) {
    return GroupsModelProvider(model: model, child: const _GroupsBodyWidget());
  }
}

class _GroupsBodyWidget extends StatelessWidget {
  const _GroupsBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Группы'),
      ),
      body: const _GroupListWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => GroupsModelProvider.read(context)?.openForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _GroupListWidget extends StatelessWidget {
  const _GroupListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final groupsCount = GroupsModelProvider.watch(context).groups.length;
    return ListView.separated(
        itemCount: groupsCount,
        itemBuilder: (BuildContext context, int index) {
          return _GroupListRowWidget(
            index: index,
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(
            height: 1,
          );
        });
  }
}

class _GroupListRowWidget extends StatelessWidget {
  final int index;
  const _GroupListRowWidget({required this.index});

  @override
  Widget build(BuildContext context) {
    final model = GroupsModelProvider.read(context);
    final group = model!.groups[index];

    return Slidable(
      endActionPane: ActionPane(
        extentRatio: 0.3,
        motion: const BehindMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => model.deleteGroup(index),
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          )
        ],
      ),
      child: ListTile(
        title: Text(group.name),
        trailing: const Icon(Icons.chevron_right),
        onTap: null,
      ),
    );
  }
}
