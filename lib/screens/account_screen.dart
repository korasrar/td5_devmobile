import 'package:flutter/material.dart';
import 'package:td2/models/todo.dart';
import '../myapi.dart';

class AccountScreen extends StatelessWidget {
  final MyAPI api = MyAPI();

  AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Todo>>(
      future: api.getTodos(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done &&
            !snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        return ListView.builder(
          itemCount: snapshot.data?.length,
          itemBuilder: (context, index) {
            return Card(
              color: Colors.black54,
              elevation: 2,
              margin: const EdgeInsets.all(10),
              child: ListTile(
                title: Text(snapshot.data![index].title),
                // checkbox avec le completed
                subtitle: Checkbox(
                  value: snapshot.data![index].completed,
                  onChanged: (bool? value) {},
                ),
              ),
            );
          },
        );
      },
    );
  }
}
