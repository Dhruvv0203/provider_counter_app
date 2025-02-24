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
  int _age = 0;

  int get age => _age;

  void setAge(int newAge) {
    if (newAge >= 0 && newAge <= 99) {
      _age = newAge;
      notifyListeners();
    }
  }

  void increaseAge() {
    if (_age < 99) {
      _age++;
      notifyListeners();
    }
  }

  void decreaseAge() {
    if (_age > 0) {
      _age--;
      notifyListeners();
    }
  }

  Color getBackgroundColor() {
    if (_age <= 12) return Colors.lightBlue;
    if (_age <= 19) return Colors.lightGreen;
    if (_age <= 30) return Colors.yellow;
    if (_age <= 50) return Colors.orange;
    return Colors.grey;
  }

  String getAgeMessage() {
    if (_age <= 12) return "You're a child!";
    if (_age <= 19) return "Teenager time!";
    if (_age <= 30) return "You're a young adult!";
    if (_age <= 50) return "You're an adult now!";
    return "Golden years!";
  }

  double getProgress() {
    return _age / 99;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Age Counter App',
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final counter = Provider.of<Counter>(context);

    return Scaffold(
      backgroundColor: counter.getBackgroundColor(),
      appBar: AppBar(title: const Text('Age Counter')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              counter.getAgeMessage(),
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
                counter.setAge(value.toInt()); // Use setAge() method
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
