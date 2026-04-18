import 'package:flutter/material.dart';
import 'package:flutter_ui_class/data/dummy_data.dart';
import 'package:flutter_ui_class/models/card_data_model.dart';
import 'package:flutter_ui_class/providers/task_management_provider.dart';
import 'package:flutter_ui_class/screens/add_task_page.dart';
import 'package:flutter_ui_class/widgets/task_card_widget.dart';
import 'package:provider/provider.dart';
import '../repositories/task_repository.dart'; 

class UiPage extends StatefulWidget {
  const UiPage({super.key});

  @override
  State<UiPage> createState() => _UiPageState();
}

class _UiPageState extends State<UiPage> {

  DummyData dummyDataInstance = DummyData();
  final TaskRepository _taskRepository = TaskRepository(); //

  @override
  Widget build(BuildContext context) {
    print("Building UI Page...");

    return Scaffold(
      appBar: AppBar(
        title: Text("UI PAGE"),
        backgroundColor: Colors.purpleAccent,
      ),
      body: StreamBuilder(
        stream: _taskRepository.getTasksStream(),
        builder: (context, firestoreSnapshot) {

          // Loading state
          if (firestoreSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // Error state
          if (firestoreSnapshot.hasError) {
            return Center(child: Text("Error: ${firestoreSnapshot.error}"));
          }

          final firestoreTasks = firestoreSnapshot.data ?? [];
          return Consumer<TaskManagementProvider>(
            builder: (context, taskProvider, _) {
              return RefreshIndicator(
                onRefresh: () async {
                  setState(() {});
                },
                child: ListView.builder(
                  padding: EdgeInsets.all(16),
                  // Firestore tasks count
                  itemCount: firestoreTasks.length,
                  itemBuilder: (context, index) {
                    // Firestore task data
                    final task = firestoreTasks[index];
                    return TaskCardWidget(
                      title: task.title,
                      subtitle: task.description,
                      // delete on tap
                      onTap: () async {
                        await _taskRepository.deleteTask(task.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Task deleted"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      },
                    );
                  },
                ),
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddTaskPage()));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.purpleAccent,
      ),
    );
  }
}