import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'globals.dart' as globals;
import 'loading_screen.dart';
import 'login.dart';
import 'home.dart';
import 'myplan.dart';
import 'add_task.dart';
import 'profile.dart';
import 'settings.dart';
import 'challenges.dart';

//import 'profile.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      initialRoute: '/',
      routes: {
        //'/': (context) => LoadingScreen(),
        '/': (context) => LoginPage(),
        '/login': (context) => LoginPage(),
        '/home': (context) => HomeScreen(),
        '/myplan': (context) => MyPlanScreen(),
        '/add_task': (context) => AddTaskScreen(),
        '/profile': (context) => ProfileScreen(),
        '/settings': (context) => SettingsScreen(),
        '/challenges': (context) => ChallengesScreen(),
      },
    );
  }
}
