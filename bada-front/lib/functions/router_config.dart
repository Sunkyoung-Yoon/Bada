// lib/config/router_config.dart
import 'package:bada/screens/main/loading_screen.dart';
import 'package:go_router/go_router.dart';

final routerConfig = GoRouter(
  routes: [
    GoRoute(
      path: '/loading',
      builder: (context, state) => const LoadingScreen(),
    ),
  ],
);
