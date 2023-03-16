

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

void main() {

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyAppHome(),
    );
  }
}

class MyAppHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppHomeState();
  }
}

class _MyAppHomeState extends State<MyAppHome> {
  int typedCharLength = 0;
  String lorem =
  '                          Lorem ipsum dolor sit amet consectetur adipiscing elit sed do eiusmod tempor incididunt ut labore et dolore magna aliqua Ut enim ad minim veniam quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'
      .toLowerCase()
      .replaceAll(',', '')
      .replaceAll('.', '');
  int step = 0;
  int score = 0;
  late int lastTypedAt;

  void updateLastTypedAt() {
    this.lastTypedAt = DateTime.now().millisecondsSinceEpoch;
  }

  void onType(String value) {
    updateLastTypedAt();
    String trimmedValue = lorem.trimLeft();

    setState(() {
      if (trimmedValue.indexOf(value) != 0)
        step = 2;
      else {
        typedCharLength = value.length;
      }
    });
  }

  void onStartClicked() {
    setState(() {
      updateLastTypedAt();
      step++;
    });
    var timer = Timer.periodic(new Duration(seconds: 1), (timer) {
      setState(() {
        if (step == 1) score++;
      });

      int now = DateTime.now().millisecondsSinceEpoch;

      setState(() {
        if (step == 1 && now - lastTypedAt > 5000) step++;

        if (step != 1) {
          timer.cancel();
        }
      });
    });
  }

  onAboutClicked() {
    setState(() {
      step = step + 3;
    });
  }

  @override
  Widget build(BuildContext context) {
    var shownWidget;
    if (step == 0) {
      shownWidget = <Widget>[
        Text(
          'Are you ready to escape from Lorem? ',
          style: CustomTextStyle.nameOfTextStyle,
        ),
        SizedBox(height: 20),
        Container(
            padding: const EdgeInsets.only(top: 10),
            child: ElevatedButton(
                onPressed: onStartClicked, child: Text("LET'S GO!"))),
        // SizedBox(
        //   height: 50,
        // ),

        SizedBox(
          height: 20,
        ),

        Container(
            padding: const EdgeInsets.only(top: 10),
            child: ElevatedButton(
              onPressed: onAboutClicked,
              child: Text(
                'About Game',
                style: TextStyle(fontSize: 11),
              ),
            )),
      ];
    } else if (step == 1) {
      shownWidget = <Widget>[
        Text(
          'Score :$typedCharLength',
          style: CustomTextStyle.nameOfTextStyle,
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          height: 70,
          child: Marquee(
            text: lorem,
            style: TextStyle(fontSize: 24, letterSpacing: 2),
            scrollAxis: Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.start,
            blankSpace: 20.0,
            velocity: 65,
            pauseAfterRound: Duration(seconds: 15),
            startPadding: 0,
            accelerationDuration: Duration(seconds: 15),
            accelerationCurve: Curves.ease,
            decelerationDuration: Duration(milliseconds: 500),
            decelerationCurve: Curves.easeOut,
          ),
        ),
        Container(
          child: Padding(
            padding: const EdgeInsets.only(top: 32, left: 16, right: 16),
            child: TextField(
              autofocus: true,
              onChanged: onType,
              autocorrect: false,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Write here',
              ),
            ),
          ),
        )
      ];
    } else if (step == 2) {
      shownWidget = <Widget>[
        Text(
          'Lorem caught you!',
          style: CustomTextStyle.nameOfTextStyle,
        ),
        SizedBox(height: 20),
        Text('Your Score : $typedCharLength',
            style: CustomTextStyle.nameOfTextStyle),
        SizedBox(height: 20),
        ElevatedButton(onPressed: resetGame, child: Text('Try Again')),
      ];
    } else if (step == 3) {
      shownWidget = <Widget>[
        Text(
          'About Game',
          style: CustomTextStyle.nameOfTextStyle,
        ),
        SizedBox(
          height: 20,
        ),
        Text('-Game Rules-'),
        SizedBox(
          height: 20,
        ),
        Container(
            margin: EdgeInsets.only(left: 70,right: 70),
            child: Text('Lorem ipsum paragraph is scrolling smoothly on the screen and you have to catch it.Remember, you lose the game with just one wrong word.')),
        SizedBox(height: 20),
        Text('Best of Luck!'),
        SizedBox(height: 50,),
        ElevatedButton.icon(
          onPressed: resetGame,
          icon: Icon(Icons.arrow_back),
          label: Text('Back'),
        ),
      ];
    }

    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Keyboard Driver'),
        ),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/lorem_bg.png'),
                fit: BoxFit.cover,
              )),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: shownWidget,
            ),
          ),
        ),
      ),
    );
  }

  void resetGame() {
    setState(() {
      typedCharLength = 0;
      step = 0;
    });
  }
}

class CustomTextStyle {
  static const TextStyle nameOfTextStyle = TextStyle(
    fontSize: 20,
    color: Colors.black,
    fontWeight: FontWeight.w500,
  );
}
