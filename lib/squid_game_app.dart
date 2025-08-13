import 'package:flutter/material.dart';

class SquidGameApp extends StatefulWidget {
  const SquidGameApp({super.key});

  @override
  State<SquidGameAppState> create() => _SquidGameAppState();
}

class _SquidGameAppState extends State<SquidGameApp> {
  bool _showSplash = true;

  void _onSplashComplete() {
    setState(() {
      _showSplash = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _showSplash
          ? SplashScreen(_onSplashComplete: _onSplashComplete)
          : const MenuScreen();
  }
}