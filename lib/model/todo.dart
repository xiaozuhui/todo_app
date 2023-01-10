
const TABLE_NAME_TODO = "todo";
const COLUMN_TODO_ID = "id";
const COLUMN_TODO_NAME = "name";
const COLUMN_TODO_PROJECT_ID = "project_id";
const COLUMN_TODO_CREATED = "created";
const COLUMN_TODO_DEADLINE = "deadline";
const COLUMN_TODO_FINISHED = "finished";

const TABLE_CREATE_SQL_TODO = """
create table $TABLE_NAME_TODO(
  $COLUMN_TODO_ID integer primary key,
  $COLUMN_TODO_NAME text,
  $COLUMN_TODO_PROJECT_ID integer,
  $COLUMN_TODO_CREATED integer,
  $COLUMN_TODO_DEADLINE integer,
  $COLUMN_TODO_FINISHED integer
);
""";

const TODO_FINISHED = 1;
const TODO_UNFINISHED = 0;

class Todo {
  late int id;
  late String name;
  late int? project_id;
  late int created;
  late int? deadline;
  late int finished;

  Todo();

  Todo.fromMap(Map<String, dynamic> map) {
    id = map[COLUMN_TODO_ID];
    name = map[COLUMN_TODO_NAME];
    project_id = map[COLUMN_TODO_PROJECT_ID];
    created = map[COLUMN_TODO_CREATED];
    deadline = map[COLUMN_TODO_DEADLINE] ?? 0;
    finished = map[COLUMN_TODO_FINISHED] ?? TODO_UNFINISHED;
  }

  Todo.copy(Todo todo) {
    id = todo.id;
    name = todo.name;
    project_id = todo.project_id;
    created = todo.created;
    deadline = todo.deadline;
    finished = todo.finished;
  }

  Map<String, dynamic> toMap() {
    return {
      COLUMN_TODO_ID: id,
      COLUMN_TODO_NAME: name,
      COLUMN_TODO_PROJECT_ID: project_id,
      COLUMN_TODO_CREATED: created,
      COLUMN_TODO_DEADLINE: deadline,
      COLUMN_TODO_FINISHED: finished
    };
  }
}
