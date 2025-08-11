import 'package:flutter/material.dart';
import 'screens/RGLight/splash_screen.dart';
import 'screens/menu_screen.dart';

class SquidGameApp extends StatefulWidget {
  const SquidGameApp({super.key});

  @override
  State<SquidGameApp> createState() => _SquidGameAppState();
}

class _SquidGameAppState extends State<SquidGameApp> {
  bool _showSplash = true;

  void _onSplashComplete() {
    setState(() {
      _showSplash = false;
    });
  }

  @override build(BuildContext context) {
    return _showSplash
        ? SplashScreen(onSplashComplete: _onSplashComplete)
        : const MenuScreen();
  }
}
