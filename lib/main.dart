import 'package:flutter/material.dart';
import 'package:odoo/screens/splash_screen.dart';
import 'package:odoo/screens/webview_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF714B67)),
      ),
      home: SplashScreen(),
    );
  }
}
