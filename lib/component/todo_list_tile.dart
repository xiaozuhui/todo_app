import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/page/page_todo_edit.dart';
import 'package:todo_app/state/project_state.dart';
import 'package:todo_app/state/todo_state.dart';
import 'package:todo_app/utils/date.dart';

class TodoListTile extends StatelessWidget {
  final Todo _todo;
  const TodoListTile(this._todo, {Key? key}) : super(key: key);

  // toggleTodo 转换todo的状态
  void toggleTodo(BuildContext context) {
    Todo todo = Todo.copy(_todo);
    todo.finished =
        todo.finished == TODO_FINISHED ? TODO_UNFINISHED : TODO_FINISHED;
    Provider.of<TodoState>(context, listen: false).updateTodo(todo);
  }

  void onItemClick(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => PageTodoEdit(_todo)));
  }

  Widget getBadge(String text) {
    return Container(
      padding: const EdgeInsets.all(2),
      margin: const EdgeInsets.only(right: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        color: Colors.blue,
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  List<Widget> getSubtitle(BuildContext context) {
    return [
      if (_todo.project_id != null)
        getBadge(Provider.of<ProjectState>(context)
            .findProjectById(_todo.project_id)!
            .name),
      if (_todo.deadline! > 0)
        getBadge("截止: ${DateTool.fromMill(_todo.deadline!)}")
    ];
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> subTitle = getSubtitle(context);
    return ListTile(
      title: Text(
        _todo.name,
        style: const TextStyle(fontSize: 18),
      ),
      subtitle: subTitle.isNotEmpty ? Row(children: subTitle) : null,
      trailing: IconButton(
        icon: Icon(
          _todo.finished == TODO_FINISHED
              ? Icons.check_circle
              : Icons.check_circle_outline,
          color: _todo.finished == TODO_FINISHED ? Colors.green : Colors.grey,
        ),
        onPressed: () => toggleTodo(context),
      ),
      onTap: () => onItemClick(context),
    );
  }
}
