import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/component/todo_list_tile.dart';
import 'package:todo_app/model/project.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/page/page_project_edit.dart';
import 'package:todo_app/page/page_todo_edit.dart';
import 'package:todo_app/state/project_state.dart';
import 'package:todo_app/state/todo_state.dart';

class PageHome extends StatefulWidget {
  const PageHome({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PageHomeState();
  }
}

class _PageHomeState extends State<PageHome> {
  @override
  void initState() {
    super.initState();
    Provider.of<TodoState>(context, listen: false).getAllTodo();
    Provider.of<ProjectState>(context, listen: false).getAllProject();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo App"),
      ),
      drawer: getDrawer(),
      body: getTodoList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => const PageTodoEdit(null))),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget getDrawer() {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const DrawerHeader(
            child: Text("项目列表", style: TextStyle(fontSize: 24)),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          Expanded(
            child: getProjectList(),
          ),
          MaterialButton(
            child: const Text("创建项目"),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const PageProjectEdit(null))),
          )
        ],
      ),
    );
  }

  Widget getProjectList() {
    return Consumer<ProjectState>(
      builder: (context, projectState, widget) {
        List<Project> projectList = projectState.projectList;
        List<String> projectNames = List.generate(
            projectList.length, (index) => projectList[index].name);
        projectNames.insert(0, "所有");

        return ListView.builder(itemBuilder: (context, index) {
          bool selected = false;
          if (index < projectNames.length) {
            selected = projectState.selectedProjectName == projectNames[index];
          }
          return MaterialButton(
            onPressed: () => projectState.selectProject(projectNames[index]),
            onLongPress: () {
              if (index == 0) return;
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          PageProjectEdit(projectList[index - 1])));
            },
            child: Text(
              projectNames[index],
              style: TextStyle(color: selected ? Colors.blue : Colors.grey),
            ),
          );
        });
      },
    );
  }

  Widget getTodoList() {
    return Consumer2<TodoState, ProjectState>(
        builder: (context, todoState, projectState, widget) {
      List<Todo> todoList;
      String? filterProject = projectState.selectedProjectName;
      if (filterProject == null || filterProject.isEmpty) {
        todoList = todoState.todoList;
      } else if (filterProject == "所有") {
        todoList = todoState.todoList;
      } else {
        todoList = todoState.todoList
            .where((todo) =>
                projectState.findProjectById(todo.project_id)?.name ==
                filterProject)
            .toList();
      }

      return ListView.separated(
          itemBuilder: (context, index) {
            return TodoListTile(todoList[index]);
          },
          separatorBuilder: (context, index) => const Divider(),
          itemCount: todoList.length);
    });
  }
}
