import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Map<String, bool> habits = {
    'Morning Exercise': true,
    'Read a Book': true,
    'Test': false,
  };

  void _addHabit() {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Habit'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Enter habit name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                setState(() {
                  habits[controller.text] = false;
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String today = DateFormat('EEEE, d MMMM yyyy').format(DateTime.now());
    int completedCount = habits.values.where((v) => v).length;

    Widget buildProgress() {
      double progress = habits.isEmpty ? 0 : completedCount / habits.length;
      return Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: 90,
            width: 90,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 8,
              backgroundColor: Colors.white.withValues(alpha: 0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          Text(
            "${(progress * 100).toStringAsFixed(0)}%",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    }

    Widget buildHabitTile(String habitName, bool isCompleted) {
      return Dismissible(
        key: Key(habitName),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          setState(() {
            habits.remove(habitName);
          });
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('$habitName deleted')));
        },
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Checkbox(
                  value: isCompleted,
                  onChanged: (value) {
                    setState(() {
                      habits[habitName] = value ?? false;
                    });
                  },
                ),
                Expanded(
                  child: Text(
                    habitName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      decoration: isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                ),
                Icon(
                  isCompleted ? Icons.check_circle : Icons.circle_outlined,
                  color: isCompleted ? Colors.green : Colors.grey,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          today,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(text: 'Hello, '),
                        TextSpan(
                          text: 'Aditya!',
                          style: const TextStyle(color: Colors.orange),
                        ),
                      ],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(10),
                child: Icon(Icons.account_circle_rounded),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFA94D), Color(0xFFFF6A00)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  buildProgress(),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "$completedCount of ${habits.length} habits",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          "completed today!",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: const [
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'Today Habit',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.all(10),
                child: Text('See all', style: TextStyle(color: Colors.orange)),
              ),
            ],
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              children: habits.entries
                  .map((e) => buildHabitTile(e.key, e.value))
                  .toList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addHabit,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_graph_sharp),
            label: 'Stats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
