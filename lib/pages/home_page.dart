import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/components/dialog_box.dart';
import 'package:todo_app/components/todo_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = TextEditingController();

  final _myBox = Hive.box('mybox');
  ToDoModel model = ToDoModel();

  @override
  void initState() {
    if (_myBox.get('TODOLIST') == null) {
      model.createInitialData();
    } else {
      model.loadData();
    }

    super.initState();
  }

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      model.toDoList[index][1] = !model.toDoList[index][1];
    });
    model.updateDatabase();
  }

  void saveNewTask() {
    if (_controller.text != '') {
      setState(() {
        model.toDoList.add([_controller.text, false]);
      });
      model.updateDatabase();
    }
    Navigator.pop(context);
    _controller.clear();
  }

  void createNewTask() {
    showDialog(
        context: context,
        builder: (context) {
          return DialogBox(
            controller: _controller,
            onSave: saveNewTask,
            onCancel: onCancel,
          );
        });
  }

  void deleteTask(int index) {
    setState(() {
      model.toDoList.removeAt(index);
    });

    model.updateDatabase();
  }

  void updateTask(int index, String taskName) {
    if (taskName != '') {
      setState(() {
        model.toDoList[index][0] = taskName;
      });
      model.updateDatabase();
    }
    Navigator.pop(context);
    _controller.clear();
  }

  void onCancel() {
    Navigator.pop(context);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.yellow[200],
          appBar: AppBar(
            title: const Center(child: Text('TO DO')),
            elevation: 1,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: createNewTask,
            child: const Icon(Icons.add),
          ),
          body: ListView.builder(
            itemCount: model.toDoList.length,
            itemBuilder: (context, index) {
              return ToDoTile(
                taskName: model.toDoList[index][0],
                taskCompleted: model.toDoList[index][1],
                onChanged: (value) => checkBoxChanged(value, index),
                deleteFunction: (context) => deleteTask(index),
                updateFunction: (context) {
                  _controller.text = model.toDoList[index][0];
                  showDialog(
                      context: context,
                      builder: (context) {
                        return DialogBox(
                          controller: _controller,
                          onSave: () => updateTask(index, _controller.text),
                          onCancel: onCancel,
                        );
                      });
                },
              );
            },
          )),
    );
  }
}
