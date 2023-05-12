class User {
  String id;
  String userId;
  String displayName;
  String email;
  String photoUrl;

  User({
    required this.id,
     required this.userId,
    required this.displayName,
    required this.email,
    required this.photoUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      userId: json['userId'],
      displayName: json['displayName'],
      email: json['email'],
      photoUrl: json['photoUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['userId'] = userId;
    data['displayName'] = displayName;
    data['email'] = email;
    data['photoUrl'] = photoUrl;
    return data;
  }
}
