import 'package:flutter/material.dart';

class EditableChipField extends StatefulWidget {
  final String title;
  final ValueChanged<List<String>> onChanged;
  final String? hintText;
  const EditableChipField({super.key, required this.title, required this.onChanged, this.hintText});

  @override
  EditableChipFieldState createState() {
    return EditableChipFieldState();
  }
}

class EditableChipFieldState extends State<EditableChipField> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _items = [];

  void _addItem() {
    final input = _controller.text.trim();
    if (input.isNotEmpty && !_items.contains(input)) {
      setState(() {
        _items.add(input);
        widget.onChanged([..._items]);
      });
      _controller.clear();
    }
  }

  void _removeItem(String item) {
    setState(() {
      _items.remove(item);
      widget.onChanged([..._items]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Input field with Add button
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: widget.title,
                      hintText: widget.hintText??'Ajouter...',
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addItem,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('+', style: TextStyle(fontSize: 25)),
                ),
              ],
            ),
            // Display chips for items
            Wrap(
              spacing: 8.0,
              children: _items.map((item) {
                return Chip(
                  label: Text(item),
                  deleteIcon: const Icon(Icons.close),
                  onDeleted: () => _removeItem(item),
                );
              }).toList(),
            ),
          ],
        )
    );
  }
}
