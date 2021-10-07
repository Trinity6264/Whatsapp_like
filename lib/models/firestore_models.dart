class FirestoreModels {
  String? displayName;
  String? email;
  String? photoUrl;
  String? userId;

  FirestoreModels({
    required this.displayName,
    required this.photoUrl,
    required this.email,
    required this.userId,
  });
}

class FirestoreModelsStatus {
  String? displayName;
  String? email;
  String? photoUrl;
  String? userId;
  List<dynamic> status;

  FirestoreModelsStatus({
    required this.displayName,
    required this.photoUrl,
    required this.email,
    required this.status,
    required this.userId,
  });
}
