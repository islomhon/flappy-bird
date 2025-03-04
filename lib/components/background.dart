import 'dart:async';
import 'package:flame/components.dart';

class Background extends SpriteComponent {
  bool isNight = false;

  Background(Vector2 size)
      : super(
          size: size,
          position: Vector2(0, 0),
        );

  @override
  FutureOr<void> onLoad() async {
    sprite = await Sprite.load('bakc.png');
  }

  Future<void> changeBackground() async {
    isNight = !isNight;
    sprite = await Sprite.load(
      isNight ? 'background-night.png' : 'bakc.png',
    );
  }
}
