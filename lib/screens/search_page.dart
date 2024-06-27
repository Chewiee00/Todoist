import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week7_networking_discussion/models/todo_model.dart';
import 'package:week7_networking_discussion/models/user_model.dart';
import 'package:week7_networking_discussion/providers/todo_provider.dart';
import 'package:week7_networking_discussion/providers/auth_provider.dart';
import 'package:week7_networking_discussion/screens/modal_todo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../providers/user_provider.dart';

class SearchPage extends StatefulWidget {
  final snapshot;
  final Stream fstream;
  const SearchPage(this.snapshot, this.fstream, {super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String name = "";
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> userStream = context.watch<UserProvider>().users;
    return Scaffold(
      appBar: AppBar(
          title: Card(
        child: TextField(
          decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search), hintText: 'Search...'),
          onChanged: (val) {
            setState(() {
              name = val;
            });
          },
        ),
      )),
      body: ListView.builder(
          itemCount: widget.snapshot.data?.docs.length,
          itemBuilder: (context, index) {
            User user = User.fromJson(widget.snapshot.data?.docs[index].data()
                as Map<String, dynamic>);

            if (name.isEmpty) {
              if (user.friends
                      .contains(context.read<AuthProvider>().getUser()) ||
                  user.id == context.read<AuthProvider>().getUser() ||
                  user.receivedFriendRequests
                      .contains(context.read<AuthProvider>().getUser()) ||
                  user.sentFriendRequests
                      .contains(context.read<AuthProvider>().getUser())) {
                return ListTile(
                  title: Text(
                    user.displayName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                );
              } else {
                return ListTile(
                  title: Text(
                    user.displayName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Add Friend"),
                      IconButton(
                        onPressed: () {
                          for (int i = 0;
                              i < widget.snapshot.data?.docs.length;
                              i++) {
                            User user2 = User.fromJson(
                                widget.snapshot.data?.docs[i].data()
                                    as Map<String, dynamic>);
                            if (user2.id ==
                                context.read<AuthProvider>().getUser()) {
                              context.read<UserProvider>().selectUser(user);
                              context.read<UserProvider>().addUser(user2);
                            }
                          }
                        },
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                );
              }
            }

            if (user.username
                .toString()
                .toLowerCase()
                .startsWith(name.toLowerCase())) {
              if (user.friends
                      .contains(context.read<AuthProvider>().getUser()) ||
                  user.id == context.read<AuthProvider>().getUser() ||
                  user.receivedFriendRequests
                      .contains(context.read<AuthProvider>().getUser()) ||
                  user.sentFriendRequests
                      .contains(context.read<AuthProvider>().getUser())) {
                return ListTile(
                  title: Text(
                    user.displayName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                );
              } else {
                return ListTile(
                  title: Text(
                    user.displayName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Add Friend"),
                      IconButton(
                        onPressed: () {
                          for (int i = 0;
                              i < widget.snapshot.data?.docs.length;
                              i++) {
                            User user2 = User.fromJson(
                                widget.snapshot.data?.docs[i].data()
                                    as Map<String, dynamic>);
                            if (user2.id ==
                                context.read<AuthProvider>().getUser()) {
                              context.read<UserProvider>().selectUser(user);
                              context.read<UserProvider>().addUser(user2);
                            }
                          }
                        },
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                );
              }
            }
            return Container();
          }),
    );
  }
}
