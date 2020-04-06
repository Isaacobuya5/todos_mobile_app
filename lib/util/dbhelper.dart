import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../model/todo.dart';

class DbHelper {
  // private instance of this class
  static final DbHelper _dbHelper = DbHelper._internal();

// constants for model columns
String tblTodo = "todo";
String colId = "id";
String colTitle = "title";
String colDescription = "description";
String colPriority = "priority";
String colDate = "date";
// constructor for this class
  DbHelper._internal();

  static Database _db;

  Future<Database> get db async {
    if (_db == null) {
      _db = await initializeDb();
    }
    return _db;
  }

  // factory that return the instance of this class
  factory DbHelper() {
    return _dbHelper;
  }

  // method that will create/open database
  Future<Database> initializeDb() async {
    // use path provider to locate a suitable path for this database
   Directory dir = await getApplicationDocumentsDirectory();
    // store the database in the located path
    // String path = dir.path + "todos.db";
      String path = join(dir.path, "todos.db");
    // create variable that creates database in that path
    var dbTodos = await openDatabase(path,version: 1,onCreate: _createDb);
    return dbTodos;
  }

  // method to create the database
  void _createDb(Database db, int newVersion) async {
await db.execute(
  "CREATE TABLE $tblTodo($colId INTEGER PRIMARY KEY, $colTitle TEXT, $colDescription TEXT, $colPriority INTEGER, $colDate TEXT)"
);
  }

  // method for adding a new todo
  Future<int> insertTodo(Todo todo) async {
    Database db = await this.db;
    var result = await db.insert(
      tblTodo, 
      todo.toMap());
      return result;
  }

  // method to return all todos
  Future<List> getTodos() async {
    Database db = await this.db;
    var result = await db.rawQuery(
      "SELECT * FROM $tblTodo order by $colPriority ASC"
    );
    return result;
  }

  // method to return number of records in our table
  Future<int> getCount() async {
    Database db = await this.db;
    var result = Sqflite.firstIntValue(
      await db.rawQuery(
        "SELECT count (*) from $tblTodo"
      )
    );
    return result;
  }

  // method to update a todo
  Future<int> updateTodo(Todo todo) async {
    var db = await this.db;
    var result = await db.update(tblTodo, todo.toMap(),
    where: "$colId = ?", whereArgs: [todo.id]);
    return result;
  }

  // method to delete a todo
  Future<int> deleteTodo(int id) async {
    int result;
    var db = await this.db;
    result = await db.rawDelete("DELETE FROM $tblTodo WHERE $colId = $id");
    return result;
  }
}