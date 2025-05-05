import 'dart:convert';

import 'package:flutter_application_1/app/model/task.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskRepository {
  Future<bool> addTask(Task task) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final jsonTasks = prefs.getStringList('tasks') ?? [];
    jsonTasks.add(jsonEncode(task.toJson()));
    return prefs.setStringList('tasks', jsonTasks);
  } //agregando codificando un new map con el api sharepreferences

  Future<List<Task>> getTasks() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final jsonTasks = prefs.getStringList('tasks') ?? [];
    return jsonTasks
        .map((jsonTask) => Task.fromJson(jsonDecode(jsonTask)))
        .toList();
  } //descodificando todo el map con el api sharepreferences

  Future<bool> saveTasks(List<Task> tasks) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final jsonTasks = tasks.map((e) => jsonEncode(e.toJson())).toList();
    return prefs.setStringList('tasks', jsonTasks);
  } // guarda to el array

  //creando la función future para borra tareas
  Future<bool> removeTaskByIndex(int index) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final jsonTasks = prefs.getStringList('tasks') ??
        []; //obtiene la lista guardada de tareas
    if (index < 0 || index >= jsonTasks.length) {
      //vefifica que el indice este dentro de rango
      return false;
    }
    jsonTasks.removeAt(index); //elimina esa tarea  en esa posición
    return prefs.setStringList('tasks', jsonTasks); //actualiza la lista
  }
}
