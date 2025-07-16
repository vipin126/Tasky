import 'package:flutter/material.dart';

import 'package:tasky/Const/AppColor.dart';
import 'package:tasky/Model/TaskModel.dart';


import '../../Const/TextStyle.dart'; // Import Task model

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback? onToggleComplete;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const TaskCard({
    super.key,
    required this.task,
    this.onToggleComplete,
    this.onEdit,
    this.onDelete,
  });

  Color _getTagColor(String tag) {
    switch (tag.toLowerCase()) {
      case 'personal':
        return AppColors.tagOrange;
      case 'work':
        return AppColors.tagBlue;
      case 'app':
        return AppColors.tagGreen;
      default:
        return AppColors.tagGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.taskCardBackground,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.zero, // No external margin, handled by padding in list
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            // Checkbox/Radio button for completion
            GestureDetector(
              onTap: onToggleComplete,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: task.isCompleted ? AppColors.primaryPurple : AppColors.darkGrey,
                    width: 2,
                  ),
                  color: task.isCompleted ? AppColors.primaryPurple : Colors.transparent,
                ),
                child: task.isCompleted
                    ? const Icon(
                  Icons.check,
                  size: 16,
                  color: AppColors.white,
                )
                    : null,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: AppTextStyles.taskTitle.copyWith(
                      decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                      color: task.isCompleted ? AppColors.darkGrey.withOpacity(0.6) : AppColors.darkGrey,
                    ),
                  ),
                  // Placeholder for description or other details if needed
                ],
              ),
            ),
            // Tags (e.g., Personal, Work, App)
            Wrap(
              spacing: 8.0, // horizontal space between tags
              runSpacing: 4.0, // vertical space between lines of tags
              children: task.tags.map((tag) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getTagColor(tag).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  tag,
                  style: AppTextStyles.taskTag.copyWith(color: _getTagColor(tag)),
                ),
              )).toList(),
            ),
            
            if (onEdit != null || onDelete != null)
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: AppColors.darkGrey),
                onSelected: (value) {
                  if (value == 'edit' && onEdit != null) {
                    onEdit!();
                  } else if (value == 'delete' && onDelete != null) {
                    onDelete!();
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'edit',
                    child: Text('Edit'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'delete',
                    child: Text('Delete'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
