

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasky/Model/TaskModel.dart';


class Taskservice {
final FirebaseFirestore _firestore;
final FirebaseAuth _auth;
Taskservice(this._firestore,this._auth);

String? get _CurrentuserId=>_auth.currentUser?.uid;



Future<void> addTask(Task task)async{

if(_CurrentuserId==null) throw Exception('User not authenticated');


task.userId=_CurrentuserId!;
await _firestore.collection('tasks').add(task.toFirestore());


}

Stream<List<Task>> getTask({
    TaskPriority? filterPriority,
    bool? filterCompleted,
  }){
if(_CurrentuserId==null) return Stream.value([]);



Query query = 
    _firestore.collection('tasks').where('userId', isEqualTo: _CurrentuserId).
orderBy('dueDate',descending: false);


  if (filterPriority != null) {
      query = query.where('priority', isEqualTo: filterPriority.toString().split('.').last);
    }

    // Apply optional completion status filter directly in Firestore query
    if (filterCompleted != null) {
      query = query.where('isCompleted', isEqualTo: filterCompleted);
    }
return query.snapshots().map((snapshot){
return snapshot.docs.map((doc) => Task.fromFirestore(doc)).toList();
});



}


  Future<void> updateTask(Task task) async {
    if (task.id == null) {
      throw Exception('Task ID is null. Cannot update task.');
    }
    // Ensure the task belongs to the current user before updating (security rule check will also apply)
    final docRef = _firestore.collection('tasks').doc(task.id);
    final docSnapshot = await docRef.get();
    if (docSnapshot.exists && docSnapshot.data()?['userId'] == _CurrentuserId) {
      await docRef.update(task.toFirestore());
    } else {
      throw Exception('Task not found or does not belong to the current user.');
    }
  }

  // 4. Delete Task
  // Deletes a task document from Firestore.
  // Requires the task's ID.
  Future<void> deleteTask(String taskId) async {
    if (_CurrentuserId == null) {
      throw Exception('User not authenticated. Cannot delete task.');
    }
    // Ensure the task belongs to the current user before deleting
    final docRef = _firestore.collection('tasks').doc(taskId);
    final docSnapshot = await docRef.get();
    if (docSnapshot.exists && docSnapshot.data()?['userId'] == _CurrentuserId) {
      await docRef.delete();
    } else {
      throw Exception('Task not found or does not belong to the current user.');
    }
  }
}


final TaskserviceProvidre=Provider<Taskservice>((ref){
return Taskservice(FirebaseFirestore.instance,FirebaseAuth.instance);

  
});