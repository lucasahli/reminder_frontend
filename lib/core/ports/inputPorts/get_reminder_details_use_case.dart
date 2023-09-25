import '../../components/reminderContext/domain/entities/reminder.dart';

abstract class GetReminderDetailsUseCase {
  Future<Reminder?> execute(String reminderId);
}