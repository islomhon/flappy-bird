import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flappy_bird/constans.dart';
import 'package:flappy_bird/game.dart';

class Pipe extends SpriteComponent
    with CollisionCallbacks, HasGameRef<FlappyBird> {
  final bool isTopPipe;

  //score 
  bool scored = false;



  //init
  Pipe(Vector2 position, Vector2 size, {required this.isTopPipe})
      : super(
          position: position,
          size: size,
        );


  //LOAD
  @override
  FutureOr<void> onLoad() async {
    //load sprite image
    sprite = await Sprite.load(isTopPipe ? 'pipe.png' : 'pipe-green.png');
    //add hitbox
    add(RectangleHitbox());
  }
  

  //UPDATE
  @override
  void update(double dt) {
    // check if the bird has passed this pipe
    if(!scored && position.x + size.x < gameRef.bird.position.x){
      scored = true;
      if(isTopPipe){
        gameRef.incrementScore();
      }
    }
    //scrool pipe to left
    position.x -= groundScroolingSpeed * dt;
    //remove pipe
    if(position.x + size.x <= 0){
      removeFromParent();
    }
  }
}
