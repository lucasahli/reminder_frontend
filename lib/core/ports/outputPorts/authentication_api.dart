import '../../components/reminderContext/domain/entities/token.dart';

abstract class AuthenticationApi {
  Future<Token?> signUp(String email, String password, String fullName);
  Future<Token?> signIn(String email, String password);
}