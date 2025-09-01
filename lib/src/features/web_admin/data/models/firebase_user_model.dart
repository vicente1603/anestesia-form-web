class FirebaseUser {
  final String uid;
  final String email;
  final String name;
  final String role;
  final bool? blocked;

  FirebaseUser({
    required this.uid,
    required this.email,
    required this.name,
    required this.role,
    this.blocked,
  });

  factory FirebaseUser.fromMap(Map<String, dynamic> map) {
    return FirebaseUser(
      uid: map['uid'],
      email: map['email'],
      name: map['name'],
      role: map['role'],
      blocked: map['blocked'] ?? false,
    );
  }
}
