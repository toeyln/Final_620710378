import 'dart:async';
import 'dart:io';
import 'package:final_620710378/model/game.dart';
import 'package:final_620710378/services/api.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {

  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<game>? quiz_list;
  int count = 0;
  int wrong_guess = 0;
  String message = "";

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  void _fetch() async {
    List list = await Api().fetch('quizzes');
    setState(() {
      quiz_list = list.map((item) => game.fromJson(item)).toList();
    });
  }

  void guess(String choice) {
    setState(() {
      if (quiz_list![count].choice_list[quiz_list![count].answer] == choice) {
        message = "เก่งมาก";
      } else {
        message = "ตอบผิด ตอบใหม่สิ";
      }
    });
    Timer timer = Timer(Duration(seconds: 2), () {
      setState(() {
        message = "";
        if (quiz_list![count].choice_list[quiz_list![count].answer] == choice) {
          count++;
        } else {
          wrong_guess++;
        }
      });
    });
  }

  Widget printGuess() {
    if (message.isEmpty) {
      return SizedBox(height: 20, width: 10);
    } else if (message == "เก่งมาก") {
      return Text(message);
    } else {
      return Text(message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: quiz_list != null && count < quiz_list!.length-1
          ? buildQuiz()
          : quiz_list != null && count == quiz_list!.length-1
          ? buildTryAgain()
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget buildTryAgain() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('End Game'),
            Text('ทายผิด ${wrong_guess} ครั้ง'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    wrong_guess = 0;
                    count = 0;
                    quiz_list = null;
                    _fetch();
                  });
                },
                child: Text('New Game'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding buildQuiz() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.network(quiz_list![count].image_url, fit: BoxFit.cover),
            Column(
              children: [
                for (int i = 0; i < quiz_list![count].choice_list.length; i++)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () =>
                                guess(quiz_list![count].choice_list[i].toString()),
                            child: Text(quiz_list![count].choice_list[i]),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            printGuess(),
          ],
        ),
      ),
    );
  }
}