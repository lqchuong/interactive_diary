import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:interactive_diary/features/camera/camera_screen.dart';
import 'package:interactive_diary/features/camera/preview_screen.dart';
import 'package:interactive_diary/features/connectivity/no_connection_screen.dart';
import 'package:interactive_diary/features/diary_detail/diary_detail_screen.dart';
import 'package:interactive_diary/features/onboarding/onboarding_screen.dart';
import 'package:interactive_diary/features/splash/splash_screen.dart';
import 'package:interactive_diary/features/writediary/write_diary_screen.dart';
import 'package:interactive_diary/route/route_extra.dart';
import 'package:interactive_diary/features/camera/photo_album/photo_album_screen.dart';
import 'package:interactive_diary/features/home/home_screen.dart';

export 'package:go_router/go_router.dart';

part 'shell/media_shell.dart';

const String splash = '/';
const String idHomeRoute = '/home';
const String noConnectionRoute = '/noConnection';
const String writeDiaryRoute = '/writeDiary';
const String onboardingRoute = '/onboarding';
const String diaryDetailRoute = '/diaryDetailRoute';

final GoRouter appRoute = GoRouter(
  // main routes that can be accessed directly at app launch
  routes: <RouteBase>[
    // splash screen
    GoRoute(
        path: splash,
        builder: (BuildContext context, GoRouterState state) =>
            const SplashScreen()),
    // Home screen
    GoRoute(
      path: idHomeRoute,
      builder: (BuildContext context, GoRouterState state) {
        return const IDHome();
      },
    ),
    // write diary screen
    GoRoute(
        path: writeDiaryRoute,
        pageBuilder: (BuildContext context, GoRouterState state) {
          WriteDiaryExtra extra = state.extra as WriteDiaryExtra;
          return CustomTransitionPage<Offset>(
              child: WriteDiaryScreen(
                latLng: extra.latLng,
                address: extra.address,
                business: extra.business,
              ),
              transitionsBuilder: (BuildContext context,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation,
                      Widget child) =>
                  SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.0, 1.0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ));
        }),

    GoRoute(
        path: diaryDetailRoute,
        builder: (BuildContext context, GoRouterState state) {
          return const DiaryDetailScreen();
        }),

    // add other 1st level route
    //no connection screen
    GoRoute(
      path: noConnectionRoute,
      builder: (BuildContext context, GoRouterState state) {
        return const NoConnectionScreen();
      },
    ),
    // onboarding screens
    GoRoute(
      path: onboardingRoute,
      builder: (context, state) => OnboardingScreen(),
    ),
    GoRoute(
        path: addMediaRoute,
        pageBuilder: (_, GoRouterState state) => CustomTransitionPage<Offset>(
              key: state.pageKey,
              child: const CameraScreen(),
              transitionsBuilder: (_, animation, __, child) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.0, 1.0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
              },
            )),
    // add media shell
    addMediaShell,
  ],
);

CustomTransitionPage _bottomUpTransition(Widget child) =>
    CustomTransitionPage<Offset>(
      child: child,
      transitionsBuilder: (_, animation, __, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
    );