import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrescriptionFormPage extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  // Callback that tells the parent "We got a file!"
  final ValueChanged<PlatformFile?> onFilePicked;

  const PrescriptionFormPage({
    Key? key,
    required this.formKey,
    required this.onFilePicked,
  }) : super(key: key);

  @override
  State<PrescriptionFormPage> createState() => _PrescriptionFormPageState();
}

class _PrescriptionFormPageState extends State<PrescriptionFormPage> {
  PlatformFile? _selectedFile;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: widget.formKey,
        child: Column(
          children: [
            const SizedBox(height: 10),
            Text(
              'Prescription',
              style: GoogleFonts.oswald(fontSize: 30),
            ),
            const SizedBox(height: 20),

            // A custom FormField so we can validate (optional)
            FormField<PlatformFile>(
              validator: (file) {
                // If file is null, we show an error
                if (file == null) {
                  return 'Veuillez sélectionner un fichier';
                }
                return null; // valid
              },
              builder: (fieldState) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        final result = await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['pdf'],
                        );
                        if (result != null && result.files.isNotEmpty) {
                          setState(() {
                            _selectedFile = result.files.single;
                          });

                          // Let the form field know its value changed
                          fieldState.didChange(_selectedFile);

                          // Notify parent via callback
                          widget.onFilePicked(_selectedFile);
                        }
                      },
                      child: const Text('Sélectionner un fichier'),
                    ),

                    // Show an error, if any
                    if (fieldState.hasError)
                      Text(
                        fieldState.errorText!,
                        style: const TextStyle(color: Colors.red),
                      ),

                    // Display the selected file name (if any)
                    if (_selectedFile != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text('Ficher sélectionné: ${_selectedFile!.name}'),
                      ),
                  ],
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
