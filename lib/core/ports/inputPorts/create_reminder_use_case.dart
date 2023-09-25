import '../../components/reminderContext/domain/entities/reminder.dart';

abstract class CreateReminderUseCase {
  Future<Reminder?> execute(String title, DateTime dateTimeToRemind);
}