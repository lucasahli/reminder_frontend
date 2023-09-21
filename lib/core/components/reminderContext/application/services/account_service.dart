import 'package:reminder_frontend/core/ports/outputPorts/authentication_api.dart';

import '../../domain/entities/token.dart';
import '../../domain/valueObjects/user_role.dart';

class AccountService {
  AuthenticationApi _authenticationApi;

  AccountService(this._authenticationApi);

  Future<bool> signIn(String email, String password) async {
    // TODO: Implement signIn
    final Token? token = await _authenticationApi.signIn(email, password);
    if (token != null) {
      // You received a valid token
      // You can use the token for further authentication or authorization
      var tokenString = token.token;
      print("Token: $tokenString");
      return true;
    } else {
      // signUp returned null, indicating an error occurred
      // Handle the error or show an error message to the user
      return false;
    }
  }

  bool switchUser(UserRole userRole){
    // TODO: Implement switchUser
    return true;
  }
}