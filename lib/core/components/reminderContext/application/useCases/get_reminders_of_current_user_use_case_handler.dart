
import 'package:reminder_frontend/core/ports/inputPorts/get_reminders_of_current_user_use_case.dart';

import '../../domain/entities/reminder.dart';
import '../services/reminder_api_service.dart';

class GetRemindersOfCurrentUserUseCaseHandler implements GetRemindersOfCurrentUserUseCase {
  ReminderApiService _reminderApiService;
  GetRemindersOfCurrentUserUseCaseHandler(this._reminderApiService);

  @override
  Future<List<Reminder?>> execute(){
    return _reminderApiService.getRemindersOfCurrentUser();
  }
}