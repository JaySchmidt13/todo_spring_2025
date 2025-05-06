import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stats'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overview Cards
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: _buildOverviewCard(
                      context,
                      'Total Tasks',
                      '24',
                      Icons.task_alt,
                      Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildOverviewCard(
                      context,
                      'Completed',
                      '18',
                      Icons.check_circle,
                      Colors.green,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildOverviewCard(
                      context,
                      'Pending',
                      '6',
                      Icons.pending_actions,
                      Colors.orange,
                    ),
                  ),
                ],
              ),
            ),

            // Task Categories
            Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tasks by Category',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 200,
                        child: _buildCategoryChart(),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Weekly Activity Timeline (Placeholder)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Weekly Activity',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 200,
                        child: _buildWeeklyActivityChart(),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Productivity Score (Placeholder)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.star),
                  ),
                  title: const Text('Productivity Score'),
                  subtitle: const Text('Based on completion rate and timing'),
                  trailing: const Text(
                    '85%',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            // Task Completion Time Distribution (Placeholder)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Peak Productivity Hours',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      _buildProductivityTimeItem('Morning (6AM-12PM)', 0.7),
                      _buildProductivityTimeItem('Afternoon (12PM-6PM)', 0.4),
                      _buildProductivityTimeItem('Evening (6PM-12AM)', 0.3),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewCard(
      BuildContext context, String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChart() {
    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(
            value: 35,
            title: 'Work',
            color: Colors.blue,
            radius: 60,
          ),
          PieChartSectionData(
            value: 25,
            title: 'Personal',
            color: Colors.green,
            radius: 60,
          ),
          PieChartSectionData(
            value: 20,
            title: 'Shopping',
            color: Colors.orange,
            radius: 60,
          ),
          PieChartSectionData(
            value: 20,
            title: 'Other',
            color: Colors.purple,
            radius: 60,
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyActivityChart() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 10,
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                return Text(days[value.toInt() % 7]);
              },
            ),
          ),
        ),
        barGroups: [
          BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 8)]),
          BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 6)]),
          BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 4)]),
          BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 7)]),
          BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 5)]),
          BarChartGroupData(x: 5, barRods: [BarChartRodData(toY: 3)]),
          BarChartGroupData(x: 6, barRods: [BarChartRodData(toY: 2)]),
        ],
      ),
    );
  }

  Widget _buildProductivityTimeItem(String timeRange, double percentage) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(timeRange),
            ),
            Expanded(
              flex: 7,
              child: LinearProgressIndicator(
                value: percentage,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.blue.withOpacity(0.7),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}