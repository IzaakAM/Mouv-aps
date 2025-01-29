import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:mouv_aps/screens/FormPage.dart';
import 'package:mouv_aps/widgets/custom_input_field.dart';
import 'package:mouv_aps/widgets/editable_field_chip.dart';

class NutritionFormPage extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  const NutritionFormPage({super.key, required this.formKey});

  @override
  Widget build(BuildContext context) {
    final userForm =
    (context.findAncestorStateOfType<FormPageState>()?.userForm)!;
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(children: [
          const SizedBox(height: 10),
          Text('Alimentation',
              style: GoogleFonts.oswald(fontSize: 30)),
          const SizedBox(height: 20),
          CustomInputField(labelText: 'Régime alimentaire',
              keyboardType: TextInputType.text,
              onSaved: (value) {
                userForm.diet = value!;
              },
          ),
          EditableChipField(title: 'Allergies alimentaires',
              onChanged: (value) {
                userForm.foodAllergies = value;
              },
              hintText: 'Gluten, lactose...'),
          EditableChipField(title: 'Aliments à éviter',
              onChanged: (value) {
                userForm.dislikedFoods = value;
              },
          ),
          CustomInputField(labelText: 'Attentes sur le programme alimentaire',
            keyboardType: TextInputType.text,
            onSaved: (value) {
              userForm.foodExpectations = value!;
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer vos attentes';
              }
              return null;
            },
          ),
        ]))
    );
  }
}
