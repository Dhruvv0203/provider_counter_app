import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => Counter(),
      child: const MyApp(),
    ),
  );
}

class Counter with ChangeNotifier {
  int age = 0;

  void increaseAge() {
    if (age < 99) {
      age += 1;
      notifyListeners();
    }
  }

  void decreaseAge() {
    if (age > 0) {
      age -= 1;
      notifyListeners();
    }
  }

  // Method to return background color based on age milestone
  Color getBackgroundColor() {
    if (age <= 12) return Colors.lightBlue;
    if (age <= 19) return Colors.lightGreen;
    if (age <= 30) return Colors.yellow;
    if (age <= 50) return Colors.orange;
    return Colors.grey;
  }

  // Method to return message based on age milestone
  String getAgeMessage() {
    if (age <= 12) return "You're a child!";
    if (age <= 19) return "Teenager time!";
    if (age <= 30) return "You're a young adult!";
    if (age <= 50) return "You're an adult now!";
    return "Golden years!";
  }

  // Progress bar value
  double getProgress() {
    return age / 99;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Age Counter App',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final counter = Provider.of<Counter>(context);

    return Scaffold(
      backgroundColor: counter.getBackgroundColor(), // Background color changes based on age
      appBar: AppBar(title: const Text('Age Counter')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              counter.getAgeMessage(), // Display message based on age milestone
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Consumer<Counter>(
              builder: (context, counter, child) => Text(
                '${counter.age}',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            Slider(
              value: counter.age.toDouble(),
              min: 0,
              max: 99,
              divisions: 99,
              label: '${counter.age}',
              onChanged: (value) {
                counter.age = value.toInt();
                counter.notifyListeners();
              },
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: LinearProgressIndicator(
                value: counter.getProgress(),
                backgroundColor: Colors.grey[300],
                color: counter.age < 33
                    ? Colors.green
                    : counter.age < 67
                        ? Colors.yellow
                        : Colors.red,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: counter.increaseAge,
            tooltip: 'Increase Age',
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: counter.decreaseAge,
            tooltip: 'Decrease Age',
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}
