import 'package:flutter/material.dart';
import 'package:time_picker_sheet/widget/behaviour/snap_scroll.dart';
import 'package:time_picker_sheet/widget/provider/time_picker.dart';

class ListNumber extends StatelessWidget {
  final double itemHeight;

  final List<int> numbers;

  final ScrollController controller;

  final ValueNotifier<int> numberNotifier;

  final bool twoDigits;

  final Function(int)? manualChange;

  const ListNumber({
    Key? key,
    required this.itemHeight,
    required this.numbers,
    required this.controller,
    required this.numberNotifier,
    required this.twoDigits,
    this.manualChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = TimePickerProvider.of(context);

    return ValueListenableBuilder<int>(
      valueListenable: numberNotifier,
      builder: (ctx, selectedNumber, _) {
        final widgets = List<Widget>.generate(
          numbers.length,
          (index) {
            final number = numbers[index];

            String numberFormatted = number.toString();
            if (twoDigits) numberFormatted = numberFormatted.padLeft(2, '0');

            Widget content = Container(
              height: itemHeight,
              alignment: Alignment.center,
              child: Text(
                numberFormatted,
                style: selectedNumber == number ? provider.wheelNumberSelectedStyle : provider.wheelNumberItemStyle,
              ),
            );

            return manualChange != null
                ? MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        numberNotifier.value = number;

                        manualChange!(number);
                      },
                      child: content,
                    ),
                  )
                : content;
          },
        );

        return ListWheelScrollView.useDelegate(
          itemExtent: itemHeight,
          controller: controller,
          physics: SnappScrollPhysic(itemHeight: itemHeight),
          childDelegate: ListWheelChildLoopingListDelegate(children: widgets),
        );
      },
    );
  }
}
