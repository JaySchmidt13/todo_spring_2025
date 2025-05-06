import 'package:flutter/material.dart';

class ArchiveScreen extends StatelessWidget {
  const ArchiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Archive'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Recent'),
              Tab(text: 'By Category'),
              Tab(text: 'Timeline'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildRecentTasksList(),
            _buildCategoryView(),
            _buildTimelineView(),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentTasksList() {
    final List<Map<String, dynamic>> mockTasks = [
      {
        'text': 'Complete project presentation',
        'category': 'Work',
        'completedAt': DateTime.now().subtract(const Duration(hours: 2)),
        'dueAt': DateTime.now().subtract(const Duration(hours: 1)),
        'location': 'Office',
      },
      {
        'text': 'Buy groceries',
        'category': 'Shopping',
        'completedAt': DateTime.now().subtract(const Duration(days: 1)),
        'dueAt': DateTime.now().subtract(const Duration(hours: 23)),
        'location': 'Walmart',
      },
      {
        'text': 'Gym workout',
        'category': 'Health',
        'completedAt': DateTime.now().subtract(const Duration(days: 2)),
        'dueAt': DateTime.now().subtract(const Duration(days: 2)),
        'location': 'Fitness Center',
      },
    ];

    return ListView.builder(
      itemCount: mockTasks.length,
      itemBuilder: (context, index) {
        final task = mockTasks[index];
        return _buildArchiveCard(context, task);
      },
    );
  }

  Widget _buildCategoryView() {
    final Map<String, List<Map<String, dynamic>>> mockCategories = {
      'Work': [
        {
          'text': 'Complete project presentation',
          'completedAt': DateTime.now().subtract(const Duration(hours: 2)),
          'dueAt': DateTime.now().subtract(const Duration(hours: 1)),
          'location': 'Office',
        },
        {
          'text': 'Team meeting notes',
          'completedAt': DateTime.now().subtract(const Duration(days: 3)),
          'dueAt': DateTime.now().subtract(const Duration(days: 3)),
          'location': 'Conference Room',
        },
      ],
      'Shopping': [
        {
          'text': 'Buy groceries',
          'completedAt': DateTime.now().subtract(const Duration(days: 1)),
          'dueAt': DateTime.now().subtract(const Duration(hours: 23)),
          'location': 'Walmart',
        },
      ],
      'Health': [
        {
          'text': 'Gym workout',
          'completedAt': DateTime.now().subtract(const Duration(days: 2)),
          'dueAt': DateTime.now().subtract(const Duration(days: 2)),
          'location': 'Fitness Center',
        },
        {
          'text': 'Morning run',
          'completedAt': DateTime.now().subtract(const Duration(days: 4)),
          'dueAt': DateTime.now().subtract(const Duration(days: 4)),
          'location': 'Central Park',
        },
      ],
    };

    return ListView.builder(
      itemCount: mockCategories.length,
      itemBuilder: (context, index) {
        final category = mockCategories.keys.elementAt(index);
        final tasks = mockCategories[category]!;
        return _buildCategorySection(context, category, tasks);
      },
    );
  }

  Widget _buildTimelineView() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildTimelineGroup('Today', 2),
        _buildTimelineGroup('Yesterday', 1),
        _buildTimelineGroup('This Week', 4),
        _buildTimelineGroup('Last Week', 3),
        _buildTimelineGroup('This Month', 8),
      ],
    );
  }

  Widget _buildTimelineGroup(String title, int count) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Badge(
                  label: Text(count.toString()),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: count,
            itemBuilder: (context, index) {
              return ListTile(
                leading: const Icon(Icons.check_circle, color: Colors.green),
                title: Text('Mock Task ${index + 1}'),
                subtitle: Text('Completed at ${_formatTime(DateTime.now().subtract(Duration(hours: index)))}'),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection(BuildContext context, String category, List<Map<String, dynamic>> tasks) {
    return ExpansionTile(
      leading: Icon(
        _getCategoryIcon(category),
        color: Theme.of(context).colorScheme.primary,
      ),
      title: Text(
        category,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text('${tasks.length} tasks'),
      children: tasks.map((task) => _buildArchiveCard(context, {...task, 'category': category})).toList(),
    );
  }

  Widget _buildArchiveCard(BuildContext context, Map<String, dynamic> task) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: Icon(
            _getCategoryIcon(task['category']),
            color: Colors.white,
          ),
        ),
        title: Text(
          task['text'],
          style: const TextStyle(
            decoration: TextDecoration.lineThrough,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Category: ${task['category']}'),
            if (task['location'] != null) Text('Location: ${task['location']}'),
            if (task['completedAt'] != null)
              Text(
                'Completed: ${_formatDate(task['completedAt'])}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (task['dueAt'] != null)
              Icon(
                Icons.check_circle,
                color: _wasCompletedOnTime(task) ? Colors.green : Colors.orange,
                size: 20,
              ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
        onTap: () {
          // Show a mock details dialog
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(task['text']),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Category: ${task['category']}'),
                  Text('Location: ${task['location']}'),
                  Text('Completed: ${_formatDate(task['completedAt'])}'),
                  Text('Due: ${_formatDate(task['dueAt'])}'),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }

  String _formatTime(DateTime date) {
    return '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  bool _wasCompletedOnTime(Map<String, dynamic> task) {
    final completedAt = task['completedAt'] as DateTime;
    final dueAt = task['dueAt'] as DateTime;
    return completedAt.isBefore(dueAt);
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'work':
        return Icons.work;
      case 'personal':
        return Icons.person;
      case 'shopping':
        return Icons.shopping_cart;
      case 'health':
        return Icons.favorite;
      case 'education':
        return Icons.school;
      default:
        return Icons.list;
    }
  }
}