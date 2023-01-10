import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/page/page_home.dart';
import 'package:todo_app/state/project_state.dart';
import 'package:todo_app/state/todo_state.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => ProjectState()),
      ChangeNotifierProvider(create: (context) => TodoState()),
    ],
    child: const SampleApp(),
  ));
}

class SampleApp extends StatelessWidget {
  // This widget is the root of your application.
  const SampleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Todo App',
      home: PageHome(),
    );
  }
}
