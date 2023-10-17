import 'package:reminder_frontend/core/components/reminderContext/domain/entities/reminder.dart';

import '../../../../ports/inputPorts/get_reminder_details_use_case.dart';
import '../services/reminder_api_service.dart';

class GetReminderDetailsUseCaseHandler implements GetReminderDetailsUseCase {
  final ReminderApiService _reminderApiService;

  GetReminderDetailsUseCaseHandler(this._reminderApiService);

  @override
  Future<Reminder?> execute(String reminderId) {
    return _reminderApiService.getReminderDetails(reminderId);
  }
}