import 'package:reminder_frontend/core/components/reminderContext/application/services/authentication_service.dart';
import 'package:reminder_frontend/core/components/reminderContext/domain/entities/sign_in_result.dart';
import 'package:reminder_frontend/core/ports/inputPorts/sign_in_use_case.dart';

// Implement a class that adheres to the interface
class SignInUseCaseHandler implements SignInUseCase {
  final AuthenticationService _accountService;

  SignInUseCaseHandler(this._accountService);

  @override
  Future<SignInResult> execute(String email, String password) async {
    return await _accountService.signIn(email, password);
  }
}
