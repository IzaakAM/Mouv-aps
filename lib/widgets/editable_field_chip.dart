import 'package:flutter/material.dart';

class EditableChipField extends FormField<List<String>> {
  EditableChipField({
    Key? key,
    required String title,
    required ValueChanged<List<String>> onChanged,
    List<String> initialValue = const [],
    FormFieldValidator<List<String>>? validator,
    String? hintText,
  }) : super(
    key: key,
    initialValue: initialValue,    // The initial list of chips
    validator: validator,          // Custom validator for the list
    autovalidateMode: AutovalidateMode.onUserInteraction,
    builder: (FormFieldState<List<String>> field) {
      return _EditableChipField(
        title: title,
        hintText: hintText,
        // current items are stored in field.value
        items: field.value ?? [],
        // display any validation error under the chips
        errorText: field.errorText,
        // whenever chips change, call didChange
        onChanged: (updatedItems) {
          field.didChange(updatedItems);
          onChanged(updatedItems);
        },
      );
    },
  );
}

class _EditableChipField extends StatefulWidget {
  final String title;
  final String? hintText;
  final List<String> items;
  final String? errorText;
  final ValueChanged<List<String>> onChanged;

  const _EditableChipField({
    Key? key,
    required this.title,
    this.hintText,
    required this.items,
    this.errorText,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<_EditableChipField> createState() => _EditableChipFieldState();
}

class _EditableChipFieldState extends State<_EditableChipField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addItem() {
    final input = _controller.text.trim();
    if (input.isNotEmpty && !widget.items.contains(input)) {
      // create a new List, then add the new item
      final updatedItems = List<String>.from(widget.items)..add(input);
      widget.onChanged(updatedItems);
      _controller.clear();
    }
  }

  void _removeItem(String item) {
    final updatedItems = List<String>.from(widget.items)..remove(item);
    widget.onChanged(updatedItems);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Input field with + button
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    labelText: widget.title,
                    hintText: widget.hintText ?? 'Ajouter...',
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: const OutlineInputBorder(),
                    errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _addItem,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
                child: const Text('+', style: TextStyle(fontSize: 25)),
              ),
            ],
          ),
          // Possible validation error message
          if (widget.errorText != null)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                widget.errorText!,
                style: TextStyle(
                  color: theme.colorScheme.error,
                  fontSize: 13,
                ),
              ),
            ),
          // Display current chips
          Wrap(
            spacing: 8.0,
            children: widget.items.map((item) {
              return Chip(
                label: Text(item),
                deleteIcon: const Icon(Icons.close),
                onDeleted: () => _removeItem(item),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
