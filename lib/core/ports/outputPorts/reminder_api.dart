import '../../components/reminderContext/domain/entities/reminder.dart';

abstract class ReminderApi {
  Future<List<Reminder?>?> getRemindersByOwnerId(String ownerId);
  Future<List<Reminder?>?> getRemindersOfCurrentUser();
}