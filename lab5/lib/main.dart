import 'package:flutter/material.dart';
import 'simple_list.dart';
import 'infinity_list.dart';
import 'infinity_math_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Список элементов',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.white)),
      home: const MyHomePage(title: 'Список элементов'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String selected = 'simple';

  @override
  Widget build(BuildContext context) {
    Widget currentWidget;

    switch (selected) {
      case 'infinity':
        currentWidget = InfinityList();
        break;
      case 'math':
        currentWidget = InfinityMathList();
        break;
      default:
        currentWidget = SimpleList();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(widget.title, style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'simple', label: Text('Простой')),
                ButtonSegment(value: 'infinity', label: Text('Бесконечный')),
                ButtonSegment(value: 'math', label: Text('Степени')),
              ],
              selected: {selected},
              onSelectionChanged: (value) {
                setState(() {
                  selected = value.first;
                });
              },
            ),
          ),
          Expanded(child: currentWidget),
        ],
      ),
    );
  }
}
