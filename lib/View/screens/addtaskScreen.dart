
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tasky/Const/AppColor.dart';
import 'package:tasky/Const/TextStyle.dart';
import 'package:tasky/Model/TaskModel.dart';
import 'package:tasky/View/Buttons/Buttons.dart';
import 'package:tasky/ViewModel/HomeViewModel.dart';
import 'package:tasky/service/firebaseAuthService.dart';


class AddEditTaskScreen extends ConsumerStatefulWidget {
  final Task? task; // Null for add mode, Task object for edit mode

  const AddEditTaskScreen({super.key, this.task});

  @override
  ConsumerState<AddEditTaskScreen> createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends ConsumerState<AddEditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  DateTime? _selectedDueDate;
  TaskPriority _selectedPriority = TaskPriority.medium;
  List<String> _selectedTags = [];

  final List<String> _availableTags = ['Personal', 'Work', 'App', 'Study', 'Health', 'Finance'];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController = TextEditingController(text: widget.task?.description ?? '');
    _selectedDueDate = widget.task?.dueDate;
    _selectedPriority = widget.task?.priority ?? TaskPriority.medium;
    _selectedTags = List.from(widget.task?.tags ?? []); // Copy list
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)), // Allow past dates for editing
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (picked != null && picked != _selectedDueDate) {
      setState(() {
        _selectedDueDate = picked;
      });
    }
  }

  void _saveTask() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedDueDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a due date.')),
        );
        return;
      }

      final authService = ref.read(authserviceprovider);
      final currentUserId = authService.getCurrentUser()?.uid;

      if (currentUserId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not authenticated. Please log in again.')),
        );
        return;
      }

      final task = Task(
        id: widget.task?.id, // Will be null for new tasks, existing for edits
        title: _titleController.text,
        description: _descriptionController.text,
        dueDate: _selectedDueDate!,
        priority: _selectedPriority,
        isCompleted: widget.task?.isCompleted ?? false, // Preserve completion status on edit
        userId: currentUserId,
        tags: _selectedTags,
      );

      final homeViewModel = ref.read(homeViewModelProvider.notifier);

      if (widget.task == null) {
        // Add new task
        await homeViewModel.addTask(task);
        Navigator.of(context).pop();
      } else {
        // Edit existing task
        await homeViewModel.updateTask(task);
         Navigator.of(context).pop();
        
      }

      if (mounted) {
        Navigator.of(context).pop(); // Go back to Home Screen
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.task == null ? 'Add New Task' : 'Edit Task',
          style: const TextStyle(color: AppColors.white),
        ),
        backgroundColor: AppColors.primaryPurple,
        iconTheme: const IconThemeData(color: AppColors.white), // Back button color
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Task Title',
                style: AppTextStyles.inputLabel,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'e.g., Buy groceries',
                  filled: true,
                  fillColor: AppColors.lightGrey.withOpacity(0.3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Text(
                'Description',
                style: AppTextStyles.inputLabel,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'e.g., Milk, eggs, bread, fruits',
                  filled: true,
                  fillColor: AppColors.lightGrey.withOpacity(0.3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Due Date',
                style: AppTextStyles.inputLabel,
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => _selectDueDate(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedDueDate == null
                            ? 'Select Date'
                            : DateFormat('dd MMM yyyy').format(_selectedDueDate!),
                        style: AppTextStyles.bodyText.copyWith(
                          color: _selectedDueDate == null ? AppColors.darkGrey.withOpacity(0.6) : AppColors.darkGrey,
                        ),
                      ),
                      const Icon(Icons.calendar_today, color: AppColors.darkGrey),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Priority',
                style: AppTextStyles.inputLabel,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: AppColors.lightGrey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<TaskPriority>(
                    value: _selectedPriority,
                    isExpanded: true,
                    icon: const Icon(Icons.arrow_drop_down, color: AppColors.darkGrey),
                    style: AppTextStyles.bodyText,
                    onChanged: (TaskPriority? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedPriority = newValue;
                        });
                      }
                    },
                    items: TaskPriority.values.map((priority) {
                      return DropdownMenuItem(
                        value: priority,
                        child: Text(priority.toString().split('.').last.toUpperCase()),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Tags',
                style: AppTextStyles.inputLabel,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: _availableTags.map((tag) {
                  final isSelected = _selectedTags.contains(tag);
                  return FilterChip(
                    label: Text(tag),
                    selected: isSelected,
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected) {
                          _selectedTags.add(tag);
                        } else {
                          _selectedTags.remove(tag);
                        }
                      });
                    },
                    backgroundColor: AppColors.lightGrey.withOpacity(0.3),
                    selectedColor: AppColors.primaryPurple.withOpacity(0.2),
                    checkmarkColor: AppColors.primaryPurple,
                    labelStyle: AppTextStyles.bodyText.copyWith(
                      color: isSelected ? AppColors.primaryPurple : AppColors.darkGrey,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        color: isSelected ? AppColors.primaryPurple : Colors.transparent,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),
              CustomButton(
                text: widget.task == null ? 'Add Task' : 'Update Task',
                onPressed: _saveTask,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
