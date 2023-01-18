import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'globals.dart' as globals;
import 'loading_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'login.dart';
import 'home.dart';
import 'myplan.dart';
import 'add_task.dart';
import 'profile.dart';
import 'settings.dart';
import 'challenges.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();
//import 'profile.dart';
//void main() => runApp(MyApp());
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Counter()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
//class MyApp extends StatelessWidget {
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

class Counter with ChangeNotifier, DiagnosticableTreeMixin {
  int _count = 0;

  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }

  /// Makes `Counter` readable inside the devtools by listing all of its properties
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('count', count));
  }
}
