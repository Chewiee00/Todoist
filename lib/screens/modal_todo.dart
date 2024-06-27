import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week7_networking_discussion/models/todo_model.dart';
import 'package:week7_networking_discussion/providers/auth_provider.dart';
import 'package:week7_networking_discussion/providers/todo_provider.dart';
import 'package:intl/intl.dart';

class TodoModal extends StatelessWidget {
  String type;
  TextEditingController _formFieldController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController deadlineController = TextEditingController();
  String formattedDate = '';
  String lasteditDate = '';
  String lastAuthor = '';

  TodoModal({
    super.key,
    required this.type,
  });

  // Method to show the title of the modal depending on the functionality
  Text _buildTitle() {
    switch (type) {
      case 'Add':
        return const Text("Add new todo");
      case 'Edit':
        return const Text("Edit todo");
      case 'Delete':
        return const Text("Delete todo");
      default:
        return const Text("");
    }
  }

  // Method to build the content or body depending on the functionality
  Widget _buildContent(BuildContext context) {
    switch (type) {
      case 'Delete':
        {
          return Text(
            "Are you sure you want to delete '${context.read<TodoListProvider>().selected.title}'?",
          );
        }
      // Edit and add will have input field in them
      case 'Edit':
        return Column(
          children: [
            Text(lasteditDate),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: context.read<TodoListProvider>().selected.title,
              ),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: context.read<TodoListProvider>().selected.description,
              ),
            ),
            TextField(
              onTap: () async {
                DateTime? newDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2200));
                if (newDate == null) {
                  deadlineController.text = '';
                  return;
                }
                formattedDate = DateFormat('yyyy-MM-dd').format(newDate);

                deadlineController.text = formattedDate;
              },
              controller: deadlineController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: context.read<TodoListProvider>().selected.deadline,
              ),
            )
          ],
        );

      case 'Add':
        return Column(children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: 'Title',
            ),
          ),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: 'Description',
            ),
          ),
          TextField(
            onTap: () async {
              DateTime? newDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2200));
              if (newDate == null) {
                deadlineController.text = '';
                return;
              }
              formattedDate = DateFormat('yyyy-MM-dd').format(newDate);

              deadlineController.text = formattedDate;
            },
            controller: deadlineController,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: 'Deadline',
            ),
          )
        ]);
      default:
        return Column();
    }
  }

  TextButton _dialogAction(BuildContext context) {
    // List<Todo> todoItems = context.read<TodoListProvider>().todo;

    return TextButton(
      onPressed: () {
        switch (type) {
          case 'Add':
            {
              // Instantiate a todo objeect to be inserted, default userID will be 1, the id will be the next id in the list
              Todo temp = Todo(
                  userId: context.read<AuthProvider>().getUser(),
                  completed: false,
                  title: titleController.text,
                  description: descriptionController.text,
                  deadline: deadlineController.text);

              context.read<TodoListProvider>().addTodo(temp);

              // Remove dialog after adding
              Navigator.of(context).pop();
              break;
            }
          case 'Edit':
            {
              lasteditDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
              context.read<TodoListProvider>().editTodo(titleController.text,
                  descriptionController.text, deadlineController.text);

              // Remove dialog after editing
              Navigator.of(context).pop();
              break;
            }
          case 'Delete':
            {
              context.read<TodoListProvider>().deleteTodo();

              // Remove dialog after editing
              Navigator.of(context).pop();
              break;
            }
        }
      },
      style: TextButton.styleFrom(
        textStyle: Theme.of(context).textTheme.labelLarge,
      ),
      child: Text(type),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: _buildTitle(),
      content: _buildContent(context),

      // Contains two buttons - add/edit/delete, and cancel
      actions: <Widget>[
        _dialogAction(context),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("Cancel"),
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
        ),
      ],
    );
  }
}

// String? validateDeadline(String? formBirthdate) {
//   final now = DateTime.now();
//   String formattedDate = DateFormat('yyyy-MM-dd').format(now);
//   if (formBirthdate == null || formBirthdate.isEmpty) {
//     return 'Deadline is required.';
//   }
//   if (formBirthdate == formattedDate) {
//     return 'Enter a valid deadline';
//   }

//   return null;
// }
