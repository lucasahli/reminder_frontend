import 'package:reminder_frontend/core/components/reminderContext/domain/entities/access_token.dart';
import 'package:reminder_frontend/core/components/reminderContext/domain/entities/refresh_access_result.dart';
import 'package:reminder_frontend/core/ports/outputPorts/authentication_api.dart';

import '../../../../ports/outputPorts/secure_storage.dart';
import '../../domain/entities/refresh_token.dart';
import '../../domain/entities/sign_in_result.dart';
import '../../domain/valueObjects/user_role.dart';

class AuthenticationService {
  final AuthenticationApi _authenticationApi;
  final SecureStorage _secureStorage;

  AccessToken? accessToken;
  RefreshToken? refreshToken;
  String? sessionId;

  AuthenticationService(this._authenticationApi, this._secureStorage);

  Future<bool> signUp(String email, String password, String fullName) async {
    final SignInResult? result =
        await _authenticationApi.signUp(email, password, fullName);
    if (result is SignInSuccess) {
      // TODO: Store also the other token and sessionId
      return storeNewAccessToken(result.accessToken);
    }
    return false;
  }

  Future<SignInResult> signIn(String email, String password) async {
    final SignInResult result =
        await _authenticationApi.signIn(email, password);
    if (result is SignInSuccess) {
      storeNewAccessToken(result.accessToken);
      storeNewSessionId(result.sessionId);
      storeNewRefreshToken(result.refreshToken);
    }
    return result;
  }

  bool switchUser(UserRole userRole) {
    // TODO: Implement switchUser
    return true;
  }

  bool storeNewAccessToken(AccessToken? newAccessToken) {
    if (newAccessToken != null) {
      // You received a valid token
      // You can use the token for further authentication or authorization
      if (newAccessToken.isValid) {
        accessToken = newAccessToken;
        print("New AccessToken: ${newAccessToken.toString()}");
        _secureStorage.write('ACCESS_TOKEN', newAccessToken.toString());
        return true;
      } else {
        return false;
      }
    } else {
      // signUp returned null, indicating an error occurred
      // Handle the error or show an error message to the user
      return false;
    }
  }

  bool storeNewSessionId(String? newSessionId) {
    if (newSessionId != null) {
      sessionId = newSessionId;
      _secureStorage.write('SESSION_ID', newSessionId);
      return true;
    } else {
      return false;
    }
  }

  bool storeNewRefreshToken(RefreshToken? newRefreshToken) {
    if (newRefreshToken != null) {
      // You received a valid token
      // You can use the token for further authentication or authorization
      if (newRefreshToken.isValid()) {
        refreshToken = newRefreshToken;
        print("New RefreshToken: ${newRefreshToken.toString()}");
        _secureStorage.write('REFRESH_TOKEN', newRefreshToken.toJson());
        return true;
      } else {
        return false;
      }
    } else {
      // signUp returned null, indicating an error occurred
      // Handle the error or show an error message to the user
      return false;
    }
  }

  bool get isAuthenticated {
    // Check if accessToken is not null and then validate it.
    // Check if sessionId is not null.
    return accessToken?.isValid == true && sessionId != null;
  }

  Future<void> loadTokensFromStorage() async {
    final bearerToken = await _secureStorage.read('ACCESS_TOKEN');
    if (bearerToken != null) {
      accessToken = AccessToken(bearerToken);
    }
    sessionId = await _secureStorage.read('SESSION_ID');
    final refreshTokenJson = await _secureStorage.read('REFRESH_TOKEN');
    if (refreshTokenJson != null) {
      refreshToken = RefreshToken.fromJson(refreshTokenJson);
    }
  }

  Future<String?> getAccessToken() async {
    await loadTokensFromStorage();
    if (isAuthenticated) {
      return accessToken.toString();
    }
    // If expired
    final success = await _refreshTokens();
    if (!success) {
      return null;
    }
    return accessToken.toString();
  }

  Future<bool> _refreshTokens() async {
    if (refreshToken == null) {
      // Prompt user to log in again
      return false;
    }

    final result =
        await _authenticationApi.refreshAccess(refreshToken.toString());

    if (result is RefreshAccessSuccess) {
      storeNewAccessToken(result.accessToken);
      storeNewSessionId(result.sessionId);
      storeNewRefreshToken(result.refreshToken);
      return true;
    } else {
      return false;
      // Handle error, refresh token might be invalid or expired
      // Prompt user to log in again
    }
  }
}
