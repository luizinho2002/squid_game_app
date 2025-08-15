import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import '../../constants/game_constants.dart';
import '../../models/game_state.dart';

class GameController extends ChangeNotifier {
  GameState _gameState = GameState.initial;
  GameState get gameState => _gameState;

  // Controllers
  late AnimationController _playerAnimationController;
  late AnimationController _dollRotationController;
  late ConfettiController _confettiController;

  // Timers
  Timer? _gameTimer;
  Timer? _lightChangeTimer;
  Timer? _gracePeriodTimer;
  Timer? _playerMoveTimer;

  // Random generator
  final Random _random = Random();

  // Initialize controllers
  void initialize(TickerProvider vsync) {
    _playerAnimationController = AnimationController(
      duration: const Duration(milliseconds: GameConstants.playerAnimationMs),
      vsync: vsync,
    );

    _dollRotationController = AnimationController(
      duration: const Duration(milliseconds: GameConstants.dollRotationMs),
      vsync: vsync,
    );

    _confettiController = ConfettiController(
      duration: const Duration(seconds: GameConstants.confettiDurationSec),
    );
  }

  // Getters for controllers
  AnimationController get playerAnimationController =>
      _playerAnimationController;
  AnimationController get dollRotationController => _dollRotationController;
  ConfettiController get confettiController => _confettiController;

  void startGame() {
    _updateGameState(
      _gameState.copyWith(
        status: GameStatus.playing,
        lightState: LightState.green,
        playerPosition: 0.0,
        remainingTime: GameConstants.gameDuration,
        isInGracePeriod: false,
      ),
    );

    // Start the game timer
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final newTime = _gameState.remainingTime - 1;

      if (newTime <= 0) {
        timer.cancel();
        _lightChangeTimer?.cancel();
        _updateGameState(_gameState.copyWith(status: GameStatus.gameOver));
      } else {
        _updateGameState(_gameState.copyWith(remainingTime: newTime));
      }
    });

    // Start light changes
    _changeLights();
  }

  void _changeLights() {
    // Random duration between min and max seconds
    final lightDuration =
        _random.nextInt(
          GameConstants.maxLightDuration - GameConstants.minLightDuration + 1,
        ) +
        GameConstants.minLightDuration;

    // Toggle light state
    final newLightState = _gameState.lightState == LightState.green
        ? LightState.red
        : LightState.green;

    _updateGameState(_gameState.copyWith(lightState: newLightState));

    // Handle doll rotation
    if (newLightState == LightState.green) {
      _dollRotationController.forward();
    } else {
      _dollRotationController.reverse();
      _startGracePeriod();
    }

    // Schedule next light change
    _lightChangeTimer = Timer(Duration(seconds: lightDuration), ()) {
      if (_gameState.isGameActive) {
        
      }
    };
  }
}
 