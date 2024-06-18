import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return Scaffold();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'Admin',
          builder: (BuildContext context, GoRouterState state) {
            return Scaffold();
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
            return Scaffold();
          },
        ),
      ],
    ),
  ],
);
