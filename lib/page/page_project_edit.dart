import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/model/project.dart';
import 'package:todo_app/state/project_state.dart';
import 'package:todo_app/utils/date.dart';

class PageProjectEdit extends StatefulWidget {
  final Project? _project;

  const PageProjectEdit(this._project, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PageTodoEditState();
  }
}

class _PageTodoEditState extends State<PageProjectEdit> {
  late TextEditingController _nameController;

  int? _created;
  int? _deadline;

  @override
  void initState() {
    super.initState();
    Project? originProject = widget._project;

    _nameController = TextEditingController(text: originProject?.name ?? "");
    _created = originProject?.created ?? DateTime.now().millisecondsSinceEpoch;
    _deadline = originProject?.deadline ?? 0;
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
        title: const Text("编辑项目"),
        actions: <Widget>[
          IconButton(
            onPressed: saveProject,
            icon: const Icon(
              Icons.check,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(8),
        child: ListView(
          children: [
            getNameRow(),
            const Divider(),
            getCreatedRow(),
            const Divider(),
            getDeadLineRow()
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

  Widget getDeadLineRow() {
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

  void saveProject() {
    ProjectState projectState =
        Provider.of<ProjectState>(context, listen: false);
    Project project = Project();
    if (widget._project != null) {
      // update
      project.id = widget._project!.id;
      project.name = _nameController.text;
      project.created = _created!;
      project.deadline = _deadline ?? 0;
      projectState.updateProject(project);
    } else {
      // create
      project.name = _nameController.text;
      project.created = _created!;
      project.deadline = _deadline ?? 0;
      projectState.createProject(project);
    }
    Navigator.pop(context);
  }
}
