import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week7_networking_discussion/models/todo_model.dart';
import 'package:week7_networking_discussion/screens/friends_page.dart';
import 'package:week7_networking_discussion/screens/profile_page.dart';
import 'package:week7_networking_discussion/screens/search_page.dart';
import 'package:week7_networking_discussion/screens/todo_page.dart';
import 'package:week7_networking_discussion/providers/todo_provider.dart';
import 'package:week7_networking_discussion/providers/user_provider.dart';
import 'package:week7_networking_discussion/providers/auth_provider.dart';
import 'package:week7_networking_discussion/screens/modal_todo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // access the list of todos in the provider
    Stream<QuerySnapshot> todosStream = context.watch<TodoListProvider>().todos;
    Stream<QuerySnapshot> userStream = context.watch<UserProvider>().users;
    return StreamBuilder(
        stream: todosStream,
        builder: (context, snapshot1) {
          if (snapshot1.hasError) {
            return Center(
              child: Text("Error encountered! ${snapshot1.error}"),
            );
          } else if (snapshot1.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot1.hasData) {
            return const Center(
              child: Text("No Todos Found"),
            );
          }
          return StreamBuilder(
            stream: userStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text("Error encountered! ${snapshot.error}"),
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (!snapshot.hasData) {
                return const Center(
                  child: Text("No Todos Found"),
                );
              }
              return DefaultTabController(
                length: 4,
                child: Scaffold(
                    drawer: Drawer(
                        child: ListView(padding: EdgeInsets.zero, children: [
                      ListTile(
                        title: const Text('Logout'),
                        onTap: () {
                          context.read<AuthProvider>().signOut();
                          Navigator.pop(context);
                        },
                      ),
                    ])),
                    appBar: AppBar(
                      bottom: const TabBar(
                        tabs: [
                          Tab(text: ("Profile")),
                          Tab(text: ("Todos")),
                          Tab(text: ("Friends")),
                          Tab(text: ("Search")),
                        ],
                      ),
                      title: Center(child: Text("CMSC 23 PROJECT")),
                    ),
                    body: TabBarView(children: [
                      ProfilePage(snapshot, userStream),
                      //todo
                      TodoPage(snapshot1, todosStream, snapshot, userStream),
                      FriendsPage(snapshot, userStream),
                      //friendspage
                      SearchPage(snapshot, userStream),
                    ])),
              );
            },
          );
        });
  }
}
