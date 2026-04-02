import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../viewModel/TaskViewModel.dart';

class AddTask extends StatefulWidget {
  final Task? task;
  const AddTask({super.key, this.task});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.task != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Task' : 'Add Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              FormBuilder(
                key: _formKey,
                initialValue: isEditing
                    ? {
                        'title': widget.task!.title,
                        'description': widget.task!.description,
                        'nbhours': widget.task!.nbhours.toString(),
                        'difficulty': widget.task!.difficulty.toDouble(),
                        'tags': widget.task!.tags.join(', '),
                        'isExported': widget.task!.isExported,
                      }
                    : {'isExported': false},
                child: Column(
                  children: [
                    FormBuilderTextField(
                      name: 'title',
                      decoration: const InputDecoration(labelText: 'Title'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    FormBuilderTextField(
                      name: 'description',
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    FormBuilderTextField(
                      name: 'nbhours',
                      decoration: const InputDecoration(
                        labelText: 'Number of hours',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter number of hours';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    FormBuilderSlider(
                      name: 'difficulty',
                      initialValue: 3.0,
                      min: 0.0,
                      max: 5.0,
                      divisions: 5,
                      activeColor: Colors.red,
                      inactiveColor: Colors.pink[100],
                      decoration: const InputDecoration(
                        labelText: 'Difficulty',
                      ),
                    ),
                    const SizedBox(height: 10),
                    FormBuilderTextField(
                      name: 'tags',
                      decoration: const InputDecoration(
                        labelText: 'Tags (separated by comma)',
                        hintText: 'tag1, tag2, tag3',
                      ),
                    ),
                    const SizedBox(height: 10),
                    FormBuilderSwitch(
                      name: 'isExported',
                      title: const Text('Exporter vers Supabase'),
                      initialValue: isEditing ? widget.task!.isExported : false,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.saveAndValidate() ?? false) {
                    final formData = _formKey.currentState!.value;

                    List<String> tags = [];
                    if (formData['tags'] != null &&
                        (formData['tags'] as String).isNotEmpty) {
                      tags = (formData['tags'] as String)
                          .split(',')
                          .map((e) => e.trim())
                          .toList();
                    }

                    if (isEditing) {
                      final updatedTask = Task(
                        id: widget.task!.id,
                        title: formData['title'],
                        description: formData['description'],
                        nbhours: int.parse(formData['nbhours']),
                        difficulty: (formData['difficulty'] as double).toInt(),
                        tags: tags,
                        isExported: formData['isExported'],
                      );
                      context.read<TaskViewModel>().updateTask(updatedTask);
                    } else {
                      final newTask = Task(
                        title: formData['title'],
                        description: formData['description'],
                        nbhours: int.parse(formData['nbhours']),
                        difficulty: (formData['difficulty'] as double).toInt(),
                        tags: tags,
                        isExported: formData['isExported'],
                      );
                      context.read<TaskViewModel>().addTask(newTask);
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isEditing ? 'Task updated' : 'Task added',
                        ),
                      ),
                    );

                    Navigator.pop(context);
                  }
                },
                child: Text(isEditing ? 'Update Task' : 'Add Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
