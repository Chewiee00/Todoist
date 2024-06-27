import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week7_networking_discussion/models/user_model.dart';
import 'package:week7_networking_discussion/providers/auth_provider.dart';
import 'package:week7_networking_discussion/providers/user_provider.dart';
import 'package:week7_networking_discussion/screens/modal_todo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:week7_networking_discussion/screens/profile_page.dart';

class FriendsPage extends StatefulWidget {
  final snapshot;
  final Stream fstream;
  const FriendsPage(this.snapshot, this.fstream, {super.key});
  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.snapshot.data?.docs.length,
      itemBuilder: ((context, index) {
        User user = User.fromJson(
            widget.snapshot.data?.docs[index].data() as Map<String, dynamic>);
        List<Widget> friendslist = [];

        List<Widget> friendrequests = [];
        if (user.id == context.read<AuthProvider>().getUser()) {
          friendslist.add(Container(
              margin: const EdgeInsets.all(20.0),
              child: const Text("FRIENDS LIST")));
          friendrequests.add(Container(
              margin: const EdgeInsets.all(20.0),
              child: const Text("FRIEND REQUESTS")));
          for (int i = 0; i < widget.snapshot.data?.docs.length; i++) {
            User friend = User.fromJson(
                widget.snapshot.data?.docs[i].data() as Map<String, dynamic>);

            if (user.friends.contains(friend.id)) {
              friendslist.add(ListTile(
                title: InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Scaffold(
                            body: Builder(builder: (context) {
                              for (int i = 0;
                                  i < widget.snapshot.data?.docs.length;
                                  i++) {
                                User user = User.fromJson(
                                    widget.snapshot.data?.docs[i].data()
                                        as Map<String, dynamic>);

                                if (user.id ==
                                    context.read<AuthProvider>().getUser()) {
                                  return Container(
                                    padding: EdgeInsets.only(
                                        left: 16, top: 25, right: 16),
                                    child: GestureDetector(
                                      onTap: () {
                                        FocusScope.of(context).unfocus();
                                      },
                                      child: ListView(
                                        children: [
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Center(
                                            child: Stack(
                                              children: [
                                                Container(
                                                  width: 130,
                                                  height: 130,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          width: 4,
                                                          color: Theme.of(
                                                                  context)
                                                              .scaffoldBackgroundColor),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            spreadRadius: 2,
                                                            blurRadius: 10,
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.1),
                                                            offset:
                                                                Offset(0, 10))
                                                      ],
                                                      shape: BoxShape.circle,
                                                      image:
                                                          const DecorationImage(
                                                              fit: BoxFit.cover,
                                                              image:
                                                                  NetworkImage(
                                                                "https://media.istockphoto.com/id/522855255/vector/male-profile-flat-blue-simple-icon-with-long-shadow.jpg?s=612x612&w=0&k=20&c=EQa9pV1fZEGfGCW_aEK5X_Gyob8YuRcOYCYZeuBzztM=",
                                                              ))),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 35,
                                          ),
                                          Center(
                                            child: Column(children: [
                                              ListTile(
                                                title: Text(
                                                  friend.displayName,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      color: Colors.black54,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              ListTile(
                                                title: Text(
                                                  friend.birthdate,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      color: Colors.black54,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              ListTile(
                                                title: Text(
                                                  friend.location,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      color: Colors.black54,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              ListTile(
                                                title: Text(
                                                  friend.bio,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      color: Colors.black54,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              )
                                            ]),
                                          ),
                                          const SizedBox(
                                            height: 35,
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("Back"),
                                            style: TextButton.styleFrom(
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .labelLarge,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                              }

                              return Container();
                            }),
                          );
                        });
                  },
                  child: Text(friend.displayName),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Remove Friend"),
                    IconButton(
                      onPressed: () {
                        context.read<UserProvider>().selectUser(friend);
                        context.read<UserProvider>().deleteUser(user);
                      },
                      icon: const Icon(Icons.delete_outlined),
                    ),
                  ],
                ),
              ));
            }
            if (user.receivedFriendRequests.contains(friend.id)) {
              friendrequests.add(ListTile(
                title: Text(friend.displayName),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Accept"),
                    IconButton(
                      onPressed: () {
                        context.read<UserProvider>().selectUser(friend);
                        context.read<UserProvider>().acceptFriend(user);
                      },
                      icon: const Icon(Icons.add_outlined),
                    ),
                    Text("Reject"),
                    IconButton(
                      onPressed: () {
                        context.read<UserProvider>().selectUser(friend);
                        context.read<UserProvider>().rejectFriend(user);
                      },
                      icon: const Icon(Icons.delete_outlined),
                    )
                  ],
                ),
              ));
            }
          }
        }

        return Column(children: [
          Column(children: friendslist),
          Column(children: friendrequests)
        ]);
      }),
    );
  }
}
