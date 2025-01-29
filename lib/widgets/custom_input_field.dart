import 'package:flutter/material.dart';

class CustomInputField<T> extends StatefulWidget {
  final String labelText;
  final String? initialValue;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Function(String?) onChanged;
  final String? hintText;
  final TextEditingController? controller;

  const CustomInputField({
    super.key,
    required this.labelText,
    this.initialValue,
    required this.keyboardType,
    this.validator,
    required this.onChanged,
    this.hintText,
    this.controller,
  });

  @override
  _CustomInputFieldState<T> createState() => _CustomInputFieldState<T>();
}

class _CustomInputFieldState<T> extends State<CustomInputField<T>> {
  late TextEditingController _controller = TextEditingController();
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    if (widget.initialValue != null) {
      _controller.text = widget.initialValue!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _controller,
              keyboardType: widget.keyboardType,
              decoration: InputDecoration(
                labelText: widget.labelText,
                hintText: widget.hintText,
                hintStyle: const TextStyle(color: Colors.grey),
                border: const OutlineInputBorder(),
                errorText: _errorMessage,
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  if (widget.validator != null) {
                    final error = widget.validator!(value);
                    setState(() {
                      _errorMessage = error;
                    });
                  }
                }

                if (_errorMessage == null) {
                  widget.onChanged(value);
                }
              },
            ),
          ],
        ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
