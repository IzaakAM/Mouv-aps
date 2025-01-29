import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:mouv_aps/screens/FormPage.dart';
import 'package:mouv_aps/widgets/custom_drop_down_button.dart';
import 'package:mouv_aps/widgets/custom_input_field.dart';
import 'package:mouv_aps/widgets/editable_field_chip.dart';

class PersonalDetailsFormPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userForm =
    (context.findAncestorStateOfType<FormPageState>()?.userForm)!;
    return SingleChildScrollView(
        child: Column(children: [
          const SizedBox(height: 10),
          Text('Détails personnels',
              style: GoogleFonts.oswald(fontSize: 30)),
          const SizedBox(height: 20),
          CustomInputField(
              labelText: 'Situation familiale',
              keyboardType: TextInputType.text,
              onChanged: (value) {
                userForm.family = value!;
              },
              hintText: 'Célibataire, marié, divorcé...'),
          CustomDropdownButton(
            labelText: 'Êtes-vous enceinte ?',
            width: 200,
            onChanged: (value) {
              userForm.pregnant = true ? value == 'Oui' : false;
            },
            items: ['Oui', 'Non']
                .map((pregnant) => DropdownMenuItem(
              value: pregnant,
              child: Text(pregnant),
            ))
                .toList(),
          ),
          CustomDropdownButton(labelText: 'Nombre d\'étages de votre habitat',
              width: 150,
              onChanged: (value) {
                userForm.floors = value!;
              },
              items: List.generate(10, (index) {
                return DropdownMenuItem(
                  value: index,
                  child: Text(index.toString()),
                );
              }),
          ),
          CustomDropdownButton(labelText: 'Faut-il y emprunter des escaliers ?',
            width: 150,
            onChanged: (value) {
              userForm.stairs = true ? value == 'Oui' : false;
            },
            items: ['Oui', 'Non']
                .map((stairs) => DropdownMenuItem(
              value: stairs,
              child: Text(stairs),
            ))
                .toList(),
          ),
          CustomInputField(labelText: 'Profession',
              keyboardType: TextInputType.text,
              onChanged: (value) {
                userForm.job = value!;
              },
              hintText: 'Ingénieur, étudiant, retraité...'),
        ]));
  }
}
