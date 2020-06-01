# Job Wheel

## Usage

Many organizations have groups of people who cycle through a list of tasks.

For example, maybe you have a Mom, a Dad, a daughter (Jill) and a son (John) who take turns with dishes, taking out the trash, folding laundry, and cooking.

To represent a wheel like this, we might do the following:

```dart
// These appear on the outer wheel
List<String> outerChoices = ["Dishes", "Trash", "Laundry", "Cooking"];

// These appear on the inner wheel
List<String> innerChoices = ["Mom", "Dad", "Jill", "John"];

// This determines the offset.  
// It might be incremented once each week, for example.
// This is provided as a double rather than an integer to facilitate animations
// where the wheel gradually tranistions from one spot to another.
double number = 0;

JobWheel(
    outerChoices: outerChoices,
    innerChoices: innerChoices,
    number: number,
)
```

The result of this would be something like

<https://fhe-wheel.surge.sh/?title=Jobs&offset=1&turnSeconds=604800&start=2020-03-30&outerChoices=Mom,Dad,Jill,John&innerChoices=Dishes,Trash,Laundry,Cooking#/>

## Installation
