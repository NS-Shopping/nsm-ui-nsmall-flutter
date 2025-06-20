import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nsflutter/feature/webview/webview_controller.dart';

class WebViewPage extends ConsumerWidget {
  final String url;

  const WebViewPage({
    super.key,
    required this.url,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(webViewControllerProvider(url));
    final controller = ref.read(webViewControllerProvider(url).notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(state.currentUrl),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.reload(),
          ),
        ],
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri(url)),
            initialSettings: InAppWebViewSettings(
              useShouldOverrideUrlLoading: true,
              mediaPlaybackRequiresUserGesture: false,
              allowsInlineMediaPlayback: true,
              iframeAllow: "camera; microphone",
              iframeAllowFullscreen: true,
            ),
            onWebViewCreated: (webViewController) {
              controller.setWebViewController(webViewController);
            },
            onLoadStart: (webViewController, url) {
              controller.updateUrl(url.toString());
            },
            onLoadStop: (webViewController, url) async {
              controller.updateUrl(url.toString());
              final canGoBack = await webViewController.canGoBack();
              final canGoForward = await webViewController.canGoForward();
              controller.updateNavigationState(
                canGoBack: canGoBack,
                canGoForward: canGoForward,
              );
            },
            onProgressChanged: (webViewController, progress) {
              controller.updateProgress(progress / 100.0);
            },
            onReceivedError: (webViewController, request, error) {
              controller.setError(error.description);
            },
            shouldOverrideUrlLoading: (webViewController, navigationAction) async {
              return NavigationActionPolicy.ALLOW;
            },
          ),
          if (state.isLoading)
            LinearProgressIndicator(
              value: state.progress,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
            ),
          if (state.error != null)
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading page',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.error!,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => controller.reload(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: state.canGoBack ? () => controller.goBack() : null,
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: state.canGoForward ? () => controller.goForward() : null,
            ),
          ],
        ),
      ),
    );
  }
}