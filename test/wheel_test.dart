import 'package:flutter_test/flutter_test.dart';

import 'package:job_wheel/job_wheel.dart';

void main() {
  test('adds one to input values', () {
    List<String> outerChoices = ["Dishes", "Trash", "Laundry", "Cooking"];
    List<String> innerChoices = ["Mom", "Dad", "Jill", "John"];
    double number = 0;

    JobWheel(
      outerChoices: outerChoices,
      innerChoices: innerChoices,
      number: number,
    );
  });
}
