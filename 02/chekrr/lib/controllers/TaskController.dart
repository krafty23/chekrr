import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/task.dart';

class TaskController extends GetxController {
  var tasks = <Task>[].obs;

  @override
  void onInit() {
    List? storedTasks = GetStorage().read<List>('tasks');

    if (!storedTasks.isNull) {
      tasks = storedTasks!.map((e) => Task.fromJson(e)).toList().obs;
    }
    ever(tasks, (_) {
      GetStorage().write('tasks', tasks.toList());
    });
    super.onInit();
  }

  //void checkDay(bool monday) => isChecked = monday;
}
