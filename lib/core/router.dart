import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nsflutter/feature/splash/splash_view.dart';
import 'package:nsflutter/feature/webview/webview_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashView(),
      ),
      GoRoute(
        path: '/webview',
        name: 'webview',
        builder: (context, state) {
          final url = state.uri.queryParameters['url'] ?? 'https://www.google.com';
          return WebViewPage(url: url);
        },
      ),
    ],
  );
});