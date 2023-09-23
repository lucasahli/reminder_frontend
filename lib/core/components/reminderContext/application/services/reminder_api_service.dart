import '../../../../ports/outputPorts/reminder_api.dart';
import '../../../../ports/outputPorts/secure_storage.dart';
import '../../domain/entities/reminder.dart';

class ReminderApiService {
  final ReminderApi _reminderApi;
  SecureStorage _secureStorage;

  ReminderApiService(this._reminderApi, this._secureStorage);

  Future<List<Reminder?>?> getRemindersOfCurrentUser() async {
    String? token = await _secureStorage.read('BEARER_TOKEN');
    if(token != null){
      return _reminderApi.getRemindersOfCurrentUser();
    }
    // final Token? token = await _reminderApi.signUp(email, password, fullName);
    return null;
  }
}