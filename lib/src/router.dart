import 'package:app/page/login.dart';
import 'package:app/page/registro.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return LoginScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'login',
          builder: (BuildContext context, GoRouterState state) {
            return LoginScreen();
          },
        ),
        GoRoute(
          path: 'Usuario',
          builder: (BuildContext context, GoRouterState state) {
            return const Scaffold();
          },
        ),
        GoRoute(
          path: 'Register',
          builder: (BuildContext context, GoRouterState state) {
            return RegisterScreen();
          },
        ),
      ],
    ),
  ],
);
