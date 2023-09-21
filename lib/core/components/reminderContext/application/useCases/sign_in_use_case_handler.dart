import 'package:reminder_frontend/core/components/reminderContext/application/services/account_service.dart';
import 'package:reminder_frontend/core/ports/inputPorts/sign_in_use_case.dart';

// Implement a class that adheres to the interface
class SignInUseCaseHandler implements SignInUseCase {
  final AccountService _accountService;

  SignInUseCaseHandler(this._accountService);

  @override
  Future<bool> execute(String email, String password) async {
    return await _accountService.signIn(email, password);
  }
}