import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(widget.title, style: TextStyle(color: Colors.white)),
      ),
      body: ListView(
        children: const [
          Text('0000'),
          Divider(),
          Text('0001'),
          Divider(),
          Text('0010'),
        ],
      ),
    );
  }
}
