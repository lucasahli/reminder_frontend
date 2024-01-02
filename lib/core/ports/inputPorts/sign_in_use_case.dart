import 'package:reminder_frontend/core/components/reminderContext/domain/entities/sign_in_result.dart';

abstract class SignInUseCase {
  // Declare methods without implementation
  Future<SignInResult> execute(String email, String password);
}
