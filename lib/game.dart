import 'dart:async';
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
  //LOAD

  @override
  FutureOr<void> onLoad() {
    //load backround image
    background = Background(size);
    add(Background(size));
    // load bird
    bird = Bird();
    add(bird);
    //load ground
    ground = Ground();
    add(ground);
    //load pipes
    pipeManager = PipeManager();
    add(pipeManager);
    //load scores
    scoreText = ScoreText();
    add(scoreText);
  }

  //TAP
  @override
  void onTap() {
    bird.flap();
  }

  //SCORE

  int score = 0;

  void incrementScore() {
    score += 1;
  }

  //GAME OVER
  bool isGameOver = false;
  void gameOver() {
    if (isGameOver) return;
    isGameOver = true;
    pauseEngine();
    // Show Game Over Dialog
    showDialog(
      barrierDismissible: false,
      context: buildContext!,
      builder: (context) => CupertinoAlertDialog(
        title: Text('GameOver'),
        content: Text(
          'score: ${score}',
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
    bird.position = Vector2(birdStartX, birdStartY);
    bird.velocity = 0;
    isGameOver = false;
    children.whereType<Pipe>().forEach((pipe) => pipe.removeFromParent());
    resumeEngine();
  }
}
