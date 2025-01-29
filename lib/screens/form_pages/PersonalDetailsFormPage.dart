import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:mouv_aps/screens/FormPage.dart';
import 'package:mouv_aps/widgets/custom_drop_down_button.dart';
import 'package:mouv_aps/widgets/custom_input_field.dart';

class PersonalDetailsFormPage extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  const PersonalDetailsFormPage({super.key, required this.formKey});
  @override
  Widget build(BuildContext context) {
    final userForm =
        (context.findAncestorStateOfType<FormPageState>()?.userForm)!;
    return SingleChildScrollView(
        child: Form(
            key: formKey,
            child: Column(children: [
              const SizedBox(height: 10),
              Text('Détails personnels',
                  style: GoogleFonts.oswald(fontSize: 30)),
              const SizedBox(height: 20),
              CustomInputField(
                  labelText: 'Situation familiale',
                  keyboardType: TextInputType.text,
                  onSaved: (value) {
                    userForm.family = value!;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer une situation familiale';
                    }
                    return null;
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
              CustomDropdownButton(
                  labelText: 'Nombre d\'étages de votre habitat',
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
                  validator: (value) {
                    if (value == null) {
                      return 'Veuillez entrer un nombre d\'étages';
                    }
                    return null;
                  }),
              CustomDropdownButton(
                labelText: 'Faut-il y emprunter des escaliers ?',
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
                validator: (value) {
                  if (value == null) {
                    return 'Veuillez entrer si vous devez emprunter des escaliers';
                  }
                  return null;
                },
              ),
              CustomInputField(
                  labelText: 'Profession',
                  keyboardType: TextInputType.text,
                  onSaved: (value) {
                    userForm.job = value!;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer une profession';
                    }
                    return null;
                  },
                  hintText: 'Ingénieur, étudiant, retraité...'),
            ])));
  }
}
