import 'package:go_router/go_router.dart';
import 'package:gain_to_do/presentation/views/main_navigation_view.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MainNavigationView(),
    ),
  ],
);
