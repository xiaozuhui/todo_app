import 'package:flutter/cupertino.dart';
import 'package:todo_app/data/project_manager.dart';
import 'package:todo_app/model/project.dart';

class ProjectState with ChangeNotifier {
  List<Project> projectList = [];

  String? selectedProjectName;

  void selectProject(String projectName) {
    selectedProjectName = projectName;
    notifyListeners();
  }

  Project? findProjectById(int? projectId) {
    for (Project p in projectList) {
      if (p.id == projectId) {
        return p;
      }
    }
    return null;
  }

  void updateProject(Project project) async {
    await ProjectManager.updateProject(project);

    int index = projectList.indexWhere((element) => element.id == project.id);

    if (projectList[index].name == selectedProjectName) {
      selectedProjectName = project.name;
    }

    projectList[index] = project;
    notifyListeners();
  }

  void createProject(Project project) async {
    await ProjectManager.createProject(project);
    projectList.add(project);
    notifyListeners();
  }

  void getAllProject() async {
    projectList = await ProjectManager.getAllProject();
    notifyListeners();
  }
}
