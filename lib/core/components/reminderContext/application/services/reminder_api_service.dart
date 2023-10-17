import '../../../../ports/outputPorts/reminder_api.dart';
import '../../../../ports/outputPorts/secure_storage.dart';
import '../../domain/entities/reminder.dart';

class ReminderApiService {
  final ReminderApi _reminderApi;
  final SecureStorage _secureStorage;

  ReminderApiService(this._reminderApi, this._secureStorage);

  Future<List<Reminder?>> getRemindersOfCurrentUser() async {
    String? token = await _secureStorage.read('BEARER_TOKEN');
    if (token != null) {
      print("No token to get reminders of current user...");
      return _reminderApi.getRemindersOfCurrentUser();
    }
    // final Token? token = await _reminderApi.signUp(email, password, fullName);
    return [];
  }

  Future<Reminder?> createReminder(
      String title, DateTime dateTimeToRemind) async {
    String? token = await _secureStorage.read('BEARER_TOKEN');
    if (token != null) {
      return _reminderApi.createReminder(title, dateTimeToRemind);
    }
    // final Token? token = await _reminderApi.signUp(email, password, fullName);
    return null;
  }

  Future<Reminder?> getReminderDetails(String reminderId) async {
    String? token = await _secureStorage.read('BEARER_TOKEN');
    if (token != null) {
      return _reminderApi.getReminderDetails(reminderId);
    }
    print("No token to get reminder details...");
    return null;
  }
}
