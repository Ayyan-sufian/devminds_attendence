import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewState {
  final bool isPageReady;  // for splash navigation
  final bool isLoading;    // for overlay on every load
  final WebViewController controller;

  const WebViewState({
    required this.isPageReady,
    required this.isLoading,
    required this.controller,
  });

  WebViewState copyWith({bool? isPageReady, bool? isLoading}) {
    return WebViewState(
      isPageReady: isPageReady ?? this.isPageReady,
      isLoading: isLoading ?? this.isLoading,
      controller: controller,
    );
  }
}

class WebViewNotifier extends StateNotifier<WebViewState> {
  WebViewNotifier()
      : super(
    WebViewState(
      isPageReady: false,
      isLoading: true,
      controller: WebViewController(),
    ),
  ) {
    _initController();
  }

  void _initController() {
    state.controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFF714B67))
      ..loadRequest(
        Uri.parse("https://app.devmindsstudio.com/odoo/attendances"),
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            // Any navigation starts → show loading & block interaction
            state = state.copyWith(isLoading: true);
          },
          onPageFinished: (_) {
            state = state.copyWith(
              isLoading: false,
              isPageReady: true,
            );
          },
          onWebResourceError: (_) {
            // Hide loader even on error so app doesn't get stuck
            state = state.copyWith(isLoading: false);
          },
        ),
      );
  }

  Future<void> reloadPage() async {
    state = state.copyWith(isLoading: true, isPageReady: false);
    await state.controller.reload();
  }
}

final webViewProvider =
StateNotifierProvider<WebViewNotifier, WebViewState>((ref) {
  return WebViewNotifier();
});