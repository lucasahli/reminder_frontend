import 'package:graphql/client.dart';
import 'package:reminder_frontend/core/components/reminderContext/domain/entities/sign_in_result.dart';
import 'package:reminder_frontend/core/ports/outputPorts/authentication_api.dart';

import '../../../core/components/reminderContext/application/services/authentication_service.dart';
import '../../../core/components/reminderContext/domain/entities/refresh_access_result.dart';
import '../reminderBackend/graphql_exception.dart';

class AuthenticationBackendApi implements AuthenticationApi {
  late final GraphQLClient _graphQLClient;
  late final AuthenticationService _authenticationService;

  AuthenticationBackendApi() {
    // final HttpLink httpLink = HttpLink('http://34.105.53.4:4000/graphql');

    final HttpLink httpLink = HttpLink('http://127.0.0.1:4000/graphql',
        defaultHeaders: {"lucaHeader": "1"});
    // final HttpLink httpLink = HttpLink('http://192.168.1.13:4000/graphql');

    // final HttpLinkHeaders headers = HttpLinkHeaders()
    final Link link = httpLink;
    _graphQLClient = GraphQLClient(cache: GraphQLCache(), link: link);
  }

  @override
  Future<SignInResult> signIn(String email, String password) async {
    final MutationOptions options = MutationOptions(
      document: gql('''
      mutation SignIn(\$email: String!, \$password: String!) {
    signIn(email: \$email, password: \$password) {
        __typename
        ... on SignInSuccess {
            sessionId
            accessToken {
                token
            }
            refreshToken {
                expiration
                token
            }
        }
        ... on SignInProblem {
            title
            invalidInputs {
                field
                message
            }
        }
    }
}
        '''),
      variables: {
        'email': email,
        'password': password,
      },
    );

    try {
      final QueryResult result = await _graphQLClient.mutate(options);

      if (result.hasException) {
        print("Failed sign in: ");
        print(result.exception);

        // Handle GraphQL errors by throwing a custom exception
        throw GraphQLException(result.exception.toString());
        // You can also access specific error information like result.exception.graphqlErrors
      } else {
        print("Successful graphQl request: ${result.data?['signIn']}");
        // Handle successful sign-up
        final data = result.data?['signIn'];
        if (data['__typename'] == 'SignInSuccess') {
          return SignInSuccess(data);
        } else if (data['__typename'] == 'SignInProblem') {
          return SignInProblem(data);
        } else {
          throw Exception("Coud not create SignInResult!!!");
        }
      }
    } catch (error) {
      if (error is GraphQLException) {
        // Handle custom GraphQL exceptions
        rethrow;
      } else {
        // Handle network errors or other exceptions
        print('An error occurred: $error');
        rethrow;
      }
    }
  }

  @override
  Future<SignInResult?> signUp(
      String email, String password, String fullName) async {
    final MutationOptions options = MutationOptions(
      document: gql('''
          mutation SignUp(\$password: String!, \$email: String!, \$fullName: String!) {
            signUp(password: \$password, email: \$email, fullName: \$fullName) {
              __typename
              ... on SignUpSuccess {
                  sessionId
                  accessToken {
                      token
                  }
                  refreshToken {
                      id
                      created
                      modified
                      token
                      expiration
                      revoked
                      associatedLoginId
                      associatedDeviceId
                  }
              }
              ... on SignUpProblem {
                  title
                  invalidInputs {
                      field
                      message
                  }
              }
            }
          }
        '''),
      variables: {
        'email': email,
        'password': password,
        'fullName': fullName,
      },
    );

    try {
      final QueryResult result = await _graphQLClient.mutate(options);

      if (result.hasException) {
        // Handle GraphQL errors by throwing a custom exception
        throw GraphQLException(result.exception.toString());
        // You can also access specific error information like result.exception.graphqlErrors
      } else {
        // Handle successful sign-up
        print("Successful graphQl request: ${result.data?['signUp']}");
        // Handle successful sign-up
        final data = result.data?['signUp'];
        if (data['__typename'] == 'SignUpSuccess') {
          return SignInSuccess(data);
        } else if (data['__typename'] == 'SignUpProblem') {
          return SignInProblem(data);
        } else {
          throw Exception("Coud not create SignUpResult!!!");
        }
      }
    } catch (error) {
      if (error is GraphQLException) {
        // Handle custom GraphQL exceptions
        return null;
      } else {
        // Handle network errors or other exceptions
        print('An error occurred: $error');
        return null;
      }
    }
  }

  @override
  Future<RefreshAccessResult> refreshAccess(String refreshTokenString) async {
    final MutationOptions options = MutationOptions(
      document: gql('''
      mutation RefreshAccess(\$refreshToken: String!) {
    refreshAccess(refreshToken: \$refreshToken) {
        __typename
        ... on RefreshAccessSuccess {
            sessionId
            accessToken {
                token
            }
            refreshToken {
                expiration
                token
            }
        }
        ... on RefreshAccessProblem {
            message
        }
    }
}
        '''),
      variables: {
        'refreshToken': refreshTokenString,
      },
    );

    try {
      final QueryResult result = await _graphQLClient.mutate(options);

      if (result.hasException) {
        print("Failed refresh Access: ");
        print(result.exception);

        // Handle GraphQL errors by throwing a custom exception
        throw GraphQLException(result.exception.toString());
        // You can also access specific error information like result.exception.graphqlErrors
      } else {
        print("Successful graphQl request: ${result.data?['refreshAccess']}");
        // Handle successful sign-up
        final data = result.data?['refreshAccess'];
        if (data['__typename'] == 'RefreshAccessSuccess') {
          return RefreshAccessSuccess(data);
        } else if (data['__typename'] == 'RefreshAccessProblem') {
          return RefreshAccessProblem(data);
        } else {
          throw Exception("Coud not create RefreshAccessResult!!!");
        }
      }
    } catch (error) {
      if (error is GraphQLException) {
        // Handle custom GraphQL exceptions
        rethrow;
      } else {
        // Handle network errors or other exceptions
        print('An error occurred: $error');
        rethrow;
      }
    }
  }
}
