import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class CustomDropdownButton<T> extends StatelessWidget {
  final String labelText;
  final double width;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final FormFieldValidator<T>? validator;

  const CustomDropdownButton({
    super.key,
    required this.labelText,
    required this.width,
    this.value,
    required this.items,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: DropdownButtonFormField2<T>(
        decoration: InputDecoration(
          labelText: (validator != null) ? '$labelText*' : labelText,
          border: const OutlineInputBorder(),
        ),
        value: value,             // Now called 'value' instead of 'initialValue'
        items: items,
        onChanged: onChanged,
        validator: validator,     // Pass validator if you need form validation
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
