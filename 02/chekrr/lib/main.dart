import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '/screens/HomeScreen.dart';
import '/screens/add_task.dart';
import '/screens/settings.dart';
import '/screens/history.dart';
import '/screens/profile.dart';
import '/screens/challenge.dart';
import '/screens/challenges.dart';
import '/screens/login.dart';
import '/screens/loading_screen.dart';

void main() async {
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoadingScreen(),
      theme: ThemeData.dark(),
      getPages: [
        GetPage(
          name: '/',
          page: () => HomeScreen(),
          transition: Transition.fade,
        ),
        GetPage(
          name: '/home',
          page: () => HomeScreen(),
          transition: Transition.fade,
        ),
        GetPage(
          name: '/login',
          page: () => LoginPage(),
          transition: Transition.fade,
        ),
        GetPage(
          name: '/loading',
          page: () => LoadingScreen(),
          transition: Transition.fade,
        ),
        GetPage(
          name: '/add_task',
          page: () => AddTaskScreen(),
          transition: Transition.downToUp,
        ),
        GetPage(
          name: '/profile',
          page: () => ProfileScreen(),
          transition: Transition.upToDown,
        ),
        GetPage(
          name: '/challenge',
          page: () => ChallengeScreen(),
          transition: Transition.circularReveal,
        ),
        GetPage(
          name: '/challenges',
          page: () => ChallengesScreen(),
          transition: Transition.fade,
        ),
        GetPage(
          name: '/history',
          page: () => HistoryScreen(),
          transition: Transition.downToUp,
        ),
        GetPage(
          name: '/settings',
          page: () => SettingsScreen(),
          transition: Transition.downToUp,
        ),
      ],
    );
  }
}
