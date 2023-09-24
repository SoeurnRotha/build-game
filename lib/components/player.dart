import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/src/services/keyboard_key.g.dart';
import 'package:flutter/src/services/raw_keyboard.dart';
import 'package:my_fist_game/plxel_adventure.dart';

enum PlayerState { idle, running }

enum PlayerDecrotion { left, right, none }

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure>, KeyboardHandler {
  final String charator;
  Player({position, required this.charator}) : super(position: position);

  late final SpriteAnimation idelAnimation;
  late final SpriteAnimation runningAnimation;
  final double stepTime = 0.05;

  //controll player
  double moveSpeed = 100;
  PlayerDecrotion playerDecrotion = PlayerDecrotion.none;
  Vector2 velocity = Vector2.zero();
  bool isFactingRight = true;

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final isLeftKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isRightKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);

    if (isLeftKeyPressed && isRightKeyPressed) {
      playerDecrotion = PlayerDecrotion.none;
    } else if (isLeftKeyPressed) {
      playerDecrotion = PlayerDecrotion.left;
    } else if (isRightKeyPressed) {
      playerDecrotion = PlayerDecrotion.right;
    } else {
      playerDecrotion = PlayerDecrotion.none;
    }
    return super.onKeyEvent(event, keysPressed);
  }

  //
  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updatePlayerMovement(dt);
    super.update(dt);
  }

  void _loadAllAnimations() {
    idelAnimation = _spriteAnimation(
      'Main Characters/$charator/Idle (32x32).png',
      11,
      32,
    );
    runningAnimation = _spriteAnimation(
      'Main Characters/$charator/Run (32x32).png',
      12,
      32,
    );

    // list of all animations
    animations = {
      PlayerState.idle: idelAnimation,
      PlayerState.running: runningAnimation,
    };

    // set current animation
    current = PlayerState.running;
  }

  SpriteAnimation _spriteAnimation(String fileName, int amount, double vector) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache(fileName),
      SpriteAnimationData.sequenced(
        //count amount from image
        amount: amount,
        //set time
        stepTime: stepTime,

        //32 is (32x32)
        textureSize: Vector2.all(vector),
      ),
    );
  }

  void _updatePlayerMovement(double dt) {
    double dirX = 0.0;
    switch (playerDecrotion) {
      case PlayerDecrotion.left:
        if (isFactingRight) {
          flipHorizontallyAroundCenter();
          isFactingRight = false;
        }
        current = PlayerState.running;
        dirX -= moveSpeed;
        break;
      case PlayerDecrotion.right:
        if (!isFactingRight) {
          flipHorizontallyAroundCenter();
          isFactingRight = true;
        }
        current = PlayerState.running;
        dirX += moveSpeed;
        break;
      case PlayerDecrotion.none:
        current = PlayerState.idle;
        break;
      default:
    }
    velocity = Vector2(dirX, 0.0);
    position += velocity * dt;
  }
}
