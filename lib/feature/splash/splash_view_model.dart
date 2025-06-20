import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nsflutter/core/provider/app_providers.dart';

final splashViewModelProvider = StateNotifierProvider<SplashViewModel, SplashState>((ref) {
  return SplashViewModel(ref);
});

class SplashState {
  final bool isLoading;
  final String? error;

  SplashState({
    this.isLoading = true,
    this.error,
  });

  SplashState copyWith({
    bool? isLoading,
    String? error,
  }) {
    return SplashState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class SplashViewModel extends StateNotifier<SplashState> {
  final Ref ref;

  SplashViewModel(this.ref) : super(SplashState()) {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      
      ref.read(appInitializedProvider.notifier).state = true;
      
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void navigateToWebView(GoRouter router) {
    router.goNamed('webview');
  }
}