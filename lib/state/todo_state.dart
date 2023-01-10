import 'package:flutter/cupertino.dart';
import 'package:todo_app/data/todo_manager.dart';
import 'package:todo_app/model/todo.dart';

class TodoState with ChangeNotifier {
  List<Todo> todoList = [];

  void createTodo(Todo todo) async {
    await TodoManager.createTodo(todo);
    todoList.add(todo);
    notifyListeners();
  }

  void updateTodo(Todo todo) async {
    await TodoManager.updateTodo(todo);
    int index = todoList.indexWhere((element) => element.id == todo.id);
    todoList[index] = todo;
    notifyListeners();
  }

  void getAllTodo() async {
    todoList = await TodoManager.getAllTodo();
    notifyListeners();
  }
}