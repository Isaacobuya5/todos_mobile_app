import 'package:flutter/material.dart';
import '../model/todo.dart';
import '../util/dbhelper.dart';
import './tododetail.dart';

class TodoList extends StatefulWidget {
  @override
  State createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  // initialize the db helper class
  DbHelper helper = DbHelper();
  //initialize an empty todo list
  List<Todo> todos;
  // initial count of records
   int count = 0;
  @override
  Widget build(BuildContext context) {
    // retrieve data with dbhelper
    if (todos == null) {
      todos = List<Todo>();
      // retrieve todos from db
      getData();
     
    }
    return Scaffold(
      body: todoListItems(),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add a New Todo",
        onPressed: (){
        navigateToDetail(Todo('', 3, ''));
        }),
    );
  }

  // method to retrieve todos
  void getData() {
    final dbConnection = helper.initializeDb();
    dbConnection.then((result) {
      // if connection succesful then retrieve available todos
      final availableTodos = helper.getTodos();
      //availableTodos is an asynchronous task thus wait then update state of the component
      availableTodos.then((result) {
        print("available todos" + result.toString());
        // initialize an empty list
        List<Todo> todoList = List<Todo>();
        // get the number of rows
        count = result.length;
         print("Items " + count.toString());
        for(int i = 0; i < count; i++) {
          todoList.add(Todo.fromObject(result[i]));
          // test if things are working fine
          print(todoList[i].title);
        }
        // finally updating the state
        setState(() {
          todos = todoList;
          count = count;
        });
      });
    });
  
  }

  // display todo items
  ListView todoListItems() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: getColor(this.todos[position].priority),
              child: Text(this.todos[position].priority.toString()),
            ),
            title: Text(this.todos[position].title),
            subtitle: Text(this.todos[position].date),
            onTap: () {
              print("Tapped " + this.todos[position].id.toString());
              navigateToDetail(this.todos[position]);
            },
          )
        );
      });
  }

  // displaying different colors based on the priority
  Color getColor(int priority) {
    switch(priority) {
      case 1:
        return Colors.red;
      break;
      case 2:
        return Colors.orange;
      break;
      case 3:
        return Colors.green;
      break;
      default:
         return Colors.green;
    }
  }

  // the user can navigator to the todo detail page when he performs two actions
  // a. presses on an individual todo item from the todo list
  // b. click on the floating action button to add a new todo
  void navigateToDetail(Todo todo) async{
     bool result = await Navigator.push(context, MaterialPageRoute(
       builder: (context) => TodoDetail(todo)));

  }
}