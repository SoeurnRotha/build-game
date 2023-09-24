import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/painting.dart';
import 'package:my_fist_game/components/player.dart';
import 'package:my_fist_game/components/level.dart';

class PixelAdventure extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks {
  @override
  Color backgroundColor() => const Color(0XFF211F30);
  late final CameraComponent cameraComponent;
  Player player = Player(charator: 'Ninja Frog');
  late JoystickComponent joystickComponent;
  bool isShowJoyStick = false;

  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages();
    final world = Level(
      levelName: 'Level-02',
      player: player,
    );
    cameraComponent = CameraComponent.withFixedResolution(
      world: world,
      width: 640,
      height: 360,
    );
    cameraComponent.viewfinder.anchor = Anchor.topLeft;

    addAll([cameraComponent, world]);
    if (isShowJoyStick) {
      addJoyStick();
    }
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (isShowJoyStick) {
      updateJoyStick();
    }
    super.update(dt);
  }

  void addJoyStick() {
    joystickComponent = JoystickComponent(
      knob: SpriteComponent(
        sprite: Sprite(
          images.fromCache('HUD/Knob.png'),
        ),
      ),
      background: SpriteComponent(
        sprite: Sprite(
          images.fromCache('HUD/Joystick.png'),
        ),
      ),
      margin: EdgeInsets.only(
        left: 32,
        bottom: 32,
      ),
    );

    add(joystickComponent);
  }

  void updateJoyStick() {
    switch (joystickComponent.direction) {
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        player.playerDecrotion = PlayerDecrotion.left;
        break;
      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
        player.playerDecrotion = PlayerDecrotion.right;
        break;
      default:
        player.playerDecrotion = PlayerDecrotion.none;
        break;
    }
  }
}
