import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Возвращение значения',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: FilledButton(
          onPressed: () async {
            final result = await Navigator.pushNamed(context, '/second');
            if (result != null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('$result')));
            }
          },
          style: FilledButton.styleFrom(backgroundColor: Colors.blue),
          child: const Text('Приступить к выбору...'),
        ),
      ),
    );
  }
}

class SecondScreen extends StatelessWidget {
  const SecondScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Выберите любой вариант',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 100,
              child: FilledButton(
                onPressed: () {
                  Navigator.pop(context, 'Да');
                },
                style: FilledButton.styleFrom(backgroundColor: Colors.blue),
                child: const Text('Да'),
              ),
            ),

            SizedBox(height: 20),
            SizedBox(
              width: 100,
              child: FilledButton(
                onPressed: () {
                  Navigator.pop(context, 'Нет');
                },
                style: FilledButton.styleFrom(backgroundColor: Colors.blue),
                child: const Text('Нет'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => const MainScreen(),
        '/second': (BuildContext context) => const SecondScreen(),
      },
    ),
  );
}
