import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final String labelText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final String? hintText;
  final void Function(String?)? onSaved;

  const CustomInputField({
    Key? key,
    required this.labelText,
    this.controller,
    required this.keyboardType,
    this.validator,
    this.hintText,
    this.onSaved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Adjust as needed
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        onSaved: onSaved,
        decoration: InputDecoration(
          labelText: (validator != null) ? '$labelText*' : labelText,
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
