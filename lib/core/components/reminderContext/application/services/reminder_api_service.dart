import '../../../../ports/outputPorts/reminder_api.dart';
import '../../../../ports/outputPorts/secure_storage.dart';
import '../../domain/entities/reminder.dart';
import 'authentication_service.dart';

class ReminderApiService {
  final ReminderApi _reminderApi;
  final AuthenticationService _authenticationService;

  ReminderApiService(this._reminderApi, this._authenticationService);

  Future<List<Reminder?>> getRemindersOfCurrentUser() async {
    final accessToken = _authenticationService.accessToken;
    if (accessToken != null && accessToken.isValid) {
      return await _reminderApi.getRemindersOfCurrentUser();
    }
    // final Token? token = await _reminderApi.signUp(email, password, fullName);

    return [];
  }

  Future<Reminder?> createReminder(
      String title, DateTime dateTimeToRemind) async {
    final accessToken = _authenticationService.accessToken;
    if (accessToken != null && accessToken.isValid) {
      return _reminderApi.createReminder(title, dateTimeToRemind);
    }
    // final Token? token = await _reminderApi.signUp(email, password, fullName);
    return null;
  }

  Future<Reminder?> getReminderDetails(String reminderId) async {
    final accessToken = _authenticationService.accessToken;
    if (accessToken != null && accessToken.isValid) {
      return _reminderApi.getReminderDetails(reminderId);
    }
    print("No token to get reminder details...");
    return null;
  }
}
