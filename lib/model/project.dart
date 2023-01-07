const TABLE_NAME_PROJECT = "project";
const COLUMN_PROJECT_ID = "id";
const COLUMN_PROJECT_NAME = "name";
const COLUMN_PROJECT_CREATED = "created";
const COLUMN_PROJECT_DEADLINE = "deadline";

const TABLE_CREATE_SQL_PROJECT = """
create table $TABLE_NAME_PROJECT(
    $COLUMN_PROJECT_ID integer primary key,
    $COLUMN_PROJECT_NAME text,
    $COLUMN_PROJECT_CREATED integer,
    $COLUMN_PROJECT_DEADLINE integer);
""";

class Project {
  late int id;
  late String name;
  late int created;
  late int deadline;

  Project();

  Project.fromMap(Map<String, dynamic> map) {
    id = map[COLUMN_PROJECT_ID];
    name = map[COLUMN_PROJECT_NAME];
    created = map[COLUMN_PROJECT_CREATED];
    deadline = map[COLUMN_PROJECT_DEADLINE];
  }

  Map<String, dynamic> toMap() {
    return {
      COLUMN_PROJECT_ID: id,
      COLUMN_PROJECT_NAME: name,
      COLUMN_PROJECT_CREATED: created,
      COLUMN_PROJECT_DEADLINE: deadline
    };
  }
}