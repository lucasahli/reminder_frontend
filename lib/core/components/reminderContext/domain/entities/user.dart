import '../valueObjects/user_role.dart';

class User {
  final String id;
  DateTime? created;
  DateTime? modified;
  final String fullName;
  UserRole? userRole;

  User(
      {required this.id,
      this.created,
      this.modified,
      required this.fullName,
      this.userRole});
}
