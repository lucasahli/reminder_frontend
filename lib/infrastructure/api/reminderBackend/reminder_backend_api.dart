import 'package:graphql/client.dart';
import 'package:reminder_frontend/core/components/reminderContext/domain/entities/reminder.dart';
import 'package:reminder_frontend/core/components/reminderContext/domain/entities/token.dart';
import 'package:reminder_frontend/core/ports/outputPorts/authentication_api.dart';
import 'package:reminder_frontend/core/ports/outputPorts/secure_storage.dart';

import '../../../core/ports/outputPorts/reminder_api.dart';
import 'graphql_exception.dart';
import 'package:http/http.dart' as http;

class ReminderBackendApi implements AuthenticationApi, ReminderApi {
  late final GraphQLClient _graphQLClient;
  late final SecureStorage _secureStorage;

  ReminderBackendApi(this._secureStorage){
    final AuthLink authLink = AuthLink(
      getToken: () async => await _secureStorage.read('BEARER_TOKEN'),
      // Specify how to get and format your bearer token.
    );

    final HttpLink httpLink = HttpLink('http://127.0.0.1:4000/graphql');

    final Link link = authLink.concat(httpLink);
    _graphQLClient = GraphQLClient(
      cache: GraphQLCache(),
      link: link
    );
  }

  @override
  Future<Token?> signIn(String email, String password) async {
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
          mutation SignUp(\$password: String!, \$email: String!, \$fullName: String!) {
            signUp(password: \$password, email: \$email, fullName: \$fullName) {
              token
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

  @override
  Future<List<Reminder?>?> getRemindersByOwnerId(String ownerId) async {
    const String getRemindersByOwnerIdQuery = r'''
  query RemindersByOwner($ownerId: String!) {
    remindersByOwner(ownerId: $ownerId) {
      title
      dateTimeToRemind
      id
      isCompleted
    }
  }
''';

    final QueryOptions options = QueryOptions(
      document: gql(getRemindersByOwnerIdQuery),
      variables: <String, dynamic>{
        'ownerId': ownerId,
      },
    );
    final QueryResult result = await _graphQLClient.query(options);


    try {
      if (result.hasException) {
        // Handle GraphQL errors by throwing a custom exception
        throw GraphQLException(result.exception.toString());
        // You can also access specific error information like result.exception.graphqlErrors
      } else {
        final List<dynamic> remindersData = result.data?['remindersByOwner'];
        List<Reminder> reminders = [];
        for (final reminderData in remindersData) {
          print('Title: ${reminderData['title']}');
          print('Date Time to Remind: ${reminderData['dateTimeToRemind']}');
          print('ID: ${reminderData['id']}');
          print('Is Completed: ${reminderData['isCompleted']}');
          print('---');
          reminders.add(Reminder(id: reminderData['id'], title: reminderData['title'], isCompleted: reminderData['isCompleted'], dateTimeToRemind: DateTime.parse(reminderData['dateTimeToRemind'])));
        }
        return reminders;
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
  Future<List<Reminder?>?> getRemindersOfCurrentUser() async {
    // TODO: implement getRemindersOfCurrentUser

    const String getRemindersByOwnerIdQuery = r'''
  query MyReminders {
    myReminders {
        id
        title
        isCompleted
        dateTimeToRemind
    }
}
''';

    final QueryOptions options = QueryOptions(
      document: gql(getRemindersByOwnerIdQuery),
    );
    final QueryResult result = await _graphQLClient.query(options);


    try {
      if (result.hasException) {
        // Handle GraphQL errors by throwing a custom exception
        throw GraphQLException(result.exception.toString());
        // You can also access specific error information like result.exception.graphqlErrors
      } else {
        final List<dynamic> remindersData = result.data?['myReminders'];
        List<Reminder> reminders = [];
        for (final reminderData in remindersData) {
          print('Title: ${reminderData['title']}');
          print('Date Time to Remind: ${reminderData['dateTimeToRemind']}');
          print('ID: ${reminderData['id']}');
          print('Is Completed: ${reminderData['isCompleted']}');
          print('---');
          reminders.add(Reminder(id: reminderData['id'], title: reminderData['title'], isCompleted: reminderData['isCompleted'], dateTimeToRemind: DateTime.parse(reminderData['dateTimeToRemind'])));
        }
        return reminders;
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