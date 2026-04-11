class Machine {
  int _coffeeBeans;
  int _milk;
  int _water;
  double _cash;

  Machine(this._coffeeBeans, this._milk, this._water, this._cash);

  // Универсальный геттер
  num getResource(String type) {
    switch (type) {
      case 'coffeeBeans':
        return _coffeeBeans;
      case 'milk':
        return _milk;
      case 'water':
        return _water;
      case 'cash':
        return _cash;
      default:
        throw Exception('Неизвестный ресурс');
    }
  }

  // Универсальный сеттер
  void setResource(String type, num value) {
    switch (type) {
      case 'coffeeBeans':
        _coffeeBeans = value as int;
        break;
      case 'milk':
        _milk = value as int;
        break;
      case 'water':
        _water = value as int;
        break;
      case 'cash':
        _cash = value.toDouble();
        break;
      default:
        throw Exception('Неизвестный ресурс');
    }
  }

  // Проверка ресурсов для эспрессо
  bool isAvailableResources() {
    return _coffeeBeans >= 50 && _water >= 100;
  }

  // Приватный метод уменьшения ресурсов
  void _subtractResources(int coffeeBeans, int milk, int water) {
    _coffeeBeans -= coffeeBeans;
    _milk -= milk;
    _water -= water;
  }

  // Приготовление кофе
  bool makingCoffee() {
    if (isAvailableResources()) {
      _subtractResources(50, 0, 100);
      return true;
    }
    return false;
  }
}
