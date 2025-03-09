import 'dart:async';
import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flappy_bird/constans.dart';
import 'package:flappy_bird/game.dart';

class Pipe extends SpriteComponent
    with CollisionCallbacks, HasGameRef<FlappyBird> {
  final bool isTopPipe;
  bool scored = false;
  double heightChangeSpeed = 60; // Ustun uzunligi o'zgarish tezligi
  double minHeight = 50;
  double maxHeight;
  bool movingDown = true; // Yo'nalish

  Pipe(Vector2 position, Vector2 size, {required this.isTopPipe})
      : maxHeight = size.y,
        super(
          position: position,
          size: size,
        );

  @override
  FutureOr<void> onLoad() async {
    sprite = await Sprite.load(isTopPipe ? 'pipe.png' : 'pipe-green.png');
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    if (!scored && position.x + size.x < gameRef.bird.position.x) {
      scored = true;
      if (isTopPipe) {
        gameRef.incrementScore();
      }
    }

    if (movingDown) {
      if (isTopPipe) {
        size.y += heightChangeSpeed * dt; // Yuqori pipe pastga harakat qiladi
        if (size.y > maxHeight) {
          size.y = maxHeight;
          movingDown = false; // Yo‘nalishni o‘zgartirish
        }
      } else {
        double newHeight = size.y - heightChangeSpeed * dt;
        if (newHeight > minHeight) {
          position.y += heightChangeSpeed * dt; // Faqat yuqori chizig‘ini harakatlantirish
          size.y = newHeight;
        } else {
          size.y = minHeight;
          movingDown = false; // Yo‘nalishni o‘zgartirish
        }
      }
    } else {
      if (isTopPipe) {
        size.y += heightChangeSpeed * dt; // Yuqori pipe tepaga harakat qiladi
        if (size.y < minHeight) {
          size.y = minHeight;
          movingDown = true; // Yo‘nalishni o‘zgartirish
        }
      } else {
        double newHeight = size.y + heightChangeSpeed * dt;
        if (newHeight < maxHeight) {
          position.y -= heightChangeSpeed * dt; // Faqat yuqori chizig‘ini harakatlantirish
          size.y = newHeight;
        } else {
          size.y = maxHeight;
          movingDown = true; // Yo‘nalishni o‘zgartirish
        }
      }
    }

    position.x -= groundScroolingSpeed * dt;
    if (position.x + size.x <= 0) {
      removeFromParent();
    }
  }
}
