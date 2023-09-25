import 'package:flutter/material.dart';
import 'package:time_picker_sheet/widget/composition/numbers.dart';

class NumberWheel extends StatelessWidget {
  final double itemHeight;

  final bool twoDigits;

  final List<int> numbers;

  final ValueNotifier<int> numberNotifier;

  final ScrollController controller;

  final bool manualChange;

  const NumberWheel({
    Key? key,
    required this.itemHeight,
    required this.numberNotifier,
    required this.numbers,
    required this.controller,
    required this.manualChange,
    this.twoDigits = false,
  }) : super(key: key);

  void _onChanged(int position) {
    final index = position % numbers.length;
    numberNotifier.value = numbers[index];
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification is ScrollUpdateNotification) {
          final position = (controller.offset / itemHeight).round();
          _onChanged(position);
        }
        return true;
      },
      child: ListNumber(
        itemHeight: itemHeight,
        numbers: numbers,
        twoDigits: twoDigits,
        controller: controller,
        numberNotifier: numberNotifier,
        manualChange: manualChange
            ? (number) async {
                final position = numbers.indexOf(number) * itemHeight;

                await controller.animateTo(position, curve: Curves.easeIn, duration: const Duration(milliseconds: 300));
              }
            : null,
      ),
    );
  }
}
