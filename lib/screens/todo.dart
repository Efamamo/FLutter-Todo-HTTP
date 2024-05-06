import 'package:flutter/material.dart';
import 'add_page.dart';

class ToDoList extends StatefulWidget {
  const ToDoList({super.key});

  @override
  State<ToDoList> createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade700,
        centerTitle: true,
        title: const Text(
          'Todo List',
          style: TextStyle(color: Colors.white),
        ),
      ),
      floatingActionButton: CircleAvatar(
        child: FloatingActionButton(
          onPressed: navigate,
          child: const Text('Add'),
        ),
      ),
    );
  }

  void navigate() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return const AddTodoPage();
    }));
  }
}
