import 'package:reminder_frontend/core/components/reminderContext/domain/entities/user.dart';

class Reminder {
  final String id;
  String title;
  User? owner;
  List<User>? usersToRemind;
  bool isCompleted;
  DateTime? dateTimeToRemind;


  Reminder({
    required this.id,
    required this.title,
    this.owner,
    this.usersToRemind,
    required this.isCompleted,
    this.dateTimeToRemind,
  });
}