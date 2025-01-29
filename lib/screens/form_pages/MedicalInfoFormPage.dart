import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:mouv_aps/screens/FormPage.dart';
import 'package:mouv_aps/widgets/custom_drop_down_button.dart';
import 'package:mouv_aps/widgets/custom_input_field.dart';
import 'package:mouv_aps/widgets/editable_field_chip.dart';

class MedicalInfoFormpage extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  const MedicalInfoFormpage({super.key, required this.formKey});

  @override
  Widget build(BuildContext context) {
    final userForm =
        (context.findAncestorStateOfType<FormPageState>()?.userForm)!;
    return SingleChildScrollView(
        child: Form(
            key: formKey,
            child: Column(children: [
              const SizedBox(height: 10),
              Text('Informations médicales',
                  style: GoogleFonts.oswald(fontSize: 30)),
              const SizedBox(height: 20),
              EditableChipField(
                  title: 'Antécédents médicaux',
                  onChanged: (value) {
                    userForm.medicalHistory = value;
                  },
                  hintText: 'Boulimie, dents de sagesse...'),
              EditableChipField(
                  title: 'Facteurs de risque',
                  onChanged: (value) {
                    userForm.riskFactors = value;
                  },
                  hintText: 'Tabagisme, alcoolisme...'),
              EditableChipField(
                  title: 'Prises en charge médicales',
                  onChanged: (value) {
                    userForm.medicalCare = value;
                  },
                  hintText: 'Kinésithérapie, psychologue...'),
              EditableChipField(
                title: 'Traitements médicamenteux',
                onChanged: (value) {
                  userForm.treatment = value;
                },
              ),
            ])));
  }
}
