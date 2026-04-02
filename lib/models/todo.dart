class Todo {
  final int id;
  final String title;
  final bool completed;

  Todo({required this.id, required this.title, required this.completed});

  bool get completedTodo => completed;

  String get titleTodo => title;

  int get idTodo => id;

  factory Todo.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {'id': final int id, 'title': final String title, 'completed': final bool completed} => Todo(
          id: id,
          title: title,
          completed: completed
      ),
      _ => throw const FormatException('Invalid Todo format'),
    };
  }
}