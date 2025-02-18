import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_list/ui/widgets/tasks/tasks_model.dart';

class TasksWidget extends StatefulWidget {
  final TasksConfiguration config;
  const TasksWidget({super.key, required this.config});

  @override
  State<TasksWidget> createState() => _TasksWidgetState();
}

class _TasksWidgetState extends State<TasksWidget> {
  late final TasksModel _model;

  @override
  void initState() {
    super.initState();
    _model = TasksModel(config: widget.config);
  }

  @override
  Widget build(BuildContext context) {
    return TasksModelProvider(
      model: _model,
      child: const _TasksBodyWidget(),
    );
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }
}

class _TasksBodyWidget extends StatelessWidget {
  const _TasksBodyWidget();

  @override
  Widget build(BuildContext context) {
    final model = TasksModelProvider.watch(context);
    final title = model.config.title;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: const _TaskListWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => model.openForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _TaskListWidget extends StatelessWidget {
  const _TaskListWidget();

  @override
  Widget build(BuildContext context) {
    final tasksCount = TasksModelProvider.watch(context).tasks.length;

    return ListView.separated(
        itemCount: tasksCount,
        itemBuilder: (BuildContext context, int index) {
          return _TaskListRowWidget(
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

class _TaskListRowWidget extends StatelessWidget {
  final int index;
  const _TaskListRowWidget({required this.index});

  @override
  Widget build(BuildContext context) {
    final model = TasksModelProvider.read(context)!;
    final task = model.tasks[index];

    final icon = task.isDone ? Icons.task_alt : Icons.radio_button_unchecked;
    final textStyle = task.isDone
        ? const TextStyle(decoration: TextDecoration.lineThrough)
        : null;

    return Slidable(
      endActionPane: ActionPane(
        extentRatio: 0.3,
        motion: const BehindMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => model.deleteTask(index),
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          )
        ],
      ),
      child: ListTile(
        title: Text(task.text, style: textStyle),
        trailing: Icon(icon),
        onTap: () => model.toggleTask(index),
      ),
    );
  }
}
