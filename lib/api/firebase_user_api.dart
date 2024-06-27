import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

class FirebaseUserAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  // static final FirebaseFirestore db = FirebaseFirestore.instance;
  // final db = FakeFirebaseFirestore();

  Stream<QuerySnapshot> getAllUsers() {
    return db.collection("users").snapshots();
  }

  Future<String> deleteUser(String? id, String? userunfriend) async {
    try {
      await db.collection("users").doc(id).update({
        'friends': FieldValue.arrayRemove([userunfriend])
      });
      await db.collection("users").doc(userunfriend).update({
        'friends': FieldValue.arrayRemove([id])
      });
      return "Successfully deleted friend!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> addUser(String? id, String? addeduserid) async {
    try {
      await db.collection("users").doc(id).update({
        'sentFriendRequests': FieldValue.arrayUnion([addeduserid])
      });
      await db.collection("users").doc(addeduserid).update({
        'receivedFriendRequests': FieldValue.arrayUnion([id])
      });
      return "Successfully added friend!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> acceptFriend(String? id, String? addeduserid) async {
    try {
      await db.collection("users").doc(id).update({
        'friends': FieldValue.arrayUnion([addeduserid])
      });
      await db.collection("users").doc(addeduserid).update({
        'friends': FieldValue.arrayUnion([id])
      });
      await db.collection("users").doc(id).update({
        'receivedFriendRequests': FieldValue.arrayRemove([addeduserid])
      });
      await db.collection("users").doc(addeduserid).update({
        'sentFriendRequests': FieldValue.arrayRemove([id])
      });
      return "Successfully Accepted Friend Request!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> rejectFriend(String? id, String? rejecteduserid) async {
    try {
      await db.collection("users").doc(id).update({
        'receivedFriendRequests': FieldValue.arrayRemove([rejecteduserid])
      });
      await db.collection("users").doc(rejecteduserid).update({
        'sentFriendRequests': FieldValue.arrayRemove([id])
      });
      return "Successfully Rejected Friend Request!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> editBio(String? id, String bio) async {
    try {
      print("New String: $bio");
      await db.collection("users").doc(id).update({"bio": bio});

      return "Successfully edited bio!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }
}
