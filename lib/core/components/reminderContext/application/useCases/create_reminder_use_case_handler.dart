import 'package:reminder_frontend/core/ports/inputPorts/create_reminder_use_case.dart';

import '../../domain/entities/reminder.dart';
import '../services/reminder_api_service.dart';

class CreateReminderUseCaseHandler implements CreateReminderUseCase {
  final ReminderApiService _reminderApiService;

  CreateReminderUseCaseHandler(this._reminderApiService);

  @override
  Future<Reminder?> execute(String title, DateTime dateTimeToRemind) {
    return _reminderApiService.createReminder(title, dateTimeToRemind);
  }

}