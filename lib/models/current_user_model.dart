class CurrentUserModel {
  String? displayName;
  String? email;
  String? photoUrl;
  String userId;

  CurrentUserModel({
    required this.displayName,
    required this.photoUrl,
    required this.email,
    required this.userId,
  });
}

class Message {
  String? createdAt;
  String? message;
  String? profileLink;
  String? userId;

  Message({
    required this.createdAt,
    required this.message,
    required this.profileLink,
    required this.userId,
  });
}
