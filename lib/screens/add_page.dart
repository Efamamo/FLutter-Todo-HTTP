import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'todo.dart';

class AddTodoPage extends StatefulWidget {
  Map? todo;
  AddTodoPage({this.todo, super.key});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;
  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      titleController.text = todo['title'];
      descriptionController.text = todo['description'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Todo"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(hintText: 'Title'),
          ),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(hintText: 'Description'),
            minLines: 5,
            maxLines: 8,
            keyboardType: TextInputType.multiline,
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5))),
              onPressed: isEdit
                  ? () {
                      if (widget.todo != null) {
                        update(widget.todo?["_id"]);
                      }
                    }
                  : submit,
              child: Text(isEdit ? 'Update' : "Submit"))
        ],
      ),
    );
  }

  void update(id) async {
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false
    };
    // submit data
    final url = 'http://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.put(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});
    print(response.statusCode);
    if (response.statusCode == 200) {
      showSuccess('Update Success');
      titleController.text = '';
      descriptionController.text = '';
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const ToDoList();
      }));
    } else {
      showError('Update Failed');
    }
  }

  void submit() async {
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false
    };
    // submit data
    final url = 'http://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 201) {
      showSuccess('Creation Success');
      titleController.text = '';
      descriptionController.text = '';
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const ToDoList();
      }));
    } else {
      showError('Creation Failed');
    }

    //show succes or failure
  }

  void showError(message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(snackBar);
  }

  void showSuccess(message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(snackBar);
  }
}
