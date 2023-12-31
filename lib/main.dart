import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:reminder_frontend/core/components/reminderContext/application/services/authentication_service.dart';
import 'package:reminder_frontend/core/components/reminderContext/application/services/reminder_api_service.dart';
import 'package:reminder_frontend/core/components/reminderContext/application/useCases/create_reminder_use_case_handler.dart';
import 'package:reminder_frontend/core/components/reminderContext/application/useCases/get_reminders_of_current_user_use_case_handler.dart';
import 'package:reminder_frontend/core/components/reminderContext/application/useCases/sign_in_use_case_handler.dart';
import 'package:reminder_frontend/core/ports/inputPorts/create_reminder_use_case.dart';
import 'package:reminder_frontend/core/ports/inputPorts/sign_in_use_case.dart';
import 'package:reminder_frontend/core/ports/outputPorts/authentication_api.dart';
import 'package:reminder_frontend/core/ports/outputPorts/reminder_api.dart';
import 'package:reminder_frontend/core/ports/outputPorts/secure_storage.dart';
import 'package:reminder_frontend/infrastructure/api/reminderBackend/reminder_backend_api.dart';
import 'package:reminder_frontend/infrastructure/secureStorage/flutterSecureStorage/flutter_storage.dart';
import 'package:reminder_frontend/presentation/screens/add_reminder_screen.dart';
import 'package:reminder_frontend/presentation/screens/reminder_detail_screen.dart';
import 'package:reminder_frontend/presentation/uiElements/loading_indicator.dart';
import 'core/components/reminderContext/application/useCases/get_reminder_details_use_case_handler.dart';
import 'core/ports/inputPorts/get_reminder_details_use_case.dart';
import 'core/ports/inputPorts/get_reminders_of_current_user_use_case.dart';
import 'infrastructure/api/authenticationBackend/authentication_backend_api.dart';
import 'presentation/screens/home.dart';
// Import the SignUpScreen
import 'presentation/screens/signin.dart'; // Import the SignInScreen
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  print("Handling a background message: ${message.messageId}");
}

Future<void> main() async {
  // Init everything Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseMessaging.instance.setAutoInitEnabled(true);

  // Permissions
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  print('User granted permission: ${settings.authorizationStatus}');

  // Background Message
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Foreground Message
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });

  String? fcmToken = "";
  if (DefaultFirebaseOptions.currentPlatform == DefaultFirebaseOptions.web) {
    print("WEB");
    // fcmToken = await messaging.getToken(
    //     vapidKey:
    //         "BAgLYWstjeqORyN5BhnEyxkdAqN95JYX_TI5oKiWin0oXM7m9yrQFa7zJY4ZVKqBEGp8WSOqvyGHrxDcJmkD748");
  } else {
    print("NOT WEB");
    fcmToken = await FirebaseMessaging.instance.getToken();
  }

  print("Registrierungstoken: $fcmToken");

  FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
    // TODO: If necessary send token to application server.
    print("NEW Registrierungstoken: $fcmToken");

    // Note: This callback is fired at each app startup and whenever a new
    // token is generated.
  }).onError((err) {
    // Error getting token.
    print("FirebaseMessaging.instance.onTokenRefresh.listen --> Error: $err");
  });

  runApp(
    /// Providers are above [MyApp] instead of inside it, so that tests
    /// can use [MyApp] while mocking the providers
    MultiProvider(
      providers: [
        // Provide the SecureStorage
        Provider<SecureStorage>(
          create: (_) => FlutterStorage(),
        ),
        // Provide the AuthenticationApi
        Provider<AuthenticationApi>(
          create: (context) {
            return AuthenticationBackendApi();
          },
        ),
        Provider<AuthenticationService>(
          create: (context) {
            final authenticationApi = context.read<AuthenticationApi>();
            final secureStorage = context.read<SecureStorage>();
            return AuthenticationService(authenticationApi, secureStorage);
          },
        ),
        // Provide the ReminderApi
        Provider<ReminderApi>(
          create: (context) {
            final authenticationService = context.read<AuthenticationService>();
            return ReminderBackendApi(authenticationService);
          },
        ),
        // Provide the ReminderApiService
        Provider<ReminderApiService>(
          create: (context) {
            final reminderApi = context.read<ReminderApi>();
            final authenticationService = context.read<AuthenticationService>();
            return ReminderApiService(reminderApi, authenticationService);
          },
        ),
        // Provide the SignInUseCase
        Provider<SignInUseCase>(
          create: (context) {
            final authenticationService = context.read<AuthenticationService>();
            return SignInUseCaseHandler(authenticationService);
          },
        ),
        // Provide the SignInUseCase
        Provider<GetRemindersOfCurrentUserUseCase>(
          create: (context) {
            final reminderApiService = context.read<ReminderApiService>();
            return GetRemindersOfCurrentUserUseCaseHandler(reminderApiService);
          },
        ),
        // Provide the CreateReminderUseCase
        Provider<CreateReminderUseCase>(
          create: (context) {
            final reminderApiService = context.read<ReminderApiService>();
            return CreateReminderUseCaseHandler(reminderApiService);
          },
        ),
        // GetReminderDetailsUseCase
        Provider<GetReminderDetailsUseCase>(
          create: (context) {
            final reminderApiService = context.read<ReminderApiService>();
            return GetReminderDetailsUseCaseHandler(reminderApiService);
          },
        ),
      ],
      child: const MyApp(),
    ),
  );
}

/// The route configuration.
final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return MyHomePage(context.read<GetRemindersOfCurrentUserUseCase>());
        },
        routes: <RouteBase>[
          // ReminderDetailScreen
          GoRoute(
            path: 'reminderDetail/:reminderId',
            name: 'reminderDetail',
            builder: (BuildContext context, GoRouterState state) {
              return ReminderDetailScreen(
                  context.read<GetReminderDetailsUseCase>(),
                  state.pathParameters['reminderId']!);
            },
          ),
          //addReminder
          GoRoute(
            path: 'addReminder',
            builder: (BuildContext context, GoRouterState state) {
              return AddReminderScreen(context.read<CreateReminderUseCase>());
            },
          ),
        ]),
    GoRoute(
      path: '/signIn',
      builder: (BuildContext context, GoRouterState state) {
        return SignInScreen(context.read<SignInUseCase>());
      },
    ),
  ],
  redirect: (context, state) async {
    print("REDIRECT, fullPath: ${state.fullPath}");
    final authenticationService = context.read<AuthenticationService>();
    if (!authenticationService.isAuthenticated) {
      print('REFRESHING...');
      await authenticationService.getAccessToken();
    }
    final bool isAuthenticated = authenticationService.isAuthenticated;

    // If trying to access a protected route and not authenticated, redirect to signIn
    final bool isGoingToSignIn = state.fullPath == '/signIn';
    if (!isAuthenticated && !isGoingToSignIn) {
      // Redirect to the sign-in page
      print("REDIRECT to signIn");
      return '/signIn';
    }

    // If the user is authenticated and is going to signIn, redirect to the home page
    if (isAuthenticated && isGoingToSignIn) {
      // Redirect to the home page or another appropriate page
      print("REDIRECT to /");
      return '/';
    }

    // No redirect needed
    print("REDIRECT not needed");
    return null;
  },
  // Define an error page
  // errorBuilder: (context, state) => ErrorScreen(error: state.error),
);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  ThemeData _buildTheme(brightness) {
    var seedColor = const Color.fromARGB(255, 0, 0, 0);
    var baseTheme = ThemeData(
      brightness: brightness,
      useMaterial3: true,
      // colorSchemeSeed: seedColor,
    );

    return baseTheme.copyWith(
        // textTheme: GoogleFonts.latoTextTheme(baseTheme.textTheme),
        // textTheme: GoogleFonts.robotoTextTheme(baseTheme.textTheme),
        );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp.router(
  //     title: 'Reminder',
  //     theme: _buildTheme(Brightness.dark),
  //     routerConfig: _router,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Call loadTokens and pass the secureStorage instance
      future: context.read<AuthenticationService>().loadTokensFromStorage(),
      builder: (context, snapshot) {
        // Check if the future is complete
        if (snapshot.connectionState == ConnectionState.done) {
          // If we have an error, we can handle it here, perhaps by showing an error message
          if (snapshot.hasError) {
            // return SomethingWentWrong();
          }

          // If the future completed successfully, build the rest of the UI
          return MaterialApp.router(
            title: 'Reminder',
            theme: _buildTheme(Brightness.dark),
            routerConfig: _router,
          );
        } else {
          // While waiting for the future to complete, show a loading spinner
          return LoadingIndicator();
        }
      },
    );
  }
}
