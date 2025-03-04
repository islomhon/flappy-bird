import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flappy_bird/components/ground.dart';
import 'package:flutter/painting.dart';
import 'package:flappy_bird/constans.dart';
import 'package:flappy_bird/game.dart';
import 'package:flappy_bird/components/pipe.dart';
class Bird extends SpriteComponent with CollisionCallbacks {
  final File? birdImage;

  Bird({this.birdImage})
      : super(position: Vector2(birdStartX, birdStartY), size: Vector2(birdWidth, birdHeight));

  double velocity = 0;

  @override
  FutureOr<void> onLoad() async {
    if (birdImage != null) {
      final Uint8List bytes = await birdImage!.readAsBytes();
      final codec = await instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      sprite = Sprite(frame.image); // Foydalanuvchi rasmidan Sprite yaratish
    } else {
      sprite = await Sprite.load('bird.png'); // Standart rasm
    }
    add(RectangleHitbox());
  }

  void flap() {
    velocity = jumpStrength;
  }

  @override
  void update(double dt) {
    velocity += gravity * dt;
    position.y += velocity * dt;
  }

  @override
   void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    //check if bird collides with ground 
    if (other is Ground){
      (parent as FlappyBird ).gameOver();
    }

    //check if bird collides
    if(other is Pipe){
      (parent as FlappyBird).gameOver();
    }
  }
}
