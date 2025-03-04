import 'dart:io';

import 'package:flappy_bird/constans.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flappy_bird/game.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StartScreen(),
    );
  }
}

class StartScreen extends StatefulWidget {
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
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GameWidget(game: FlappyBird(birdImage: selectedBirdImage)),
                    ),
                  );
                },
                child: Text('Easy'),
              ),
              CupertinoDialogAction(
                onPressed: () {
                  pipeGap = 250;
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GameWidget(game: FlappyBird(birdImage: selectedBirdImage)),
                    ),
                  );
                },
                child: Text('Normal'),
              ),
              CupertinoDialogAction(
                onPressed: () {
                  pipeGap = 200;
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GameWidget(game: FlappyBird(birdImage: selectedBirdImage)),
                    ),
                  );
                },
                child: Text('Hard'),
              ),
              CupertinoDialogAction(
                onPressed: pickBirdImage,
                child: Text("Select Bird Image"),
              ),
              if (selectedBirdImage != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.file(selectedBirdImage!, width: 100, height: 100),
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> pickBirdImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedBirdImage = File(pickedFile.path);
      });
    }
  }

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bakc.png'),
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
                child: IconButton(
                  onPressed: () {
                    showLevelDialog(context);
                  },
                  icon: Icon(
                    Icons.settings,
                    color: Colors.white,
                    size: 30,
                  ),
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
                padding: const EdgeInsets.only(bottom: 100),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GameWidget(game: FlappyBird(birdImage: selectedBirdImage)),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                        textStyle: TextStyle(fontSize: 30),
                      ),
                      child: Text('Start'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}