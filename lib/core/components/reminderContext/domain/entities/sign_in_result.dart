import 'package:reminder_frontend/core/components/reminderContext/domain/entities/refresh_token.dart';
import 'package:reminder_frontend/core/components/reminderContext/domain/valueObjects/invalid_input.dart';

import 'access_token.dart';

abstract class SignInResult {}

class SignInSuccess extends SignInResult {
  String sessionId;
  AccessToken accessToken;
  RefreshToken refreshToken;

  SignInSuccess(dynamic graphQlData)
      : sessionId = graphQlData['sessionId'],
        accessToken = AccessToken(graphQlData['accessToken']['token']),
        refreshToken = RefreshToken(
          graphQlData['refreshToken']['token'],
          DateTime.parse(graphQlData['refreshToken']['expiration']),
        );
}

class SignInProblem extends SignInResult {
  String title;
  late List<InvalidInput> invalidInputs = [];

  SignInProblem(dynamic graphQlData) : title = graphQlData['title'] {
    for (dynamic invalidInput in graphQlData['invalidInputs']) {
      print(invalidInput);
      invalidInputs
          .add(InvalidInput(invalidInput['field'], invalidInput['message']));
    }
  }
}
