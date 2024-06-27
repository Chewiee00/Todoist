import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week7_networking_discussion/models/todo_model.dart';
import 'package:week7_networking_discussion/models/user_model.dart';
import 'package:week7_networking_discussion/providers/todo_provider.dart';
import 'package:week7_networking_discussion/providers/auth_provider.dart';
import 'package:week7_networking_discussion/providers/user_provider.dart';
import 'package:week7_networking_discussion/screens/modal_todo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TodoPage extends StatefulWidget {
  final snapshot;
  final snapshot1;
  final Stream fstream;
  const TodoPage(this.snapshot, this.fstream, this.snapshot1, userstream,
      {super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  @override
  Widget build(BuildContext context) {
    // access the list of todos in the provider

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Todo")),
      ),
      body: ListView.builder(
        itemCount: widget.snapshot.data?.docs.length,
        itemBuilder: ((context, index) {
          for (int i = 0; i < widget.snapshot1.data?.docs.length; i++) {
            User user = User.fromJson(
                widget.snapshot1.data?.docs[i].data() as Map<String, dynamic>);

            if (user.id == context.read<AuthProvider>().getUser()) {
              print(user.id);
              Todo todo = Todo.fromJson(widget.snapshot.data?.docs[index].data()
                  as Map<String, dynamic>);
              if (user.id == todo.userId ||
                  user.friends.contains(todo.userId)) {
                return ListTile(
                  title: Text(todo.title),
                  leading: Checkbox(
                    value: todo.completed,
                    onChanged: (bool? value) {
                      if (user.id == todo.userId) {
                        context
                            .read<TodoListProvider>()
                            .changeSelectedTodo(todo);
                        context.read<TodoListProvider>().toggleStatus(value!);
                      } else {
                        print("Cannot change the value! You are not the owner");
                      }
                    },
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          context
                              .read<TodoListProvider>()
                              .changeSelectedTodo(todo);
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => TodoModal(
                              type: 'Edit',
                            ),
                          );
                        },
                        icon: const Icon(Icons.create_outlined),
                      ),
                      IconButton(
                        onPressed: () {
                          if (user.id == todo.userId) {
                            context
                                .read<TodoListProvider>()
                                .changeSelectedTodo(todo);
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => TodoModal(
                                type: 'Delete',
                              ),
                            );
                          } else {
                            print("Cannot be deleted! You are not the owner");
                          }
                        },
                        icon: const Icon(Icons.delete_outlined),
                      )
                    ],
                  ),
                );
              }
            }
          }
          return Container();
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => TodoModal(
              type: 'Add',
            ),
          );
        },
        child: const Icon(Icons.add_outlined),
      ),
    );
  }
}
