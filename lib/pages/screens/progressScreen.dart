import 'package:flutter/material.dart';

/// ---------------------------
/// Habit Model
/// ---------------------------
class Habit {
  final String title;
  final int completedDays;
  final int totalDays;

  Habit({
    required this.title,
    required this.completedDays,
    required this.totalDays,
  });

  double get progress => completedDays / totalDays;

  bool get isAchieved => completedDays == totalDays;
}

/// ---------------------------
/// Progress Page
/// ---------------------------
class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  /// Dynamic Habit Data
  final List<Habit> habits = [
    Habit(title: "Journaling everyday", completedDays: 7, totalDays: 7),
    Habit(title: "Cooking Practice", completedDays: 7, totalDays: 7),
    Habit(title: "Vitamin", completedDays: 5, totalDays: 7),
  ];

  /// Calculate Overall Progress
  double get overallProgress {
    int totalCompleted = habits.fold(
      0,
      (sum, habit) => sum + habit.completedDays,
    );
    int totalTarget = habits.fold(0, (sum, habit) => sum + habit.totalDays);

    if (totalTarget == 0) return 0;

    return totalCompleted / totalTarget;
  }

  /// Count Achieved
  int get achievedCount => habits.where((habit) => habit.isAchieved).length;

  /// Count Unachieved
  int get unachievedCount => habits.where((habit) => !habit.isAchieved).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Progress",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Progress Report Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Progress Report",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Text("This Month"),
                      SizedBox(width: 4),
                      Icon(Icons.keyboard_arrow_down, size: 18),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// Main Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Your Goals",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        "See all",
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// Dynamic Circular Progress
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 160,
                          height: 160,
                          child: CircularProgressIndicator(
                            value: overallProgress,
                            strokeWidth: 14,
                            backgroundColor: Colors.grey.shade200,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Colors.orange,
                            ),
                          ),
                        ),
                        Text(
                          "${(overallProgress * 100).toInt()}%",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// Dynamic Summary
                  Text(
                    "✓ $achievedCount Habits goal has achieved",
                    style: const TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "✕ $unachievedCount Habits goal hasn't achieved",
                    style: TextStyle(color: Colors.grey.shade600),
                  ),

                  const SizedBox(height: 20),

                  /// Dynamic Habit List
                  ...habits.map((habit) {
                    return _goalItem(
                      percent: (habit.progress * 100).toInt(),
                      title: habit.title,
                      subtitle:
                          "${habit.completedDays} from ${habit.totalDays} days target",
                      achieved: habit.isAchieved,
                    );
                  }).toList(),

                  const SizedBox(height: 10),

                  const Center(
                    child: Text(
                      "See All",
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Goal Item Widget
  Widget _goalItem({
    required int percent,
    required String title,
    required String subtitle,
    required bool achieved,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          /// Percentage Circle
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: achieved ? Colors.green : Colors.grey,
                width: 3,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              "$percent%",
              style: TextStyle(
                color: achieved ? Colors.green : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(width: 12),

          /// Text Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          ),

          /// Status
          Text(
            achieved ? "Achieved" : "Unachieved",
            style: TextStyle(
              color: achieved ? Colors.green : Colors.grey,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
