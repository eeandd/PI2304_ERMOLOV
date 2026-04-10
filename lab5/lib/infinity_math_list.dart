import 'package:flutter/material.dart';

class InfinityMathList extends StatelessWidget {
  const InfinityMathList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, i) {
        if (i.isOdd) return Divider();
        final int index = i ~/ 2;
        final value = BigInt.from(2).pow(index);
        return ListTile(title: Text('2 ^ $index = $value'));
      },
    );
  }
}
