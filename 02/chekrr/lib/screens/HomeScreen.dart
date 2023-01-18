import 'package:chekrr/screens/add_task.dart';
import "package:flutter/material.dart";
import 'package:get/get.dart';
import '../controllers/TaskController.dart';
import 'package:chekrr/drawer.dart';
import '../bottomtab.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TaskController taskController = Get.put(TaskController());
    return Scaffold(
      appBar: AppBar(
        title: Text("Můj Plán"),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey,
        child: Icon(Icons.add),
        onPressed: () {
          Get.toNamed('/add_task');
        },
      ),
      drawer: DrawerDraw(),
      body: Container(
        child: Obx(
          () => ListView.separated(
            separatorBuilder: (_, __) => Divider(),
            itemCount: taskController.tasks.length,
            itemBuilder: (context, index) => Dismissible(
              key: UniqueKey(),
              child: ListTile(
                title: Text(
                  taskController.tasks[index].name,
                  /*style: TextStyle(
                    color: Theme.of(context).textTheme.bodyText1.color,
                  ),*/
                ),
                onTap: () {
                  /*Get.to(AddTaskScreen(
                    index: index,
                  ));*/
                },
                leading: Checkbox(
                  value: true,
                  onChanged: (v) {
                    var changed = taskController.tasks[index];
                    //changed.status = v;
                    taskController.tasks[index] = changed;
                  },
                ),
                trailing: Icon(Icons.chevron_right),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomTabs(),
    );
  }
}
