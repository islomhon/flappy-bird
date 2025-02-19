import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flappy_bird/constans.dart';

import '../game.dart';

class Ground extends SpriteComponent with HasGameRef<FlappyBird>, CollisionCallbacks {
  //init
  Ground() : super();

  //LOAD
  @override
  FutureOr<void> onLoad() async {
    size = Vector2(2 * gameRef.size.x, groundHeight);
    position = Vector2(0, gameRef.size.y - 160);
    sprite = await Sprite.load('base.png');
    add(RectangleHitbox());
  }

  //UPDATE every second
  @override
  void update(double dt) {
    // move geound left
    position.x -= groundScroolingSpeed * dt;
    //infinite scrol ground
    if(position.x + size.x / 2 <= 0){
      position.x = 0;
    }
  }

}
