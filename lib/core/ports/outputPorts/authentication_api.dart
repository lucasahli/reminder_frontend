import '../../components/reminderContext/domain/entities/refresh_access_result.dart';
import '../../components/reminderContext/domain/entities/sign_in_result.dart';

abstract class AuthenticationApi {
  Future<SignInResult?> signUp(String email, String password, String fullName);
  Future<SignInResult> signIn(String email, String password);
  Future<RefreshAccessResult> refreshAccess(String refreshTokenString);
}
