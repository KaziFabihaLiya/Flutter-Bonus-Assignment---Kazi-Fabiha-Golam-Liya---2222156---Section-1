import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task_model.dart';

class TaskRepository {
  // Reference to the 'tasks' collection in Firestore
  final CollectionReference _tasksCollection =
      FirebaseFirestore.instance.collection('tasks');

  // ➕ ADD TASK
  Future<void> addTask(Task task) async {
    await _tasksCollection.add(task.toFirestore());
  }

  // 🗑️ DELETE TASK
  Future<void> deleteTask(String taskId) async {
    await _tasksCollection.doc(taskId).delete();
  }

  // 📡 STREAM — real-time list of all tasks
  Stream<List<Task>> getTasksStream() {
    return _tasksCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Task.fromFirestore(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();
    });
  }
}