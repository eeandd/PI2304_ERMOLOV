import 'dart:io';
import 'classes/Machine.dart';

void main() {
  var machine = Machine(100, 50, 200, 0);

  while (true) {
    print('\nВыберите команду:');
    print('1 - Добавить ресурс');
    print('2 - Приготовить кофе');
    print('0 - Выход');

    String? command = stdin.readLineSync();

    switch (command) {
      case '1':
        print('Какой ресурс добавить? (coffeeBeans / milk / water / cash)');
        String? type = stdin.readLineSync();

        print('Введите количество:');
        int value = int.parse(stdin.readLineSync()!);

        machine.setResource(type!, machine.getResource(type) + value);
        print('Ресурс обновлен');
        break;

      case '2':
        if (machine.isAvailableResources()) {
          machine.makingCoffee();
          print('Кофе приготовлен');
        } else {
          print('Недостаточно ресурсов');
        }
        break;

      case '0':
        print('Выход');
        return;

      default:
        print('Неверная команда');
    }
  }
}
