import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:qubic_wallet/di.dart';
import 'package:qubic_wallet/pages/auth/create_wallet.dart';
import 'package:qubic_wallet/pages/auth/sign_in.dart';
import 'package:qubic_wallet/pages/main/main_screen.dart';
import 'package:qubic_wallet/stores/application_store.dart';

CustomTransitionPage buildPageWithDefaultTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 300),
    reverseTransitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        FadeTransition(opacity: animation, child: child),
  );
}

Page<dynamic> Function(BuildContext, GoRouterState) defaultPageBuilder<T>(
        Widget child) =>
    (BuildContext context, GoRouterState state) {
      return buildPageWithDefaultTransition<T>(
        context: context,
        state: state,
        child: child,
      );
    };

bool isSignedIn() {
  ApplicationStore appStore = getIt<ApplicationStore>();
  if (appStore.isSignedIn) {
    return true;
  }
  return false;
}

// GoRouter configuration
final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/signIn',
      name: 'signIn',
      builder: (context, state) => const SignIn(),
      pageBuilder: defaultPageBuilder(const SignIn()),
    ),
    GoRoute(
      path: '/createWallet',
      name: 'createWallet',
      builder: (context, state) => const CreateWallet(),
      pageBuilder: defaultPageBuilder(const CreateWallet()),
    ),
    GoRoute(
      path: '/',
      name: 'mainScreen',
      builder: (context, state) => const MainScreen(),
      pageBuilder: defaultPageBuilder(const MainScreen()),
      redirect: (BuildContext context, GoRouterState state) {
        if (!isSignedIn()) {
          return '/signin';
        }
        return null;
      },
    ),
  ],
);
