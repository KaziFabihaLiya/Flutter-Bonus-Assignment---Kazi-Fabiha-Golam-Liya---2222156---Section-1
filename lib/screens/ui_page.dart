import 'package:flutter/material.dart';
import 'package:flutter_ui_class/data/dummy_data.dart';
import 'package:flutter_ui_class/models/card_data_model.dart';
import 'package:flutter_ui_class/providers/task_management_provider.dart';
import 'package:flutter_ui_class/screens/add_task_page.dart';
import 'package:flutter_ui_class/widgets/task_card_widget.dart';
import 'package:provider/provider.dart';
import '../repositories/task_repository.dart'; // 🔥 ADDED

class UiPage extends StatefulWidget {
  const UiPage({super.key});

  @override
  State<UiPage> createState() => _UiPageState();
}

class _UiPageState extends State<UiPage> {

  DummyData dummyDataInstance = DummyData();
  final TaskRepository _taskRepository = TaskRepository(); // 🔥 ADDED

  @override
  Widget build(BuildContext context) {
    print("Building UI Page...");

    return Scaffold(
      appBar: AppBar(
        title: Text("UI PAGE"),
        backgroundColor: Colors.purpleAccent,
      ),

      // 🔥 MODIFIED: wrapped existing Consumer inside StreamBuilder for real-time Firestore
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

          // ✅ Existing Consumer kept exactly as is
          return Consumer<TaskManagementProvider>(
            builder: (context, taskProvider, _) {
              return RefreshIndicator(
                onRefresh: () async {
                  setState(() {});
                },
                child: ListView.builder(
                  padding: EdgeInsets.all(16),
                  // 🔥 MODIFIED: show Firestore tasks count
                  itemCount: firestoreTasks.length,
                  itemBuilder: (context, index) {
                    // 🔥 MODIFIED: use Firestore task data
                    final task = firestoreTasks[index];

                    // ✅ Existing TaskCardWidget kept exactly as is
                    return TaskCardWidget(
                      title: task.title,
                      subtitle: task.description,
                      // 🔥 ADDED: delete on tap
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

      // ✅ Existing FAB kept exactly as is
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