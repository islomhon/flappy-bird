import 'dart:async';
import 'dart:io';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flappy_bird/components/background.dart';
import 'package:flappy_bird/components/bird.dart';
import 'package:flappy_bird/components/ground.dart';
import 'package:flappy_bird/components/pipe_manager.dart';
import 'package:flappy_bird/components/score.dart';
import 'package:flappy_bird/constans.dart';
import 'package:flappy_bird/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flappy_bird/components/pipe.dart';

class FlappyBird extends FlameGame with TapDetector, HasCollisionDetection {
  late Bird bird;
  late Background background;
  late Ground ground;
  late PipeManager pipeManager;
  late ScoreText scoreText;
  final File? birdImage;

  FlappyBird({this.birdImage});

  @override
  FutureOr<void> onLoad() {
    // Orqa fonni yuklash
    background = Background(size);
    add(background);

    // Qushni yuklash (tanlangan rasm bilan)
    bird = Bird(birdImage: birdImage);
    add(bird);

    // Yerning texturasini yuklash
    ground = Ground();
    add(ground);

    // Trubalarni boshqarish
    pipeManager = PipeManager();
    add(pipeManager);

    // Hisob
    scoreText = ScoreText();
    add(scoreText);
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    // Qush ekranning yuqori qismiga tegsa ham o‘yin tugaydi
    if (bird.position.y <= 0) {
      gameOver();
    }
  }

  @override
  void onTap() {
    bird.flap();
  }

  int score = 0;
  void incrementScore() {
    score += 1;
  }

  // O'YIN TUGADI
  bool isGameOver = false;
  void gameOver() {
    if (isGameOver) return;
    isGameOver = true;
    pauseEngine();
    
    // Game Over Dialog
    showDialog(
      barrierDismissible: false,
      context: buildContext!,
      builder: (context) => CupertinoAlertDialog(
        title: Text('Game Over'),
        content: Text(
          'Score: $score',
          style: TextStyle(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              resetGame();
            },
            child: const Text('Restart'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => StartScreen(),
                ),
              );
            },
            child: Text('Home'),
          )
        ],
      ),
    );
  }

  void resetGame() {
    score = 0;
    bird.removeFromParent();
    bird = Bird(birdImage: birdImage); 
    add(bird);
    bird.position = Vector2(birdStartX, birdStartY);
    bird.velocity = 0;
    isGameOver = false;
    children.whereType<Pipe>().forEach((pipe) => pipe.removeFromParent());
    resumeEngine();
  }
}
