import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flappy_bird/components/ground.dart';
import 'package:flappy_bird/components/pipe.dart';
import 'package:flappy_bird/constans.dart';
import 'package:flappy_bird/game.dart';

class Bird extends SpriteComponent with CollisionCallbacks {
  Bird() : super(position: Vector2(birdStartX, birdStartY), size: Vector2(birdWidth, birdHeight));

  //physical world proprties
  double velocity = 0;


  //LOAD
  @override
  FutureOr<void> onLoad() async {
    sprite = await Sprite.load('bird.png');
    add(RectangleHitbox());
  }

  //JUMP & FLAP

  void flap() {
    velocity = jumpStrength;
  }

  //UPDATE EVERY SECOND
  @override
  void update(double dt) {
    //apply gravity
    velocity += gravity *dt;
    // update bird`s position on current velocity
    position.y += velocity *dt;

  }
  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    //check if bird collides with ground 
    if (other is Ground){
      (parent as FlappyBird).gameOver();
    }

    //check if bird collides
    if(other is Pipe){
      (parent as FlappyBird).gameOver();
    }
  }
}
