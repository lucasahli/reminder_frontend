import 'package:reminder_frontend/core/components/reminderContext/domain/entities/access_token.dart';
import 'package:reminder_frontend/core/components/reminderContext/domain/entities/refresh_token.dart';

abstract class RefreshAccessResult {}

class RefreshAccessSuccess extends RefreshAccessResult {
  String sessionId;
  AccessToken accessToken;
  RefreshToken refreshToken;

  RefreshAccessSuccess(dynamic graphQlData)
      : sessionId = graphQlData['sessionId'],
        accessToken = AccessToken(graphQlData['accessToken']['token']),
        refreshToken = RefreshToken(
          graphQlData['refreshToken']['token'],
          DateTime.parse(graphQlData['refreshToken']['expiration']),
        );
}

class RefreshAccessProblem extends RefreshAccessResult {
  String? message;

  RefreshAccessProblem(dynamic graphQlData) : message = graphQlData['message'];
}
