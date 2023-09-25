import '../../components/reminderContext/domain/entities/reminder.dart';

abstract class GetRemindersOfCurrentUserUseCase {
  Future<List<Reminder?>> execute();
}