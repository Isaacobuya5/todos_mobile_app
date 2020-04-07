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
      ),
      body: Column(
        children: <Widget> [
          // Text field for title
          TextField(
            controller: titleController,
            style: textStyle,
            decoration: InputDecoration(
              labelText: "Title",
              labelStyle: textStyle,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0), )
            ),
          ),

          //  Text field for description
          TextField(
            controller: descriptionController,
            style: textStyle,
            decoration: InputDecoration(
              labelText: "Description",
              labelStyle: textStyle,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0), )
            ),
          ),

          // Dropdown button for priority
          DropdownButton<String>(
            items: _priorities.map((String value) {
              return DropdownMenuItem(
                value: value,
                child: Text(value),);
            }).toList(),
            style: textStyle,
            value: _priority, 
            onChanged: null)
        ]
      ),
    );
  }
}