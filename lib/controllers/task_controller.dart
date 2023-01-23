import 'package:get/get.dart';

import '../db/db_helper.dart';
import '../models/task.dart';


class TaskController extends GetxController {
  var taskList = <Task>[].obs;

  @override
  void onReady(){
    getTasks();
    super.onReady();
  }

  Future<int> addTask({Task task}) async {
    return await DBHelper.insert(task);
  }

  void getTasks() async {
    List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((data) => new Task.fromJson(data)).toList());
  }

  void delete(Task task) {
    DBHelper.delete(task);
    getTasks();
  }

  void markTaskCompleted(int id) async {
    await DBHelper.update(id);
    getTasks();
  }
}