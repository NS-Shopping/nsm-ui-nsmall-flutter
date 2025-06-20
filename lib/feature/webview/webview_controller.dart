import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final webViewControllerProvider = StateNotifierProvider.family<WebViewControllerNotifier, WebViewState, String>((ref, url) {
  return WebViewControllerNotifier(url);
});

class WebViewState {
  final bool isLoading;
  final double progress;
  final String? error;
  final String currentUrl;
  final bool canGoBack;
  final bool canGoForward;

  WebViewState({
    this.isLoading = true,
    this.progress = 0.0,
    this.error,
    required this.currentUrl,
    this.canGoBack = false,
    this.canGoForward = false,
  });

  WebViewState copyWith({
    bool? isLoading,
    double? progress,
    String? error,
    String? currentUrl,
    bool? canGoBack,
    bool? canGoForward,
  }) {
    return WebViewState(
      isLoading: isLoading ?? this.isLoading,
      progress: progress ?? this.progress,
      error: error ?? this.error,
      currentUrl: currentUrl ?? this.currentUrl,
      canGoBack: canGoBack ?? this.canGoBack,
      canGoForward: canGoForward ?? this.canGoForward,
    );
  }
}

class WebViewControllerNotifier extends StateNotifier<WebViewState> {
  InAppWebViewController? _webViewController;
  final String initialUrl;

  WebViewControllerNotifier(this.initialUrl) : super(WebViewState(currentUrl: initialUrl));

  void setWebViewController(InAppWebViewController controller) {
    _webViewController = controller;
  }

  void updateProgress(double progress) {
    state = state.copyWith(
      progress: progress,
      isLoading: progress < 1.0,
    );
  }

  void updateUrl(String url) {
    state = state.copyWith(currentUrl: url);
  }

  void updateNavigationState({bool? canGoBack, bool? canGoForward}) {
    state = state.copyWith(
      canGoBack: canGoBack ?? state.canGoBack,
      canGoForward: canGoForward ?? state.canGoForward,
    );
  }

  void setError(String? error) {
    state = state.copyWith(error: error, isLoading: false);
  }

  Future<void> reload() async {
    await _webViewController?.reload();
  }

  Future<void> goBack() async {
    if (state.canGoBack) {
      await _webViewController?.goBack();
    }
  }

  Future<void> goForward() async {
    if (state.canGoForward) {
      await _webViewController?.goForward();
    }
  }

  Future<void> loadUrl(String url) async {
    await _webViewController?.loadUrl(
      urlRequest: URLRequest(url: WebUri(url)),
    );
  }
}