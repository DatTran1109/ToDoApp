import 'package:hive_flutter/hive_flutter.dart';

class ToDoModel {
  List toDoList = [];

  final _mybox = Hive.box('mybox');

  void createInitialData() {
    toDoList = [
      ['Learn Flutter', false],
      ['Play gamne', false]
    ];
  }

  void loadData() {
    toDoList = _mybox.get('TODOLIST');
  }

  void updateDatabase() {
    _mybox.put('TODOLIST', toDoList);
  }
}
