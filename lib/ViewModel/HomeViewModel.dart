import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasky/Model/TaskModel.dart';
import 'package:tasky/service/TaskService.dart';


class HomeState {
  final AsyncValue<List<Task>> tasks;
  final String searchQuery;
  final TaskPriority? priorityFilter;
  final bool? completionFilter; // true for completed, false for incomplete, null for all

  HomeState({
    required this.tasks,
    this.searchQuery = '',
    this.priorityFilter,
    this.completionFilter,
  });

  // Helper to create a copy with updated values
  HomeState copyWith({
    AsyncValue<List<Task>>? tasks,
    String? searchQuery,
    TaskPriority? priorityFilter,
    bool? completionFilter,
  }) {
    return HomeState(
      tasks: tasks ?? this.tasks,
      searchQuery: searchQuery ?? this.searchQuery,
      priorityFilter: priorityFilter, // Allow null to reset filter
      completionFilter: completionFilter, // Allow null to reset filter
    );
  }
}


class HomeViewModel extends StateNotifier<HomeState> {
  final Taskservice _taskService; // Dependency on TaskService
  StreamSubscription? _tasksSubscription; // To manage the Firestore stream subscription

  // Constructor: takes TaskService and initialises state to loading
  HomeViewModel(this._taskService) : super(HomeState(tasks: const AsyncValue.loading())) {
    _listenToTasks(); // Start listening to the task stream immediately
  }

  // Dispose of the subscription when the ViewModel is disposed
  @override
  void dispose() {
    _tasksSubscription?.cancel();
    super.dispose();
  }

  // Private method to listen to the TaskService stream
  // This method is called whenever filters change, or initially.
  void _listenToTasks() {
    _tasksSubscription?.cancel(); // Cancel previous subscription to avoid duplicates

    // Fetch tasks from TaskService with current priority and completion filters
    _tasksSubscription = _taskService.getTask(
      filterPriority: state.priorityFilter,
      filterCompleted: state.completionFilter,
    ).listen(
      (allTasks) {
        // Apply search filter client-side on the fetched tasks
        final filteredTasks = allTasks.where((task) {
          final matchesSearch = state.searchQuery.isEmpty ||
              task.title.toLowerCase().contains(state.searchQuery.toLowerCase()) ||
              task.description.toLowerCase().contains(state.searchQuery.toLowerCase());
          return matchesSearch;
        }).toList();
        state = state.copyWith(tasks: AsyncValue.data(filteredTasks));
      },
      onError: (error, stackTrace) {
        state = state.copyWith(tasks: AsyncValue.error(error, stackTrace));
        print('Error fetching tasks: $error');
      },
    );
  }

  // Method to update the search query and re-apply client-side filter
  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    
    if (state.tasks.hasValue) {
    
      _listenToTasks();
    }
  }

 
  void setPriorityFilter(TaskPriority? priority) {
    state = state.copyWith(priorityFilter: priority);
    _listenToTasks(); // Re-fetch tasks from Firestore with new filter
  }

 
  void setCompletionFilter(bool? completed) {
    state = state.copyWith(completionFilter: completed);
    _listenToTasks(); // Re-fetch tasks from Firestore with new filter
  }

 
  Future<void> addTask(Task task) async {
    state = state.copyWith(tasks: const AsyncValue.loading()); // Show loading state
    try {
      await _taskService.addTask(task);
      // No need to manually update state here, as the stream listener will do it.
    } catch (e, st) {
      state = state.copyWith(tasks: AsyncValue.error(e, st)); // Set error state
      print('Error adding task: $e');
    }
  }

  // Method to update an existing task
  Future<void> updateTask(Task task) async {
    state = state.copyWith(tasks: const AsyncValue.loading()); // Show loading state
    try {
      await _taskService.updateTask(task);
      // No need to manually update state here, as the stream listener will do it.
    } catch (e, st) {
      state = state.copyWith(tasks: AsyncValue.error(e, st)); // Set error state
      print('Error updating task: $e');
    }
  }

  // Method to delete a task by its ID
  Future<void> deleteTask(String taskId) async {
    state = state.copyWith(tasks: const AsyncValue.loading()); // Show loading state
    try {
      await _taskService.deleteTask(taskId);
      // No need to manually update state here, as the stream listener will do it.
    } catch (e, st) {
      state = state.copyWith(tasks: AsyncValue.error(e, st)); // Set error state
      print('Error deleting task: $e');
    }
  }

  // Method to toggle the completion status of a task
  Future<void> toggleTaskCompletion(Task task) async {
    final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
    // Optimistic update: update UI immediately, then send to Firestore
    if (state.tasks.hasValue) {
      state = state.copyWith(
        tasks: AsyncValue.data(
          state.tasks.value!.map((t) => t.id == task.id ? updatedTask : t).toList(),
        ),
      );
    }
    try {
      await _taskService.updateTask(updatedTask);
    } catch (e, st) {
      // If update fails, revert the UI change and show error
      if (state.tasks.hasValue) {
        state = state.copyWith(
          tasks: AsyncValue.data(
            state.tasks.value!.map((t) => t.id == task.id ? task : t).toList(),
          ),
        );
      }
      state = state.copyWith(tasks: AsyncValue.error(e, st));
      print('Error toggling task completion: $e');
    }
  }
}

// Provider for the HomeViewModel
final homeViewModelProvider =
    StateNotifierProvider<HomeViewModel, HomeState>((ref) {
  // Get the TaskService instance from its provider
  final taskService = ref.watch(TaskserviceProvidre);
  return HomeViewModel(taskService);
});