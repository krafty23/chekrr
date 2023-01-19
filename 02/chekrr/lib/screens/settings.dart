import "package:flutter/material.dart";

class SettingsScreen extends StatefulWidget {
  SettingsScreen({super.key, this.restorationId});
  @override
  final String? restorationId;
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Widget build(BuildContext context) {
    return Text('tst');
  }
}
