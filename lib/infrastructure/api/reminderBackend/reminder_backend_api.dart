import 'package:graphql/client.dart';
import 'package:reminder_frontend/core/components/reminderContext/domain/entities/token.dart';
import 'package:reminder_frontend/core/ports/outputPorts/authentication_api.dart';

import 'graphql_exception.dart';

class ReminderBackendApi implements AuthenticationApi {
  late final GraphQLClient _graphQLClient;

  ReminderBackendApi(){
    _graphQLClient = GraphQLClient(
      cache: GraphQLCache(),
      link: HttpLink('http://127.0.0.1:4000/graphql'), // Replace with your GraphQL server URL
    );
  }

  @override
  Future<Token?> signIn(String email, String password) async {
    // TODO: implement signIn
    final MutationOptions options = MutationOptions(
      document: gql('''
          mutation SignIn(\$email: String!, \$password: String!) {
            signIn(email: \$email, password: \$password) {
              token
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
        // Handle GraphQL errors by throwing a custom exception
        throw GraphQLException(result.exception.toString());
        // You can also access specific error information like result.exception.graphqlErrors
      } else {
        // Handle successful sign-up
        final data = result.data!['signIn'];
        final token = Token(data['token']);
        return token;
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
  Future<Token?> signUp(String email, String password, String fullName) async {
    final MutationOptions options = MutationOptions(
      document: gql('''
          mutation SignUp(\$password: String!, \$email: String!) {
            signUp(password: \$password, email: \$email) {
              token
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
        // Handle GraphQL errors by throwing a custom exception
        throw GraphQLException(result.exception.toString());
        // You can also access specific error information like result.exception.graphqlErrors
      } else {
        // Handle successful sign-up
        final data = result.data!['signUp'];
        final token = Token(data['token']);
        return token;
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

}