import 'dart:convert';

import 'package:flutter/material.dart';
import 'add_page.dart';
import 'package:http/http.dart' as http;

class ToDoList extends StatefulWidget {
  const ToDoList({super.key});

  @override
  State<ToDoList> createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetch();
  }

  List items = [];
  bool isLoading = true;

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
      body: Visibility(
        visible: isLoading,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
        replacement: RefreshIndicator(
          onRefresh: fetch,
          child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, idx) {
                final item = items[idx];
                return ListTile(
                  leading: CircleAvatar(child: Text('${idx + 1}')),
                  title: Text(item['title']),
                  subtitle: Text(item['description']),
                );
              }),
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

  Future<void> fetch() async {
    final url = 'http://api.nstack.in/v1/todos?page=1&limit=10';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final result = json['items'] as List;
      setState(() {
        items = result;
      });
    }
    setState(() {
      isLoading = false;
    });
  }
}
