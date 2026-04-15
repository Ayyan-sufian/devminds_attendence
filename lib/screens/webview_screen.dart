import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../provider/webview_state.dart';

class WebviewScreen extends ConsumerWidget {
  const WebviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final webViewState = ref.watch(webViewProvider);
    final isLoading = webViewState.isLoading;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFF714B67),
        body: SafeArea(
          child: Stack(
            children: [

              // ── WebView + pull-to-refresh ──────────────────────────
              AbsorbPointer(
                // Blocks ALL taps/gestures on WebView while loading
                absorbing: isLoading,
                child: RefreshIndicator(
                  color: const Color(0xFF714B67),
                  onRefresh: () =>
                      ref.read(webViewProvider.notifier).reloadPage(),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height -
                          MediaQuery.of(context).padding.top,
                      child: WebViewWidget(
                        controller: webViewState.controller,
                      ),
                    ),
                  ),
                ),
              ),

              // ── Full-screen loading overlay ────────────────────────
              if (isLoading)
                Container(
                  color: const Color(0xFF714B67).withOpacity(0.85),
                  child: const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                        SizedBox(height: 16),
                        Text(
                          "Loading...",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}