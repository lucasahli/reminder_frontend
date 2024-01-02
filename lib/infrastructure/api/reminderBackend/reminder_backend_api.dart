import 'package:graphql/client.dart';
import 'package:reminder_frontend/core/components/reminderContext/domain/entities/reminder.dart';
import 'package:reminder_frontend/core/components/reminderContext/domain/entities/sign_in_result.dart';
import 'package:reminder_frontend/core/ports/outputPorts/authentication_api.dart';
import 'package:reminder_frontend/core/ports/outputPorts/secure_storage.dart';

import '../../../core/components/reminderContext/application/services/authentication_service.dart';
import '../../../core/components/reminderContext/domain/entities/refresh_access_result.dart';
import '../../../core/components/reminderContext/domain/entities/user.dart';
import '../../../core/ports/outputPorts/reminder_api.dart';
import 'graphql_exception.dart';

class ReminderBackendApi implements ReminderApi {
  late final GraphQLClient _graphQLClient;
  late final AuthenticationService _authenticationService;

  ReminderBackendApi(this._authenticationService) {
    final AuthLink authLink = AuthLink(
        getToken: _authenticationService.getAccessToken,
        // Specify how to get and format your bearer token.
        headerKey: 'Authorization');

    final AuthLink authLinkSessionId = AuthLink(
        getToken: () async => _authenticationService.sessionId,
        // Specify how to get and format your bearer token.
        headerKey: 'sessionId');

    // final HttpLink httpLink = HttpLink('http://34.105.53.4:4000/graphql');

    final HttpLink httpLink = HttpLink('http://127.0.0.1:4000/graphql',
        defaultHeaders: {"lucaHeader": "1"});
    // final HttpLink httpLink = HttpLink('http://192.168.1.13:4000/graphql');

    // final HttpLinkHeaders headers = HttpLinkHeaders()
    final Link link = authLink.concat(authLinkSessionId).concat(httpLink);
    _graphQLClient = GraphQLClient(cache: GraphQLCache(), link: link);
  }

  @override
  Future<List<Reminder?>> getRemindersByOwnerId(String ownerId) async {
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
        final List<dynamic>? remindersData = result.data?['remindersByOwner'];
        if (remindersData == null) {
          return [];
        }
        List<Reminder?> reminders = [];
        for (final reminderData in remindersData) {
          print('Title: ${reminderData['title']}');
          print('Date Time to Remind: ${reminderData['dateTimeToRemind']}');
          print('ID: ${reminderData['id']}');
          print('Is Completed: ${reminderData['isCompleted']}');
          print('---');
          reminders.add(Reminder(
              id: reminderData['id'],
              title: reminderData['title'],
              isCompleted: reminderData['isCompleted'],
              dateTimeToRemind:
                  DateTime.parse(reminderData['dateTimeToRemind'])));
        }
        return reminders;
      }
    } catch (error) {
      if (error is GraphQLException) {
        // Handle custom GraphQL exceptions
        return [];
      } else {
        // Handle network errors or other exceptions
        print('An error occurred: $error');
        return [];
      }
    }
  }

  @override
  Future<List<Reminder?>> getRemindersOfCurrentUser() async {
    const String getRemindersByOwnerIdQuery = r'''
  query MyReminders {
    myReminders {
        id
        created
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
        final List<dynamic>? myRemindersData = result.data?['myReminders'];
        if (myRemindersData == null) {
          return [];
        }
        List<Reminder?> reminders = [];
        for (final reminderData in myRemindersData) {
          reminders.add(Reminder(
              id: reminderData['id'],
              created: DateTime.parse(reminderData['created']),
              title: reminderData['title'],
              isCompleted: reminderData['isCompleted'],
              dateTimeToRemind:
                  DateTime.parse(reminderData['dateTimeToRemind'])));
        }
        return reminders;
      }
    } catch (error) {
      if (error is GraphQLException) {
        // Handle custom GraphQL exceptions
        return [];
      } else {
        // Handle network errors or other exceptions
        print('An error occurred: $error');
        return [];
      }
    }
  }

  @override
  Future<Reminder?> createReminder(
      String title, DateTime dateTimeToRemind) async {
    String dateTimeIso = dateTimeToRemind.toIso8601String();
    const String getRemindersByOwnerIdQuery = '''
  mutation CreateReminder(\$title: String!, \$dateTimeToRemind: DateTime!) {
    createReminder(title: \$title, dateTimeToRemind: \$dateTimeToRemind) {
        __typename
        ... on CreateReminderSuccess {
            createdReminder {
                id
                title
                dateTimeToRemind
                isCompleted
            }
        }
        ... on CreateReminderProblem {
            title
            invalidInputs {
                field
                message
            }
        }
    }
}
''';

    final MutationOptions options = MutationOptions(
      document: gql(getRemindersByOwnerIdQuery),
      variables: {
        'title': title,
        'dateTimeToRemind': dateTimeIso,
      },
    );
    final QueryResult result = await _graphQLClient.mutate(options);

    try {
      if (result.hasException) {
        print('worked not');
        // Handle GraphQL errors by throwing a custom exception
        throw GraphQLException(result.exception.toString());
        // You can also access specific error information like result.exception.graphqlErrors
      } else {
        print('worked');
        var reminderData = result.data?['createReminder']['createdReminder'];
        return Reminder(
            id: reminderData['id'],
            title: reminderData['title'],
            isCompleted: reminderData['isCompleted'],
            dateTimeToRemind: DateTime.parse(reminderData['dateTimeToRemind']));
      }
    } catch (error) {
      if (error is GraphQLException) {
        // Handle custom GraphQL exceptions
        print(error.toString());
        return null;
      } else {
        // Handle network errors or other exceptions
        print('An error occurred: $error');
        return null;
      }
    }
  }

  @override
  Future<Reminder?> getReminderDetails(String reminderId) async {
    const String graphqlRequest = r'''
  query Reminder($reminderId: ID!) {
    reminder(id: $reminderId) {
        id
        title
        dateTimeToRemind
        owner {
            fullName
            id
        }
        usersToRemind {
            fullName
            id
        }
        isCompleted
    }
}
''';

    final QueryOptions options = QueryOptions(
      document: gql(graphqlRequest),
      variables: {
        'reminderId': reminderId,
      },
    );
    final QueryResult result = await _graphQLClient.query(options);

    try {
      if (result.hasException) {
        print('worked not to get ReminderDetails');
        // Handle GraphQL errors by throwing a custom exception
        throw GraphQLException(result.exception.toString());
        // You can also access specific error information like result.exception.graphqlErrors
      } else {
        print('worked to get ReminderDetails');
        var reminderData = result.data?['reminder'];
        List<User> users = [];
        for (final user in reminderData['usersToRemind']) {
          users.add(User(id: user['id'], fullName: user['fullName']));
        }
        return Reminder(
            id: reminderData['id'],
            title: reminderData['title'],
            isCompleted: reminderData['isCompleted'],
            dateTimeToRemind: DateTime.parse(reminderData['dateTimeToRemind']),
            owner: User(
                id: reminderData['owner']['id'],
                fullName: reminderData['owner']['fullName']),
            usersToRemind: users);
      }
    } catch (error) {
      if (error is GraphQLException) {
        // Handle custom GraphQL exceptions
        print(error.toString());
        return null;
      } else {
        // Handle network errors or other exceptions
        print('An error occurred: $error');
        return null;
      }
    }
  }

//   @override
//   Future<SignInResult> signIn(String email, String password) async {
//     final MutationOptions options = MutationOptions(
//       document: gql('''
//       mutation SignIn(\$email: String!, \$password: String!) {
//     signIn(email: \$email, password: \$password) {
//         __typename
//         ... on SignInSuccess {
//             sessionId
//             accessToken {
//                 token
//             }
//             refreshToken {
//                 expiration
//                 token
//             }
//         }
//         ... on SignInProblem {
//             title
//             invalidInputs {
//                 field
//                 message
//             }
//         }
//     }
// }
//         '''),
//       variables: {
//         'email': email,
//         'password': password,
//       },
//     );
//
//     try {
//       final QueryResult result = await _graphQLClient.mutate(options);
//
//       if (result.hasException) {
//         print("Failed sign in: ");
//         print(result.exception);
//
//         // Handle GraphQL errors by throwing a custom exception
//         throw GraphQLException(result.exception.toString());
//         // You can also access specific error information like result.exception.graphqlErrors
//       } else {
//         print("Successful graphQl request: ${result.data?['signIn']}");
//         // Handle successful sign-up
//         final data = result.data?['signIn'];
//         if (data['__typename'] == 'SignInSuccess') {
//           return SignInSuccess(data);
//         } else if (data['__typename'] == 'SignInProblem') {
//           return SignInProblem(data);
//         } else {
//           throw Exception("Coud not create SignInResult!!!");
//         }
//       }
//     } catch (error) {
//       if (error is GraphQLException) {
//         // Handle custom GraphQL exceptions
//         rethrow;
//       } else {
//         // Handle network errors or other exceptions
//         print('An error occurred: $error');
//         rethrow;
//       }
//     }
//   }
//
//   @override
//   Future<SignInResult?> signUp(
//       String email, String password, String fullName) async {
//     final MutationOptions options = MutationOptions(
//       document: gql('''
//           mutation SignUp(\$password: String!, \$email: String!, \$fullName: String!) {
//             signUp(password: \$password, email: \$email, fullName: \$fullName) {
//               __typename
//               ... on SignUpSuccess {
//                   sessionId
//                   accessToken {
//                       token
//                   }
//                   refreshToken {
//                       id
//                       created
//                       modified
//                       token
//                       expiration
//                       revoked
//                       associatedLoginId
//                       associatedDeviceId
//                   }
//               }
//               ... on SignUpProblem {
//                   title
//                   invalidInputs {
//                       field
//                       message
//                   }
//               }
//             }
//           }
//         '''),
//       variables: {
//         'email': email,
//         'password': password,
//         'fullName': fullName,
//       },
//     );
//
//     try {
//       final QueryResult result = await _graphQLClient.mutate(options);
//
//       if (result.hasException) {
//         // Handle GraphQL errors by throwing a custom exception
//         throw GraphQLException(result.exception.toString());
//         // You can also access specific error information like result.exception.graphqlErrors
//       } else {
//         // Handle successful sign-up
//         print("Successful graphQl request: ${result.data?['signUp']}");
//         // Handle successful sign-up
//         final data = result.data?['signUp'];
//         if (data['__typename'] == 'SignUpSuccess') {
//           return SignInSuccess(data);
//         } else if (data['__typename'] == 'SignUpProblem') {
//           return SignInProblem(data);
//         } else {
//           throw Exception("Coud not create SignUpResult!!!");
//         }
//       }
//     } catch (error) {
//       if (error is GraphQLException) {
//         // Handle custom GraphQL exceptions
//         return null;
//       } else {
//         // Handle network errors or other exceptions
//         print('An error occurred: $error');
//         return null;
//       }
//     }
//   }
//
//   @override
//   Future<RefreshAccessResult> refreshAccess(String refreshTokenString) async {
//     final MutationOptions options = MutationOptions(
//       document: gql('''
//       mutation RefreshAccess(\$refreshToken: String!) {
//     refreshAccess(refreshToken: \$refreshTokenString) {
//         __typename
//         ... on RefreshAccessSuccess {
//             sessionId
//             accessToken {
//                 token
//             }
//             refreshToken {
//                 expiration
//                 token
//             }
//         }
//         ... on RefreshAccessProblem {
//             message
//         }
//     }
// }
//         '''),
//       variables: {
//         'refreshToken': refreshTokenString,
//       },
//     );
//
//     try {
//       final QueryResult result = await _graphQLClient.mutate(options);
//
//       if (result.hasException) {
//         print("Failed refresh Access: ");
//         print(result.exception);
//
//         // Handle GraphQL errors by throwing a custom exception
//         throw GraphQLException(result.exception.toString());
//         // You can also access specific error information like result.exception.graphqlErrors
//       } else {
//         print("Successful graphQl request: ${result.data?['refreshAccess']}");
//         // Handle successful sign-up
//         final data = result.data?['refreshAccess'];
//         if (data['__typename'] == 'RefreshAccessSuccess') {
//           return RefreshAccessSuccess(data);
//         } else if (data['__typename'] == 'RefreshAccessProblem') {
//           return RefreshAccessProblem(data);
//         } else {
//           throw Exception("Coud not create RefreshAccessResult!!!");
//         }
//       }
//     } catch (error) {
//       if (error is GraphQLException) {
//         // Handle custom GraphQL exceptions
//         rethrow;
//       } else {
//         // Handle network errors or other exceptions
//         print('An error occurred: $error');
//         rethrow;
//       }
//     }
//   }
}
