import 'package:flutter/material.dart';
import '../util/dbhelper.dart';
import '../model/todo.dart';
import 'package:intl/intl.dart';

class TodoDetail extends StatefulWidget {

  final Todo todo;

  TodoDetail(this.todo);

  @override
  State createState() => TodoDetailState(this.todo);
}

class TodoDetailState extends State<TodoDetail> {
 
 Todo todo;
 TodoDetailState(this.todo);
 final _priorities = ["High","Medium","Low"];

 String _priority = "Low";
 
 // TextField controllers
 TextEditingController titleController = TextEditingController();
 TextEditingController descriptionController = TextEditingController();

  // Db Helper for interacting with our db
DbHelper helper = DbHelper();
// menu items
static const mnuSave = 'Save Todo & Back';
static const mnuDelete = 'Delete Todo';
static const mnuBack = 'Back to List';

// creating a list of menu options we want to display to the user
final List<String> choices = const <String> [
  'Save Todo & Back',
  'Delete Todo',
  'Back to List'
];
  @override
  Widget build(BuildContext context) {

    // if todo object contains data, we want to show it on the text field
    titleController.text = todo.title;
    descriptionController.text = todo.description;

    TextStyle textStyle = Theme.of(context).textTheme.title;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(todo.title),
        // adding popupmenubutton
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: select,
            itemBuilder: (BuildContext context) {
              return choices.map((String choice) {
                return PopupMenuItem<String> (
                  value: choice,
                  child: Text(choice),);
              }).toList();
            })
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 35.0, left: 10.0, right: 10.0),
        child: ListView(
          children: <Widget> [
        Column(
        children: <Widget> [
          // Text field for title
          TextField(
            controller: titleController,
            style: textStyle,
            onChanged: (value) => this.updateTitle(),
            decoration: InputDecoration(
              labelText: "Title",
              labelStyle: textStyle,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0), )
            ),
          ),

          //  Text field for description
          Padding(
          padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
          child: TextField(
            controller: descriptionController,
            style: textStyle,
            onChanged: (value) => this.updateDescription(),
            decoration: InputDecoration(
              labelText: "Description",
              labelStyle: textStyle,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0), )
            ),
          ),
          ),
          // Dropdown button for priority
          ListTile( title: DropdownButton<String>(
            items: _priorities.map((String value) {
              return DropdownMenuItem(
                value: value,
                child: Text(value),);
            }).toList(),
            style: textStyle,
            value: retrievePriority(todo.priority), 
            onChanged: (value) => updatePriority(value))
          )
        ]
      ),
          ]
        )
    ));
  }

  void select(String value) async {
    int result;

    switch(value) {
      case mnuSave:
        save();
      break;
      case mnuDelete:
        if (todo.id == null) {
          return;
        }
        result = await helper.deleteTodo(todo.id);
        Navigator.pop(context, true);
        if (result != 0) {
          AlertDialog alertDialog = AlertDialog(
            title: Text("Delete Todo"),
            content: Text("This todo has been deleted"),);
            showDialog(context: context,
            builder: (_) => alertDialog);
        }
        break;
        case mnuBack:
           Navigator.pop(context, true);
        break;
    }
  }

  // save a new or update task function
  void save() {
    // Format the date first using intl package
    todo.date = new DateFormat.yMd().format(DateTime.now());

    // update todo if  id exists
    if (todo.id != null) {
      helper.updateTodo(todo);
    } else {
      helper.insertTodo(todo);
    }
    // in any case, we will get back to the todolist screen
    Navigator.pop(context, true);
  }

void updatePriority(String value) {
  switch(value) {
    case "High":
      todo.priority = 1;
    break;
    case "Medium":
      todo.priority = 2;
    break;
    case "Low":
      todo.priority = 3;
    break;
  }

  setState(() {
    _priority = value;
  });
}

// method to retrieve the String of the priority when we have number
String retrievePriority(int value) {
  return _priorities[value - 1];
}

// method to update the title of todos
void updateTitle() {
  todo.title = titleController.text;
}

// method to update description
void updateDescription() {
  todo.description = descriptionController.text;
}

}