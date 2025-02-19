import 'dart:async';

import 'package:flame/components.dart';
import 'package:flappy_bird/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class ScoreText extends TextComponent with HasGameRef<FlappyBird> {
  //INIT
  ScoreText() : super(text: '0', textRenderer: TextPaint(
    style: TextStyle(color: Colors.grey.shade700, fontSize: 30  )
  ));

  //LOAD
  @override
  FutureOr<void> onLoad() {
    position = Vector2(
      (gameRef.size.x - size.x)/2,
      gameRef.size.y - size.y - 50,
    );
  }

  //UPDATE
  @override
  void update(double dt) {
    final newText = gameRef.score.toString();
    if(text != newText){
      text = newText; 
    }
  }

}
