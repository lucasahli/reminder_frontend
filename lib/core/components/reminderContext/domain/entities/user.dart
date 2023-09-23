import '../valueObjects/user_role.dart';

class User {
  final String id;
  final String fullName;
  UserRole userRole;

  User({
    required this.id,
    required this.fullName,
    required this.userRole
  });
}