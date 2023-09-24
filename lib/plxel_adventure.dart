import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/painting.dart';
import 'package:my_fist_game/lavel/level.dart';

class PixelAdventure extends FlameGame {
  @override
  Color backgroundColor() => const Color(0XFF211F30);

  late final CameraComponent cameraComponent;
  final world = Level(levelName: 'Level-02');

  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages();

    cameraComponent = CameraComponent.withFixedResolution(
      world: world,
      width: 640,
      height: 360,
    );
    cameraComponent.viewfinder.anchor = Anchor.topLeft;
    addAll([cameraComponent, world]);
    return super.onLoad();
  }
}
