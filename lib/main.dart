import 'dart:io';

import 'package:flappy_bird/constans.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flappy_bird/game.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int highScore = 0;

  @override
  void initState() {
    super.initState();
    loadHighScore();
  }

  Future<void> loadHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      highScore = prefs.getInt('highScore') ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StartScreen(highScore: highScore),
    );
  }
}

class StartScreen extends StatefulWidget {
  final int highScore;
  StartScreen({required this.highScore});
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  File? selectedBirdImage;

  void showLevelDialog(BuildContext context) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Select Level'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CupertinoDialogAction(
                onPressed: () {
                  pipeGap = 300;
                  piepInterval = 2.2;
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GameWidget(
                          game: FlappyBird(birdImage: selectedBirdImage)),
                    ),
                  );
                },
                child: Text('Easy'),
              ),
              CupertinoDialogAction(
                onPressed: () {
                  pipeGap = 250;
                  piepInterval = 2;
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GameWidget(
                          game: FlappyBird(birdImage: selectedBirdImage)),
                    ),
                  );
                },
                child: Text('Normal'),
              ),
              CupertinoDialogAction(
                onPressed: () {
                  pipeGap = 200;
                  piepInterval = 1;
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GameWidget(
                          game: FlappyBird(birdImage: selectedBirdImage)),
                    ),
                  );
                },
                child: Text('Hard'),
              ),
              CupertinoDialogAction(
                onPressed: () async {
                  await pickBirdImage();
                  Navigator.pop(context);
                },
                child: Text("Select Bird Image"),
              ),
              if (selectedBirdImage != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                      Image.file(selectedBirdImage!, width: 100, height: 100),
                ),
            ],
          ),
        );
      },
    );
  }

  void showInformationDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text('Information'),
            content: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('High score:'),
                    Text(
                      ' ${widget.highScore}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'))
            ],
          );
        });
  }

  Future<void> pickBirdImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedBirdImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'assets/images/bakc.png',
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          showLevelDialog(context);
                        },
                        icon: Icon(
                          Icons.settings,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            showInformationDialog();
                          },
                          icon: Icon(
                            CupertinoIcons.info,
                            color: Colors.white,
                            size: 30,
                          )),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 120,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/name.png'),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 70),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GameWidget(
                                  game:
                                      FlappyBird(birdImage: selectedBirdImage)),
                            ),
                          );
                        },
                        child: Container(
                            width: 120,
                            child: Center(
                              child: Text(
                                'Start',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            )),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
