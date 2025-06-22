class User {
  final String id;
  final String name;
  final String fullName;
  final List<String> roles;
  final String token;

  User(
      {required this.id,
      required this.name,
      required this.fullName,
      required this.roles,
      required this.token});

  bool get isAdming {
    return roles.contains('admin');
  }
}
