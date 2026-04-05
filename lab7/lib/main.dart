import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Возвращение значения')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {},
          child: const Text('Приступить к выбору...'),
        ),
      ),
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      initialRoute: '/',
      routes: {'/': (BuildContext context) => const MainScreen()},
    ),
  );
}
