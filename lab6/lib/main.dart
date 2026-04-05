import 'package:flutter/material.dart';

class MyForm extends StatefulWidget {
  const MyForm({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MyFormState();
}

class MyFormState extends State {
  final _formKey = GlobalKey<FormState>();
  String result = 'Задайте параметры';
  final widthController = TextEditingController();
  final heightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Row(
              children: [
                const Text('Ширина (мм):', style: TextStyle(fontSize: 16.0)),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: widthController,
                    validator: (value) {
                      if (value!.isEmpty) return 'Задайте ширину';
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Row(
              children: [
                const Text('Высота (мм):', style: TextStyle(fontSize: 16.0)),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: heightController,
                    validator: (value) {
                      if (value!.isEmpty) return 'Задайте высоту';
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            FilledButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final width = double.parse(widthController.text);
                  final height = double.parse(heightController.text);
                  final s = width * height;
                  setState(() {
                    result = 'S = $width * $height = $s мм²';
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Площадь успешно вычислена'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              style: FilledButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text('Вычислить'),
            ),
            Text(result),
          ],
        ),
      ),
    );
  }
}

void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      appBar: AppBar(
        title: const Text(
          'Калькулятор площади',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: const MyForm(),
    ),
  ),
);
