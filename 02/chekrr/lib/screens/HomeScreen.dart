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
          () => ListView.builder(
            //separatorBuilder: (_, __) => Divider(),
            itemCount: taskController.tasks.length,
            itemBuilder: (context, index) => Dismissible(
              confirmDismiss: (direction) async {
                bool delete = true;
                if (direction == DismissDirection.startToEnd) {
                  /*setState(() {
                    flavors[index] =
                        flavor.copyWith(isFavorite: !flavor.isFavorite);
                  });*/
                  Get.showSnackbar(
                    GetSnackBar(
                      title: 'Gratulace!',
                      message: 'Výzva splněna',
                      icon: const Icon(
                        Icons.check,
                        color: Colors.green,
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                  return delete;
                } else {
                  bool delete = true;
                  Get.showSnackbar(
                    GetSnackBar(
                      title: 'Příště to vyjde!',
                      message: 'Výzva nesplněna',
                      icon: const Icon(
                        Icons.cancel,
                        color: Colors.red,
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                  return delete;
                }
              },
              onDismissed: (_) {
                Get.showSnackbar(
                  GetSnackBar(
                    title: 'Hovno!',
                    message: 'Ser na to',
                    icon: const Icon(
                      Icons.percent,
                      color: Colors.green,
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              background: Container(
                color: Colors.green,
                child: Align(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Icon(Icons.check_circle),
                  ),
                  alignment: Alignment.centerLeft,
                ),
              ),
              secondaryBackground: Container(
                color: Colors.red,
                child: Align(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Icon(Icons.cancel),
                  ),
                  alignment: Alignment.centerRight,
                ),
              ),
              key: UniqueKey(),
              child: ListTile(
                visualDensity: VisualDensity(vertical: 3),
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
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.chevron_left,
                      color: Colors.red,
                    ),
                  ],
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.chevron_right,
                      color: Colors.green,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomTabs(),
    );
  }
}
