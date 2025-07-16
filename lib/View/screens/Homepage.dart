import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tasky/Const/AppColor.dart';
import 'package:tasky/Const/TextStyle.dart';
import 'package:tasky/Model/TaskModel.dart';
import 'package:tasky/View/screens/LoginScreen.dart';
import 'package:tasky/View/screens/addtaskScreen.dart';
import 'package:tasky/View/widget/TaskCard.dart';
import 'package:tasky/ViewModel/AuthViewModel.dart';
import 'package:tasky/ViewModel/HomeViewModel.dart';




// class HomeScreen extends ConsumerWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // Optionally watch authState to react to user changes
//     final authState = ref.watch(authViewModelProvider);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'My Tasks',
//           style: TextStyle(color: AppColors.white),
//         ),
//         backgroundColor: AppColors.primaryPurple,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout, color: AppColors.white),
//             onPressed: () async {
//               await ref.read(authViewModelProvider.notifier).signOut();
//               // Navigation will be handled by MyApp's StreamBuilder
//             },
//           ),
//         ],
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Welcome to your Task Manager!',
//               style: AppTextStyles.authTitle.copyWith(color: AppColors.darkGrey),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 20),
//             Text(
//               'You are logged in as: ${authState.user?.email ?? 'Guest'}',
//               style: AppTextStyles.bodyText,
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 40),
//             // Placeholder for task list or other home screen content
//             const Icon(
//               Icons.task_alt,
//               size: 100,
//               color: AppColors.primaryPurple,
//             ),
//             const SizedBox(height: 20),
//             Text(
//               'Your tasks will appear here.',
//               style: AppTextStyles.onboardingSubtitle,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // TODO: Navigate to Add Task screen
//           print('Add new task');
//         },
//         backgroundColor: AppColors.primaryPurple,
//         child: const Icon(Icons.add, color: AppColors.white),
//       ),
//     );
//   }
// }

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});










List<Widget> _buildTaskCards(BuildContext context, WidgetRef ref, List<Task> tasks) {
    return tasks.map((task) => Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TaskCard(
        task: task,
        onToggleComplete: () {
          ref.read(homeViewModelProvider.notifier).toggleTaskCompletion(task);
        },
        onEdit: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddEditTaskScreen(task: task), // Pass task for edit mode
            ),
          );
        },
        onDelete: () {
          _showDeleteConfirmationDialog(context, ref, task);
        },
      ),
    )).toList();
  }

  // Dialog for delete confirmation
  void _showDeleteConfirmationDialog(BuildContext context, WidgetRef ref, Task task) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Delete Task'),
          content: Text('Are you sure you want to delete "${task.title}"?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('Delete', style: TextStyle(color: AppColors.red)),
              onPressed: () {
                ref.read(homeViewModelProvider.notifier).deleteTask(task.id!);
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }



  Map<String, List<Task>> _groupTasksByDate(List<Task> tasks) {
    final Map<String, List<Task>> grouped = {
      'today': [],
      'tomorrow': [],
      'this_week': [],
      'later': [],
    };

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final endOfThisWeek = today.add(const Duration(days: 7)); // Next 7 days from today

    for (var task in tasks) {
      final taskDate = DateTime(task.dueDate.year, task.dueDate.month, task.dueDate.day);
      if (taskDate.isAtSameMomentAs(today)) {
        grouped['today']!.add(task);
      } else if (taskDate.isAtSameMomentAs(tomorrow)) {
        grouped['tomorrow']!.add(task);
      } else if (taskDate.isAfter(tomorrow) && taskDate.isBefore(endOfThisWeek)) {
        grouped['this_week']!.add(task);
      } else {
        grouped['later']!.add(task);
      }
    }
    return grouped;
  }








  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the list of tasks from the HomeViewModel
    // final tasksAsyncValue = ref.watch(homeViewModelProvider);

    // // Get current date for display
     final String formattedDate = DateFormat('EEEE, d MMMM').format(DateTime.now());


final homeState=ref.watch(homeViewModelProvider);
final tasksAsyncValue=homeState.tasks;



    return Scaffold(
      backgroundColor: AppColors.lightPurpleBackground,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180.0, 
            floating: true,
            pinned: true,
            backgroundColor: AppColors.primaryPurple,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
          
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: const EdgeInsets.only(top: 40.0, left: 24.0, right: 24.0, bottom: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Placeholder for menu icon (88 icon)
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.apps, color: AppColors.white),
                        ),
                     
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Search',
                                  hintStyle: TextStyle(color: AppColors.white),
                                  prefixIcon: Icon(Icons.search, color: AppColors.white),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                                ),
                                style: TextStyle(color: AppColors.white),
                              onChanged: (query){
                  ref.read(homeViewModelProvider.notifier).setSearchQuery(query);

                              },
                              
                              ),
                            ),
                          ),
                        ),
                      
                        // Container(
                        //   width: 40,
                        //   height: 40,
                        //   decoration: BoxDecoration(
                        //     color: AppColors.white.withOpacity(0.2),
                        //     borderRadius: BorderRadius.circular(10),
                        //   ),
                        //   child: PopupMenuButton(
                        //     color: AppColors.lightGrey,
                        //     icon: Icon(Icons.more_horiz,color: Colors.white,),
                        //     itemBuilder:(BuildContext context) {

                        //       return [
                               
                        //         PopupMenuItem(
                        //           value: 'logout',
                        //           onTap: (){
                        //             ref.read(authViewModelProvider.notifier).signOut();
                        //             Navigator.of(context).pushReplacement(
                        //               MaterialPageRoute(
                        //                 builder: (context) => LoginScreen(),
                        //               ),
                        //             );
                        //           },
                        //           child: Text('Logout', style: AppTextStyles.bodyText.copyWith(color: Colors.red)),
                        //         ),
                        //       ];
                        //     },

                            
                        // ),)

                        PopupMenuButton<String>(
                          icon: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.filter_list, color: AppColors.white),
                          ),
                          onSelected: (value) {
                            final notifier = ref.read(homeViewModelProvider.notifier);
                            if (value == 'all_priority') {
                              notifier.setPriorityFilter(null);
                            } else if (value == 'low_priority') {
                              notifier.setPriorityFilter(TaskPriority.low);
                            } else if (value == 'medium_priority') {
                              notifier.setPriorityFilter(TaskPriority.medium);
                            } else if (value == 'high_priority') {
                              notifier.setPriorityFilter(TaskPriority.high);
                            } else if (value == 'all_status') {
                              notifier.setCompletionFilter(null);
                            } else if (value == 'completed_status') {
                              notifier.setCompletionFilter(true);
                            } else if (value == 'incomplete_status') {
                              notifier.setCompletionFilter(false);
                            }
                          },
                          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                            const PopupMenuItem<String>(
                              value: 'all_priority',
                              child: Text('All Priorities', style: AppTextStyles.filterOption),
                            ),
                            const PopupMenuItem<String>(
                              value: 'low_priority',
                              child: Text('Low Priority', style: AppTextStyles.filterOption),
                            ),
                            const PopupMenuItem<String>(
                              value: 'medium_priority',
                              child: Text('Medium Priority', style: AppTextStyles.filterOption),
                            ),
                            const PopupMenuItem<String>(
                              value: 'high_priority',
                              child: Text('High Priority', style: AppTextStyles.filterOption),
                            ),
                            const PopupMenuDivider(),
                            const PopupMenuItem<String>(
                              value: 'all_status',
                              child: Text('All Statuses', style: AppTextStyles.filterOption),
                            ),
                            const PopupMenuItem<String>(
                              value: 'completed_status',
                              child: Text('Completed', style: AppTextStyles.filterOption),
                            ),
                            const PopupMenuItem<String>(
                              value: 'incomplete_status',
                              child: Text('Incomplete', style: AppTextStyles.filterOption),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      formattedDate,
                      style: AppTextStyles.appBarDate,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'My tasks',
                      style: AppTextStyles.appBarTitle,
                    ),
                  ],
                ),
              ),
            ),
          ),
          // SliverPadding(
          //   padding: const EdgeInsets.all(24.0),
          //   sliver: SliverList(
          //     delegate: SliverChildListDelegate(
          //       [
          //         // Today's Tasks
          //         Text('Today', style: AppTextStyles.sectionHeader),
          //         const SizedBox(height: 16),
          //         // Loop through tasks and display them
          //         ...tasks?.where((task) => task.dueDate.day == DateTime.now().day && task.dueDate.month == DateTime.now().month && task.dueDate.year == DateTime.now().year)
          //             .map((task) => Padding(
          //           padding: const EdgeInsets.only(bottom: 12.0),
          //           child: TaskCard(task: task),
          //         )).toList(),
          //         const SizedBox(height: 24),

          //         // Tomorrow's Tasks
          //         Text('Tomorrow', style: AppTextStyles.sectionHeader),
          //         const SizedBox(height: 16),
          //         ...tasks.where((task) => task.dueDate.day == DateTime.now().add(const Duration(days: 1)).day && task.dueDate.month == DateTime.now().add(const Duration(days: 1)).month && task.dueDate.year == DateTime.now().add(const Duration(days: 1)).year)
          //             .map((task) => Padding(
          //           padding: const EdgeInsets.only(bottom: 12.0),
          //           child: TaskCard(task: task),
          //         )).toList(),
          //         const SizedBox(height: 24),

          //         // This Week's Tasks (beyond tomorrow, within 7 days)
          //         Text('This week', style: AppTextStyles.sectionHeader),
          //         const SizedBox(height: 16),
          //         ...tasks.where((task) {
          //           final now = DateTime.now();
          //           final tomorrow = now.add(const Duration(days: 1));
          //           final endOfWeek = now.add(const Duration(days: 7));
          //           return task.dueDate.isAfter(tomorrow) && task.dueDate.isBefore(endOfWeek);
          //         }).map((task) => Padding(
          //           padding: const EdgeInsets.only(bottom: 12.0),
          //           child: TaskCard(task: task),
          //         )).toList(),
          //         const SizedBox(height: 80), // Space for FAB and bottom nav
          //       ],
          //     ),
          //   ),
          // ),
          tasksAsyncValue.when(
            data: (tasks) {
              // Group tasks by due date
              final Map<String, List<Task>> groupedTasks = _groupTasksByDate(tasks);

              return SliverPadding(
                padding: const EdgeInsets.all(24.0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      if (groupedTasks['today'] != null && groupedTasks['today']!.isNotEmpty) ...[
                        Text('Today', style: AppTextStyles.sectionHeader),
                        const SizedBox(height: 16),
                        ..._buildTaskCards(context, ref, groupedTasks['today']!),
                        const SizedBox(height: 24),
                      ],
                      if (groupedTasks['tomorrow'] != null && groupedTasks['tomorrow']!.isNotEmpty) ...[
                        Text('Tomorrow', style: AppTextStyles.sectionHeader),
                        const SizedBox(height: 16),
                        ..._buildTaskCards(context, ref, groupedTasks['tomorrow']!),
                        const SizedBox(height: 24),
                      ],
                      if (groupedTasks['this_week'] != null && groupedTasks['this_week']!.isNotEmpty) ...[
                        Text('This week', style: AppTextStyles.sectionHeader),
                        const SizedBox(height: 16),
                        ..._buildTaskCards(context, ref, groupedTasks['this_week']!),
                        const SizedBox(height: 24),
                      ],
                      if (groupedTasks['later'] != null && groupedTasks['later']!.isNotEmpty) ...[
                        Text('Later', style: AppTextStyles.sectionHeader),
                        const SizedBox(height: 16),
                        ..._buildTaskCards(context, ref, groupedTasks['later']!),
                        const SizedBox(height: 24),
                      ],
                      if (tasks.isEmpty)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(24.0),
                            child: Text(
                              'No tasks yet! Click the + button to add one.',
                              style: AppTextStyles.bodyText,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      const SizedBox(height: 80), // Space for FAB and bottom nav
                    ],
                  ),
                ),
              );
            },
            loading: () => const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, stack) => SliverFillRemaining(
              child: Center(child: Text('Error loading tasks: $error')),
            ),
          ),
        ],
      ),
      
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        //clipBehavior: Clip.hardEdge,
      
        onPressed: () {
          // TODO: Navigate to Add Task screen
          print('Add new task');
              Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddEditTaskScreen(), // No task means add mode
            ),
          );
        },
        backgroundColor: AppColors.primaryPurple,
        shape: const CircleBorder(), // Make it circular
        elevation: 5,
        child: const Icon(Icons.add, color: AppColors.white),
      ),
      bottomNavigationBar: BottomAppBar(
        
        color: AppColors.white,
        surfaceTintColor: AppColors.white, // For Material 3
        shadowColor: AppColors.lightGrey,
        elevation: 10,
        height: 70,
        shape: CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.format_list_bulleted, color: AppColors.darkGrey),
              onPressed: () {
                // TODO: Handle list view
              },
            ),
          
            const SizedBox(width: 48), // The space for the FAB
            // IconButton(
            //   icon: const Icon(Icons.calendar_today, color: AppColors.darkGrey),
            //   onPressed: () {
            //     // TODO: Handle calendar view
            //   },
            // ),
            IconButton(
              icon: const Icon(Icons.logout, color: AppColors.red),
              onPressed: () {
                // TODO: Handle profile view
                // ref.read(authViewModelProvider.notifier).signOut(); // Logout for now
               showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Logout'),
          content: Text('Are you want to logout?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('Delete', style: TextStyle(color: AppColors.red)),
              onPressed: () {
               ref.read(authViewModelProvider.notifier).signOut(); 
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
              
              },
           ),
          ],
        ),
      ),
    );
  }
}