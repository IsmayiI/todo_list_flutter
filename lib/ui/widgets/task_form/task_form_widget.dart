import 'package:flutter/material.dart';
import 'package:todo_list/ui/widgets/task_form/task_form_model.dart';

class TaskFormWidget extends StatefulWidget {
  final int groupKey;
  const TaskFormWidget({super.key, required this.groupKey});

  @override
  State<TaskFormWidget> createState() => _TaskFormWidgetState();
}

class _TaskFormWidgetState extends State<TaskFormWidget> {
  late final TaskFormModel _model;

  @override
  void initState() {
    super.initState();
    _model = TaskFormModel(groupKey: widget.groupKey);
  }

  @override
  Widget build(BuildContext context) {
    return TaskFormModelProvider(
      model: _model,
      child: TaskFormModelProvider(
          model: _model, child: const _TaskFormBodyWidget()),
    );
  }
}

class _TaskFormBodyWidget extends StatelessWidget {
  const _TaskFormBodyWidget();

  @override
  Widget build(BuildContext context) {
    final model = TaskFormModelProvider.read(context)?.model;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Новая задача'),
      ),
      body: Center(
        child: const Padding(
          padding: EdgeInsets.all(16),
          child: _TaskTextWidget(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => model?.saveTask(context),
        child: const Icon(Icons.done),
      ),
    );
  }
}

class _TaskTextWidget extends StatelessWidget {
  const _TaskTextWidget();

  @override
  Widget build(BuildContext context) {
    final model = TaskFormModelProvider.read(context)?.model;

    return TextField(
      onChanged: (value) => model?.taskText = value,
      autofocus: true,
      maxLines: 10,
      minLines: 3,
      textInputAction: TextInputAction.newline,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Задача',
      ),
    );
  }
}
