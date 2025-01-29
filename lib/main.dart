import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tzd;
import 'package:timezone/timezone.dart' as tz;
import 'package:tot_tracker/di/injection_base.dart';
import 'package:tot_tracker/presentantion/home/baby_bloc/baby_event_cubit.dart';
import 'package:tot_tracker/presentantion/schedule/bloc/schedule_cubit.dart';
import 'package:tot_tracker/presentantion/summary/bloc/summary_bloc_cubit.dart';
import 'package:tot_tracker/presentantion/user/signin/bloc/auth_cubit.dart';
import 'package:tot_tracker/presentantion/user/signin/bloc/sign_in_ui_cubit.dart';
import 'package:tot_tracker/router/app_router.dart';
import 'package:tot_tracker/theme/theme_cubit.dart';

import 'firebase_options.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // ignore: avoid_print
  print('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    // ignore: avoid_print
    print(
        'notification action tapped with input: ${notificationResponse.input}');
  }
}

void onDidReceiveNotificationResponse(
    NotificationResponse notificationResponse) async {
  final String? payload = notificationResponse.payload;
  if (notificationResponse.payload != null) {
    debugPrint('notification payload: $payload');
  }
}

Future<void> initializeTimeZone() async {
  tzd.initializeTimeZones();
  final String timeZoneName = await FlutterNativeTimezone
      .getLocalTimezone(); // Get device's local time zone
  tz.setLocalLocation(tz.getLocation(timeZoneName)); // Set local time zone
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeTimeZone();
  const AndroidInitializationSettings androidInitSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const DarwinInitializationSettings iosInitializationSettings =
      DarwinInitializationSettings(
    requestAlertPermission: true, // Request permission to show alerts
    requestBadgePermission: true, // Request permission to show app badges
    requestSoundPermission: true, // Request permission to play sounds
  );
  const InitializationSettings initSettings = InitializationSettings(
      android: androidInitSettings, iOS: iosInitializationSettings);

  await flutterLocalNotificationsPlugin.initialize(
    initSettings,
    onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
  );

  setupDi();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    getIt<ThemeCubit>().setGenderBasedTheme(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<ThemeCubit>()..setGenderBasedTheme(context),
        ),
        BlocProvider(
          create: (_) => getIt<BabyEventCubit>(),
        ),
        BlocProvider(
          create: (_) => getIt<SummaryCubit>(),
        ),
        BlocProvider(
          create: (_) => getIt<ScheduleCubit>(),
        ),
        BlocProvider(
          create: (_) => getIt<AuthCubit>()..initialize(),
        ),
        BlocProvider(
          create: (_) => getIt<SignInUiCubit>(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeLoaded>(
        builder: (context, theme) {
          return MaterialApp.router(
            routerConfig: router,
            title: 'Baby Tracker',
            theme: theme.lightTheme,
            darkTheme: theme.darkTheme,
          );
        },
      ),
    );
  }
}

Future<void> handleEmailLink(String link) async {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? email = prefs.getString('email');

  if (email == null) {
    print('No email saved. Cannot authenticate.');
    return;
  }

  if (_auth.isSignInWithEmailLink(link)) {
    try {
      UserCredential userCredential = await _auth.signInWithEmailLink(
        email: email,
        emailLink: link,
      );
      print('Successfully signed in: ${userCredential.user}');
    } catch (e) {
      print('Error signing in with email link: $e');
    }
  } else {
    print('Invalid sign-in link.');
  }
}
