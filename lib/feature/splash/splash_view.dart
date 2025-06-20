import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nsflutter/feature/splash/splash_view_model.dart';

class SplashView extends ConsumerStatefulWidget {
  const SplashView({super.key});

  @override
  ConsumerState<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends ConsumerState<SplashView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(splashViewModelProvider.notifier).mounted;
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(splashViewModelProvider);

    ref.listen(splashViewModelProvider, (previous, next) {
      if (!next.isLoading && next.error == null) {
        context.goNamed('webview');
      }
    });

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FlutterLogo(size: 100),
            const SizedBox(height: 24),
            if (state.isLoading)
              const CircularProgressIndicator()
            else if (state.error != null)
              Column(
                children: [
                  Text(
                    'Error: ${state.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      ref.read(splashViewModelProvider.notifier).navigateToWebView(GoRouter.of(context));
                    },
                    child: const Text('Continue to WebView'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}