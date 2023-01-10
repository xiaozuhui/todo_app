import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/model/project.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/state/project_state.dart';
import 'package:todo_app/state/todo_state.dart';
import 'package:todo_app/utils/date.dart';

class PageTodoEdit extends StatefulWidget {
  final Todo? _todo;

  const PageTodoEdit(this._todo, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PageTodoEditState();
  }
}

class _PageTodoEditState extends State<PageTodoEdit> {
  late TextEditingController _nameController;

  Project? _project;
  int? _created;
  int? _deadline;
  int? _finished;

  @override
  void initState() {
    super.initState();
    Todo? originTodo = widget._todo;

    _nameController = TextEditingController(
      text: originTodo?.name,
    );
    _created = originTodo?.created ?? DateTime.now().millisecondsSinceEpoch;
    _deadline = originTodo?.deadline ?? 0;
    _finished = originTodo?.finished;
    _project = (originTodo ??
        Provider.of<ProjectState>(context, listen: false)
            .findProjectById(originTodo!.project_id)) as Project?;
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("编辑代办事项"),
        actions: <Widget>[
          IconButton(
              onPressed: saveTodo,
              icon: const Icon(
                Icons.check,
                color: Colors.white,
              ))
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(8),
        child: ListView(
          children: [
            getNameRow(),
            const Divider(),
            getProjectRow(),
            const Divider(),
            getCreatedRow(),
            const Divider(),
            getDeadlineRow(),
            const Divider(),
            getFinishedRow(),
          ],
        ),
      ),
    );
  }

  Widget getNameRow() {
    return Row(
      children: <Widget>[
        const Text(
          "名称:",
        ),
        Expanded(
            child: TextField(
          controller: _nameController,
        ))
      ],
    );
  }

  Widget getProjectRow() {
    return Row(
      children: <Widget>[
        const Text("项目:"),
        Expanded(
          child: Text(_project?.name ?? "无"),
        ),
        OutlinedButton(
          onPressed: () => showProjectDialog().then((project) {
            if (project == null) return;
            setState(() {
              _project = project;
            });
          }),
          child: const Text("选择"),
        ),
      ],
    );
  }

  Widget getCreatedRow() {
    return Row(
      children: <Widget>[
        const Text("创建时间:"),
        Expanded(
          child: Text(DateTool.fromMill(_created!)),
        ),
        OutlinedButton(
            onPressed: () async {
              DateTime dt = DateTime.fromMicrosecondsSinceEpoch(_created!);
              var result = await showDatePicker(
                  context: context,
                  initialDate: dt,
                  firstDate: dt.add(const Duration(days: -365)),
                  lastDate: dt.add(const Duration(days: 365)));
              if (result != null) {
                setState(() {
                  _created = result.millisecondsSinceEpoch;
                });
              }
            },
            child: const Text("更改"))
      ],
    );
  }

  Widget getDeadlineRow() {
    return Row(
      children: <Widget>[
        const Text("截止时间:"),
        Expanded(
          child: Text(_deadline! > 0 ? DateTool.fromMill(_deadline!) : "无"),
        ),
        OutlinedButton(
          onPressed: () async {
            DateTime dt = _deadline! > 0
                ? DateTime.fromMillisecondsSinceEpoch(_deadline!)
                : DateTime.now();
            var result = await showDatePicker(
              context: context,
              initialDate: dt,
              firstDate: dt.add(const Duration(days: -365)),
              lastDate: dt.add(const Duration(days: 365)),
            );
            if (result != null) {
              setState(() {
                _deadline = result.millisecondsSinceEpoch;
              });
            }
          },
          child: const Text("更新"),
        )
      ],
    );
  }

  Widget getFinishedRow() {
    return Row(
      children: <Widget>[
        const Text("完成状态:"),
        IconButton(
          onPressed: () => setState(() {
            _finished =
                _finished == TODO_FINISHED ? TODO_UNFINISHED : TODO_FINISHED;
          }),
          icon: Icon(
            _finished == TODO_FINISHED
                ? Icons.check_circle
                : Icons.check_circle_outline,
            color: _finished == TODO_FINISHED ? Colors.green : Colors.grey,
          ),
        )
      ],
    );
  }

  void saveTodo() {
    TodoState todoState = Provider.of<TodoState>(context, listen: false);
    Todo todo = Todo();
    if (widget._todo != null) {
      todo.id = widget._todo!.id;
      todo.name = _nameController.text;
      todo.created = _created!;
      todo.deadline = _deadline ?? 0;
      todo.finished = _finished!;
      todo.project_id = _project?.id;
      todoState.updateTodo(todo);
    } else {
      todo.name = _nameController.text;
      todo.created = _created!;
      todo.deadline = _deadline;
      todo.project_id = _project?.id;
      todoState.createTodo(todo);
    }
    Navigator.pop(context);
  }

  Future<Project> showProjectDialog() async {
    List<Project> projectList =
        Provider.of<ProjectState>(context, listen: false).projectList;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("所属项目: "),
            content: SizedBox(
              width: double.minPositive,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(projectList[index].name),
                    onTap: () => Navigator.pop(context, projectList[index]),
                  );
                },
                shrinkWrap: true,
                itemCount: projectList.length,
              ),
            ),
          );
        }) as Future<Project>;
  }
}
