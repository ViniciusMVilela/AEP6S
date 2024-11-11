class User {
  final String id;
  final String login;
  final String email;
  final String role;
  final String document;
  final String createdAt;

  User({
    required this.id,
    required this.login,
    required this.email,
    required this.role,
    required this.document,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      login: json['login'],
      email: json['email'],
      role: json['role'],
      document: json['document'],
      createdAt: json['createdAt'],
    );
  }
}