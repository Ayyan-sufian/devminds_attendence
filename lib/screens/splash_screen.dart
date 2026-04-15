import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odoo/screens/webview_screen.dart';

import '../provider/webview_state.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool _timerDone = false;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();

    // Kick off background loading immediately
    ref.read(webViewProvider);

    // 3-second minimum splash
    Timer(const Duration(seconds: 3), () {
      _timerDone = true;
      _tryNavigate();
    });
  }

  void _tryNavigate() {
    final isPageReady = ref.read(webViewProvider).isPageReady;

    if (_timerDone && isPageReady && !_navigated) {
      _navigated = true;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WebviewScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen for page ready changes → try navigate
    ref.listen(webViewProvider, (previous, next) {
      if (next.isPageReady) _tryNavigate();
    });

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Image.asset("assets/img/devminds_logo.png"),
        ),
      ),
    );
  }
}