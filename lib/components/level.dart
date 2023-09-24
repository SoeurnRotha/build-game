import 'dart:async';

import 'package:flame/camera.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:my_fist_game/components/player.dart';

class Level extends World {
  String levelName;

  final Player player;

  Level({
    required this.levelName,
    required this.player,
  });
  late TiledComponent level;

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load('$levelName.tmx', Vector2.all(16));

    add(level);

    final spawnPointsLayer = level.tileMap.getLayer<ObjectGroup>('Swanp');

    for (final spawnPoint in spawnPointsLayer!.objects) {
      switch (spawnPoint.class_) {
        case 'Player':
          player.position = Vector2(
            spawnPoint.x,
            spawnPoint.y,
          );
          add(player);
          break;
        default:
        // break;
      }
    }
    // add(Player(charator: 'Mask Dude'));
    return super.onLoad();
  }
}
