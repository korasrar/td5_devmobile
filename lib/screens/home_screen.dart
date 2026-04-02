import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewModel/TaskViewModel.dart';
import 'DetailScreen.dart';
import 'AddTask.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskViewModel>(
      builder: (context, taskViewModel, child) {
        final tasks = taskViewModel.liste;

        if (tasks.isEmpty) {
          return const Center(child: Text('Aucune tâche.'));
        }

        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return Card(
              color: Colors.black54,
              elevation: 2,
              margin: const EdgeInsets.all(10),
              child: ListTile(
                title: Text(
                  task.title,
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  task.description,
                  style: const TextStyle(color: Colors.white70),
                ),
                trailing: Wrap(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.white),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddTask(task: task),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      onPressed: () {
                        taskViewModel.deleteTask(task);
                      },
                      icon: const Icon(Icons.delete),
                      color: Colors.redAccent,
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailScreen(task: task),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
