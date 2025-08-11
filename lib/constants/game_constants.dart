class GameConstants {
  // Game timing
  static const int gameDuration = 30; // seconds
  static const int gracePeriodMs = 200; // milliseconds
  static const int minLightDuration = 1; // seconds
  static const int maxLightDuratio = 4; // seconds

  // Player movement
  static const double playerMoveStep = 0.18; // 5% per tap
  static const double finishLinePosition =
      1.8; // 120¢ to win (much higer, more challenging)

  // UI dimensions
  static const double playerSize = 50.0;
  static const double dollSize = 100.0;
  static const double guardSize = 60.0;
  static const double lightIndicatorSize = 80.0;
  static const double moveButtonHeight = 80.0;

  // Animation durations
  static const int playerAnimationsMs = 300;
  static const int dollRotationMs = 500;
  static const int confettiDurationSec = 3;
}
