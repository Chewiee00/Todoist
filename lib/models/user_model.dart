import 'dart:convert';

class User {
  String? id;
  String username;
  String displayName;
  String birthdate;
  String location;
  String bio;
  List<dynamic> friends;
  List<dynamic> receivedFriendRequests;
  List<dynamic> sentFriendRequests;

  User({
    this.id,
    required this.username,
    required this.displayName,
    required this.birthdate,
    required this.location,
    required this.friends,
    required this.bio,
    required this.receivedFriendRequests,
    required this.sentFriendRequests,
  });

  // Factory constructor to instantiate object from json format
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        username: json['username'],
        displayName: json['displayName'],
        birthdate: json['birthdate'],
        location: json['location'],
        bio: json['bio'],
        friends: json['friends'],
        receivedFriendRequests: json['receivedFriendRequests'],
        sentFriendRequests: json['sentFriendRequests']);
  }

  static List<User> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<User>((dynamic d) => User.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson(User user) {
    return {
      'username': user.username,
      'displayName': user.displayName,
      'birthdate': user.birthdate,
      'location': user.location,
      'bio': user.bio,
      'friends': user.friends,
      'receivedFriendRequests': user.receivedFriendRequests,
      'sentFriendRequests': user.sentFriendRequests,
    };
  }
}
