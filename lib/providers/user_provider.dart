import 'package:flutter/material.dart';
import 'package:week7_networking_discussion/api/firebase_user_api.dart';
import 'package:week7_networking_discussion/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProvider with ChangeNotifier {
  late FirebaseUserAPI firebaseService;
  late Stream<QuerySnapshot> _userStream;
  User? _selectedUser;

  UserProvider() {
    firebaseService = FirebaseUserAPI();
    fetchUsers();
  }

  // getter
  Stream<QuerySnapshot> get users => _userStream;
  User get selected => _selectedUser!;

  selectUser(User item) {
    _selectedUser = item;
  }

  void fetchUsers() {
    _userStream = firebaseService.getAllUsers();
    notifyListeners();
  }

  void toggleStatus(int index, bool status) {
    // _todoList[index].completed = status;
    print("Toggle Status");
    notifyListeners();
  }

  void deleteUser(User user) async {
    String message =
        await firebaseService.deleteUser(user.id, _selectedUser!.id);
    print(message);
    // notifyListeners();
  }

  void addUser(User user) async {
    String message = await firebaseService.addUser(user.id, _selectedUser!.id);
    print(message);
    // notifyListeners();
  }

  void acceptFriend(User user) async {
    String message =
        await firebaseService.acceptFriend(user.id, _selectedUser!.id);
    print(message);
    // notifyListeners();
  }

  void rejectFriend(User user) async {
    String message =
        await firebaseService.rejectFriend(user.id, _selectedUser!.id);
    print(message);
    // notifyListeners();
  }

  void editBio(String bio) async {
    String message = await firebaseService.editBio(_selectedUser!.id, bio);
    print(message);
    notifyListeners();
  }
}
