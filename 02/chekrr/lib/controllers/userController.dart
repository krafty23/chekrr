import 'package:get/get.dart';
import '../models/user.dart';

class UserController extends GetxController {
  final user = User().obs;

  updateUser(int uid) {
    //user().name = "Tadas";
    user().uid = uid;
  }
}
