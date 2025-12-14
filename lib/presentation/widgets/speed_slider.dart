import 'package:flutter/material.dart';

class SpeedSlider extends StatelessWidget {
  final int value;
  final ValueChanged<double>? onChanged;
  
  const SpeedSlider({
    super.key,
    required this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Slider(
          value: value.toDouble(),
          min: 1,
          max: 5,
          divisions: 4,
          label: value.toString(),
          onChanged: onChanged,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(5, (index) {
              final speed = index + 1;
              return Text(
                speed.toString(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: speed == value 
                      ? FontWeight.bold 
                      : FontWeight.normal,
                  color: speed == value 
                      ? Theme.of(context).colorScheme.primary 
                      : Colors.grey,
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}