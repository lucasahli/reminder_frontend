import 'package:reminder_frontend/core/ports/outputPorts/authentication_api.dart';

import '../../../../ports/outputPorts/secure_storage.dart';
import '../../domain/entities/token.dart';
import '../../domain/valueObjects/user_role.dart';

class AccountService {
  final AuthenticationApi _authenticationApi;
  final SecureStorage _secureStorage;

  AccountService(this._authenticationApi, this._secureStorage);

  Future<bool> signUp(String email, String password, String fullName) async {
    final Token? token = await _authenticationApi.signUp(email, password, fullName);
    return storeNewToken(token);
  }

  Future<bool> signIn(String email, String password) async {
    final Token? token = await _authenticationApi.signIn(email, password);
    return storeNewToken(token);
  }

  bool switchUser(UserRole userRole){
    // TODO: Implement switchUser
    return true;
  }

  bool storeNewToken(Token? token){
    if (token != null) {
      // You received a valid token
      // You can use the token for further authentication or authorization
      var tokenString = token.token;
      if(tokenString != null){
        _secureStorage.write('BEARER_TOKEN', 'Bearer $tokenString');
        return true;
      }
      else {
        return false;
      }
    } else {
      // signUp returned null, indicating an error occurred
      // Handle the error or show an error message to the user
      return false;
    }
  }
}