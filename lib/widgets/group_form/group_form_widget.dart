import 'package:flutter/material.dart';
import 'package:todo_list/widgets/group_form/group_form_widget_model.dart';

class GroupFormWidget extends StatefulWidget {
  const GroupFormWidget({super.key});

  @override
  State<GroupFormWidget> createState() => _GroupFormWidgetState();
}

class _GroupFormWidgetState extends State<GroupFormWidget> {
  final _model = GroupFormWidgetModel();

  @override
  Widget build(BuildContext context) {
    return GroupFormWidgetModelProvider(
      model: _model,
      child: const _GroupFormBodyWidget(),
    );
  }
}

class _GroupFormBodyWidget extends StatelessWidget {
  const _GroupFormBodyWidget();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Новая группа'),
      ),
      body: Center(
        child: const Padding(
          padding: EdgeInsets.all(16),
          child: _GroupNameWidget(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => GroupFormWidgetModelProvider.read(context)
            ?.model
            .saveGroup(context),
        child: const Icon(Icons.done),
      ),
    );
  }
}

class _GroupNameWidget extends StatelessWidget {
  const _GroupNameWidget();

  @override
  Widget build(BuildContext context) {
    final model = GroupFormWidgetModelProvider.read(context)?.model;

    return TextField(
      onChanged: (value) => model?.groupName = value,
      autofocus: true,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Название группы',
      ),
    );
  }
}
