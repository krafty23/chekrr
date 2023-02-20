import 'package:flutter/material.dart';

class AchievementsScreen extends StatefulWidget {
  @override
  _AchievementsScreenState createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/chekrr_bg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Text('Tady budou odznaky'),
          ),
        ),
      ),
    );
  }
}
