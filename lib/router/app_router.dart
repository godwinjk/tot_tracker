import 'package:go_router/go_router.dart';
import 'package:tot_tracker/presentantion/baby_name/baby_name_screen.dart';
import 'package:tot_tracker/presentantion/due/when_due_screen.dart';
import 'package:tot_tracker/presentantion/gender/gender_selection_screen.dart';
import 'package:tot_tracker/presentantion/home/home_page.dart';
import 'package:tot_tracker/presentantion/profile/profile_page.dart';
import 'package:tot_tracker/presentantion/schedule/schedule_page.dart';
import 'package:tot_tracker/presentantion/signin/sign_in_screen.dart';
import 'package:tot_tracker/presentantion/summary/summary_page.dart';
import 'package:tot_tracker/router/route_path.dart';

import '../presentantion/landing/main_screen.dart';
import '../presentantion/splash/splash_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: RoutePath.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: RoutePath.gender,
      builder: (context, state) => const GenderSelectionScreen(),
    ),
    GoRoute(
      path: RoutePath.due,
      builder: (context, state) => const WhenAreDueScreen(),
    ),
    GoRoute(
      path: RoutePath.babyName,
      builder: (context, state) => const BabyNameScreen(),
    ),
    GoRoute(
      path: RoutePath.login,
      builder: (context, state) => const SignInPage(),
    ),
    ShellRoute(
        builder: (context, state, child) => MainScreen(
              child: child,
            ),
        routes: [
          GoRoute(
            path: RoutePath.home,
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: RoutePath.summary,
            builder: (context, state) => const SummaryPage(),
          ),
          GoRoute(
            path: RoutePath.schedule,
            builder: (context, state) => const SchedulePage(),
          ),
          GoRoute(
            path: RoutePath.profile,
            builder: (context, state) => const ProfilePage(),
          ),
        ])
  ],
);
