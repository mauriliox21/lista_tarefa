import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:convert';

class ToDoListPage extends StatefulWidget {
  ToDoListPage({Key? key, required this.selectedDate}) : super(key: key);

  final DateTime selectedDate;

  @override
  _ToDoListPageState createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<ToDoListPage> {
  DatabaseReference database = FirebaseDatabase.instance.ref();

  List<Task> tasks = [];
  String date = '';

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'To-Do List - ${widget.selectedDate.day.toString().padLeft(2, '0')}/${widget.selectedDate.month.toString().padLeft(2, '0')}/${widget.selectedDate.year}',
          style: TextStyle(
            color: Colors.white
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back, color:Colors.white),
        ),
        backgroundColor: Colors.transparent,
        actionsIconTheme: IconThemeData(color: Colors.white),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.black87,
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    tasks[index].name,
                    style: TextStyle(
                      decoration: tasks[index].isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      decorationColor: Colors.white,
                      color: Colors.white
                    ),
                  ),
                  leading: Icon(
                    tasks[index].isCompleted
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: tasks[index].isCompleted ? Colors.green : Colors.red,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.check, color: Colors.white,),
                        onPressed: () {
                          _toggleTaskCompletion(index);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.white,),
                        onPressed: () {
                          _removeTask(index);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: EdgeInsets.fromLTRB(30, 15, 30, 15)
                  ),
                  onPressed: () {
                    _showAddTaskDialog(context);
                  },
                  child: Text(
                    'Adicionar Tarefa', 
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: EdgeInsets.fromLTRB(30, 15, 30, 15)
                  ),
                  onPressed: () {
                    _showRemoveAllTasksDialog(context);
                  },
                  child: Text(
                    'Remover Todas', 
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _loadTasks() {
    date = '${widget.selectedDate.day.toString().padLeft(2, '0')}${widget.selectedDate.month.toString().padLeft(2, '0')}${widget.selectedDate.year}';

    database.child('calendar/$date').onValue.listen((event) {
      final dadosRecuperados = event.snapshot.value;

      if (dadosRecuperados != null) {
        Map<dynamic, dynamic> taskMap = dadosRecuperados as Map<dynamic, dynamic>;

        List<Task> tarefasCarregadas = [];

        taskMap.forEach((key, value) {
          var task = Task(
            name: value['name'],
            isCompleted: value['isCompleted'],
            idFirebase: key,
          );
          tarefasCarregadas.add(task);
        });

        setState(() {
          tasks = tarefasCarregadas;
        });
      }
    });
  }

  void _showAddTaskDialog(BuildContext context) {
    String newTaskName = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Adicionar Tarefa'),
          content: TextField(
            onChanged: (value) {
              newTaskName = value;
            },
            decoration: InputDecoration(hintText: 'Nome da Tarefa'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if(newTaskName.isNotEmpty) {
                  setState(() {
                    tasks.add(Task(name: newTaskName));
                    DatabaseReference ref = database.child('calendar/$date').push();
                    ref.set(tasks[tasks.length-1].toJson()).then((_) {
                      tasks[tasks.length-1].setIdFirebase(ref.key!);
                    });
                  });
                  Navigator.pop(context);
                }
              },
              child: Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }

  void _showRemoveAllTasksDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Remover todas as Tarefas'),
          content: Text('Tem certeza que deseja remover todas as tarefas?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  database.child('calendar/$date').remove();
                  tasks.clear();
                });
                Navigator.pop(context);
              },
              child: Text('Remover Todas'),
            ),
          ],
        );
      },
    );
  }

  void _toggleTaskCompletion(int index) {
    setState(() {
      tasks[index].isCompleted = !tasks[index].isCompleted;
      database.child('calendar/$date/${tasks[index].idFirebase}').update({
        'isCompleted': tasks[index].isCompleted,
      });
    });
  }

  void _removeTask(int index) {
    setState(() {
      database.child('calendar/$date/${tasks[index].idFirebase}').remove();
      tasks.removeAt(index);
    });
  }
}

class Task {
  String name;
  bool isCompleted;
  String idFirebase;

  Task({required this.name, this.isCompleted = false, this.idFirebase = ''});

  void setIdFirebase(id){
    idFirebase = id;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'isCompleted': isCompleted
    };
  }
}
