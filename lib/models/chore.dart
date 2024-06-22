enum Priority { none, low, high }

class Chore {
  String name;
  DateTime? deadline;
  bool isDone = false;
  Priority priority = Priority.none;

  Chore(
      {required this.name,
      this.deadline,
      this.isDone = false,
      this.priority = Priority.none});
}

List<Chore> dumbell = [
  Chore(
      name: 'Купить гирю',
      isDone: true,
      priority: Priority.high,
      deadline: DateTime.now()),
  Chore(name: 'Купить гирю'),
  Chore(name: 'Купить гирю'),
  Chore(name: 'Купить большую гирю', priority: Priority.high),
  Chore(name: 'Купил гирю', isDone: true),
  Chore(name: 'Купить маленькую гирю', priority: Priority.low),
  Chore(name: 'Купить гирю'),
  Chore(name: 'Купить гирю'),
  Chore(name: 'Купить гирю'),
  Chore(name: 'Купить гирю', isDone: true),
  Chore(
      priority: Priority.low,
      name:
          'Мне пора прекратить покупать гири, но я не могу остановиться. Мне кажется, у меня есть проблемы'),
  Chore(name: 'Купить гирю', isDone: true),
  Chore(name: 'Купить гирю'),
  Chore(name: 'Купить гирю'),
  Chore(name: 'Купить гирю'),
];
