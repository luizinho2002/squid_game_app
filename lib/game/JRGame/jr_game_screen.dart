import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';

import 'constants/jr_game_constants.dart';
import 'models/jr_game_state.dart';
import '../../screens/JRGame/jr_start_screen.dart';
import '../../screens/JRGame/jr_game_ui.dart';
import '../../screens/JRGame/jr_game_over_screen.dart';

class JRGameScreen extends StatefulWidget {
  const JRGameScreen({super.key});

  @override
  State<JRGameScreen> createState() => _JRGameScreenState();
}

class _JRGameScreenState extends State<JRGameScreen>
    with TickerProviderStateMixin {
  late JRGameScreen _gameState;

  // Animation Controllers
  late AnimationController _jumpController;
  late AnimationController _ropeController;
  late Animation<double> _jumpAnimation;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _initializeGameState();
    _initializeAnimations();
  }

  void _initializeGameState() {
    _gameState = JRGameState(
      onStateChanged: () {
        if (mounted) setState(() {});
      },
      onPlayerDeath: () {
        // Additional death handling if needed
      },
      onGameWon: () {
        _confettiController.play();
      },
    );
  }

  void _initializeAnimations() {
    // Jump animation
    _jumpController = AnimationController(
      duration: Duration(milliseconds: JRGameConstants._jumpAnimationMs),
      vsync: this,
    );

    _jumpAnimation = Tween<double>(begin: 0.0, end: -JRGameConstants.jumpHeight)
        .animate(
          CurvedAnimation(parent: _jumpController, curve: Curves.easeInOut),
        );

    // Rope animation
    _ropeController = AnimationController(
      duration: Duration(milliseconds: JRGameConstants.ropeAnimationMs),
    )..repeat();

    // Confetti
    _confettiController = ConfettiController(
      duration: Duration(seconds: JRGameConstants.confettiDurationSeconds),
    );

    // Animation listeners
    _jumpAnimation.addListener(() {
      _gameState.updateJumpOffset(_jumpAnimation.value);
    });

    _jumpController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _jumpController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _gameState.onJumpComplete();
      }
    });

    _ropeController.addListener(() {
      _gameState.updateRopeRotation(_ropeController.value * 2 * pi);
    });
  }

  void _startGame() {
    _gameState.startGame();
  }

  void _moverPlayerUp() {
    _gameState.movePlayer(true);
  }

  void _movePlayerDown() {
    _gameState.movePlayer(false);
  }

  void _jumpPlayer() {
    _gameState.jump();
    if (_gameState.isPlayerJumping) {
      _jumpController.forward();
    }
  }

  void _resetGame() {
    _gameState.resetGame();
    _confettiController.stop();
  }

  @override
  Widget build(BuildContext context) {
    // Check rope collision
    if (_gameState.isGameStarted && !_gameState.isPlayerDead && _gameState.isPlayerHittingRope(MediaQuery.of(context).size.width)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _gameState.playerDeath();
      });
    }

    return Scaffold(
      body: Stack(
        children: [
          // Background
          _buildBackground(),

          // Game Screens
          if (!_gameState.isGamesStarted && !_gameState.isGameOver)
              JRStartsScreen(onStartGame: _startGame),

         if (_gameState.isGamesStarted && !_gameState.isGameOver)
            JRStartScreen(onStartGame: _startGame),
          
          if (_gameState.isGamesStarted)
            JRGameUI(
              gameState: _gameState,
              onMoveUp: _moverPlayerUp,
              onMoveDown: _movePlayerDown,
              onJump: _jumpPlayer,
            ),

            if (_gameState.isGameOver)
        ],
      ),
    );
  }
}
