import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flappy_bird/components/ground.dart';
import 'package:flappy_bird/components/pipe.dart';
import 'package:flappy_bird/constans.dart';
import 'package:flappy_bird/game.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Bird extends SpriteComponent with CollisionCallbacks {
  File? birdImage;

  Bird({this.birdImage})
      : super(
          position: Vector2(birdStartX, birdStartY),
          size: Vector2(birdWidth, birdHeight));

  double velocity = 0;

  @override
  FutureOr<void> onLoad() async {
    final prefs = await SharedPreferences.getInstance();
    String? imagePath = prefs.getString('birdImagePath');

    if (birdImage != null) {
      await _setBirdImage(birdImage!.path);
    } else if (imagePath != null && File(imagePath).existsSync()) {
      birdImage = File(imagePath);
      await _setBirdImage(imagePath);
    } else {
      sprite = await Sprite.load('bird.png');
    }
    add(RectangleHitbox());
  }

  Future<void> _setBirdImage(String path) async {
    final Uint8List bytes = await File(path).readAsBytes();
    final codec = await instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    sprite = Sprite(frame.image);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('birdImagePath', path);
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
    if (other is Ground || other is Pipe) {
      (parent as FlappyBird).gameOver();
    }
  }
}
