import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class CustomDropdownButton<T> extends StatelessWidget {
  final String labelText;
  final double width;
  final T? initialValue;
  final ValueChanged<T?> onChanged;
  final List<DropdownMenuItem<T>> items;

  const CustomDropdownButton({
    super.key,
    required this.labelText,
    required this.width,
    this.initialValue,
    required this.onChanged,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: DropdownButtonFormField2<T>(
        decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(),
        ),
        value: initialValue,
        items: items,
        onChanged: onChanged,
        dropdownStyleData: DropdownStyleData(
          width: width,
          maxHeight: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
