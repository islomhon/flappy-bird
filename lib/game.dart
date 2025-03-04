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
import 'package:shared_preferences/shared_preferences.dart';

class FlappyBird extends FlameGame with TapDetector, HasCollisionDetection {
  late Bird bird;
  late Background background;
  late Ground ground;
  late PipeManager pipeManager;
  late ScoreText scoreText;
  final File? birdImage;
  bool backgroundChanged = false; 
  int score = 0;
  int highScore = 0;
  bool isGameOver = false;

  FlappyBird({this.birdImage});

  @override
  FutureOr<void> onLoad() async {
    background = Background(size);
    add(background);

    bird = Bird(birdImage: birdImage);
    add(bird);

    ground = Ground();
    add(ground);

    pipeManager = PipeManager();
    add(pipeManager);

    scoreText = ScoreText();
    add(scoreText);

    await loadHighScore();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (bird.position.y <= 0) {
      gameOver();
    }

    // Har 50 ta score yig‘ilganda fonni o‘zgartirish
      if (score >= 50 && !backgroundChanged) {
    background.changeBackground();
    backgroundChanged = true;
  }
  }

  @override
  void onTap() {
    bird.flap();
  }

  void incrementScore() {
    score += 1;
    if (score > highScore) {
      highScore = score;
      saveHighScore();
    }
  }

  void gameOver() {
    if (isGameOver) return;
    isGameOver = true;
    pauseEngine();

    showDialog(
      barrierDismissible: false,
      context: buildContext!,
      builder: (context) => CupertinoAlertDialog(
        title: Text('Game Over'),
        content: Text(
          'Score: $score\nHigh Score: $highScore',
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
                  builder: (context) => StartScreen(highScore: highScore),
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

  Future<void> saveHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('highScore', highScore);
  }

  Future<void> loadHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    highScore = prefs.getInt('highScore') ?? 0;
  }
}
