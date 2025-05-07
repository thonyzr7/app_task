import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/model/task.dart';
import 'package:flutter_application_1/app/repository/task_repository.dart';
import 'package:flutter_application_1/app/view/components/H1.dart';
import 'package:flutter_application_1/app/view/components/shape.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  /* final taskList = <Task>[
    Task('Sacar al perro'),
    Task('ir al GYM'),
    Task('hacer la compras'),
  ];*/

  final TaskRepository taskRepository =
      TaskRepository(); //instancia del repositorio de sincronizacion

  /*@override
  Future<void> initState() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    super.initState();
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _Header(),
          Expanded(
            child: FutureBuilder<List<Task>>(
              future: taskRepository
                  .getTasks(), //importante poner esto para que funcione la sincronización
              builder: (context, snapshot) {
                // context widget y snapshot objeto estado de conecion
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No hay tareas'),
                  );
                }
                return _TaskList(
                    //si pasa todo los if
                    snapshot.data!, //esto ya verifica el array creado
                    onTaskDoneChange: (task) {
                  //callback
                  taskRepository.saveTasks(
                      snapshot.data!); //guarda lista de tareas actualizadas
                  task.done = !task.done; //cambia el valor de done
                  setState(() {}); //actualiza pantalla
                },
                    //esto para que actualice la pantalla principal
                    deleteTask: (index) {
                  setState(() {
                    _deleteTask(index);
                  });
                });
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNewTaskModal(context), //modal
        child: const Icon(
          Icons.add,
          size: 50,
        ),
      ),
    );
  }

  // funcion modal
  void _showNewTaskModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true, //para controlar el fodo del modal
        backgroundColor: Colors.transparent,
        builder: (contex) {
          return DraggableScrollableSheet(
            initialChildSize: 0.65,
            minChildSize: 0.3,
            maxChildSize: 0.9,
            expand: false,
            builder: (context, scrollController) => Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                child: _NewTaskModal(
                  onTaskCreated: (Task task) {
                    taskRepository.addTask(task);
                    setState(() {});
                  },
                ),
              ),
            ),
          );
        });
  }

  //funcion para eliminar
  void _deleteTask(int index) {
    taskRepository.removeTaskByIndex(index);
  }
}

//aqui el widget modal
class _NewTaskModal extends StatelessWidget {
  _NewTaskModal({super.key, required this.onTaskCreated});

  final _controller = TextEditingController();

  final void Function(Task task) onTaskCreated;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 33, vertical: 23), // container tiene propiedad de padding

      //dato adicional para saber el decoration
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(21)),
        color: Colors.white,
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, //ajusta el tamaño el modal
        children: [
          H1('Nueva tarea'),
          const SizedBox(height: 26),
          TextField(
            controller:
                _controller, //importante par controlar el texto del textField
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              hintText: 'Descripción de la tarea',
            ),
          ),
          const SizedBox(height: 26),
          ElevatedButton(
              onPressed: () {
                // print(_controller.text);
                if (_controller.text.isNotEmpty) {
                  final task = Task(_controller.text);
                  onTaskCreated(task);
                  Navigator.of(context).pop(); //regresa al anterior pantalla
                }
              },
              child: const Text('Guardar')),
        ],
      ),
    );
  }
}

//factorizando _TaskList

class _TaskList extends StatefulWidget {
  const _TaskList(this.taskList,
      {super.key, required this.onTaskDoneChange, required this.deleteTask});
  final List<Task> taskList;
  final void Function(Task task) onTaskDoneChange;
  final void Function(int index) deleteTask;

  @override
  State<_TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<_TaskList> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const H1('Tareas'),
          Expanded(
            //espara bajar el escrol
            child: ListView.separated(
                itemCount: widget.taskList.length,
                separatorBuilder: (_, __) => const SizedBox(
                      height: 13,
                    ),
                itemBuilder: (_, i) => _TaskItem(
                      widget.taskList[i],
                      onTap: () => widget.onTaskDoneChange(widget.taskList[i]),
                      onDelete: () => widget.deleteTask(i),
                    )),
          ),
        ],
      ),
    );
  }
}

//factorizando _Header

class _Header extends StatelessWidget {
  const _Header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Theme.of(context).colorScheme.primary,
      child: Column(
        children: [
          const Row(children: [Shape()]),
          Column(
            children: [
              Image.asset(
                'assets/images/tasks-list-image.png',
                width: 120,
                height: 120,
              ),
              const SizedBox(
                height: 13,
              ),
              const H1('Completar tus tareas Anthony', color: Colors.white),
              const SizedBox(height: 24)
            ],
          )
        ],
      ),
    );
  }
}

//Factorizando el widget _TaskItem

class _TaskItem extends StatelessWidget {
  const _TaskItem(this.task, {super.key, this.onTap, required this.onDelete});

  final Task task;
  final VoidCallback? onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
          // el empacsulado es
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(21)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Row(
              //desde aca
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                          task.done //un IF ternario
                              ? Icons.check_box_rounded
                              : Icons.check_box_outline_blank,
                          color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          task.title,
                          softWrap: true,
                          maxLines: null,
                          overflow: TextOverflow.visible,
                          style: TextStyle(
                            //tachando letras
                            decoration: task.done
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                    onPressed: () {
                      _showDeleteConfirmationDialog(context);
                    },
                    icon: const Icon(Icons.close, color: Colors.red))
              ],
            ),
          )),
    );
  }

  //el modalcito de pregunta borrar
  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('confirmar'),
            content: const Text('¿Seguro que quiere borrar esta tarea?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onDelete();
                },
                child: const Text('Confirmar'),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancelar'))
            ],
          );
        });
  }
}
