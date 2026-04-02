import 'package:flutter/material.dart';
import 'package:td2/models/task.dart';

class SearchScreen extends StatelessWidget {
  final List<Task> tasks;

  const SearchScreen({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: tasks.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          color: Colors.black54,
          elevation: 2,
          margin: const EdgeInsets.all(10),
          child: ListTile(
            leading: CircleAvatar(backgroundColor: Colors.grey, child: Text(tasks[index].difficulty.toString()),),
            title: Text(tasks[index].title),
            subtitle: Text(tasks[index].tags.toString()),
          ),
        );
      },
    );
  }
}
