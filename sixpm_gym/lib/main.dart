import 'package:flutter/material.dart';

import 'View/welcome/signup.dart';
import 'View/welcome/welcome.dart';
import 'View/session/createSession.dart';
import 'View/session/joinSession.dart';
import 'View/session/sessionHistory.dart';
import 'View/profile/mySessions.dart';
import 'View/gym/gym.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/signup': (BuildContext context) => new SignupPage(),
        '/sessionHistory': (BuildContext context) => new SessionHistory(),
        '/mySessions': (BuildContext context) => new MySessions(),
        '/createSession': (BuildContext context) => new CreateSession(),
        '/joinSession': (BuildContext context) => new JoinSessionPage(),
        '/gympage': (BuildContext context) => new GymPage(storage: GymStorage()),
      },
      home: new WelcomePage(),
    );
  }
}
