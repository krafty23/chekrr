import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '/screens/HomeScreen.dart';
import '/screens/add_task.dart';

void main() async {
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
      theme: ThemeData.dark(),
      getPages: [
        GetPage(
          name: '/',
          page: () => HomeScreen(),
          transition: Transition.leftToRightWithFade,
        ),
        GetPage(
          name: '/add_task',
          page: () => AddTaskScreen(),
          transition: Transition.downToUp,
        ),
      ],
    );
  }
}
