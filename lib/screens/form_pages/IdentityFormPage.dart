import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:mouv_aps/screens/FormPage.dart';
import 'package:mouv_aps/widgets/custom_drop_down_button.dart';
import 'package:mouv_aps/widgets/custom_input_field.dart';
import 'package:mouv_aps/widgets/editable_field_chip.dart';

class IdentityFormPage extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  const IdentityFormPage({super.key, required this.formKey});

  @override
  Widget build(BuildContext context) {
    final userForm =
        (context.findAncestorStateOfType<FormPageState>()?.userForm)!;
    return SingleChildScrollView(
        child: Form(
            key: formKey,
            child: Column(children: [
              const SizedBox(height: 10),
              Text('Informations personnelles',
                  style: GoogleFonts.oswald(fontSize: 30)),
              const SizedBox(height: 20),
              CustomDropdownButton(
                labelText: 'Âge',
                width: 150,
                onChanged: (value) {
                  userForm.age = value!;
                },
                items: List.generate(100, (index) {
                  return DropdownMenuItem(
                    value: index,
                    child: Text(index.toString()),
                  );
                }),
                validator: (value) {
                  if (value == null) {
                    return 'Veuillez entrer un âge';
                  }
                  return null;
                },
              ),
              CustomDropdownButton(
                  labelText: 'Sexe',
                  width: 200,
                  onChanged: (value) {
                    userForm.sex = value!;
                  },
                  items: ['Homme', 'Femme', 'Autre']
                      .map((sex) => DropdownMenuItem(
                            value: sex,
                            child: Text(sex),
                          ))
                      .toList(),
                  validator: (value) {
                    if (value == null) {
                      return 'Veuillez entrer un sexe';
                    }
                    return null;
                  }),
              CustomInputField(
                labelText: 'Taille (cm)',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une taille';
                  }
                  if (int.parse(value) < 0 || int.parse(value) > 250) {
                    return 'Veuillez entrer une taille valide';
                  }
                  return null;
                },
                onSaved: (value) {
                  userForm.height = int.parse(value!);
                },
              ),
              CustomInputField(
                labelText: 'Poids (kg)',
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  userForm.weight = int.parse(value!);
                },
                controller: TextEditingController(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un poids';
                  }
                  if (int.parse(value) < 0 || int.parse(value) > 250) {
                    return 'Veuillez entrer un poids valide';
                  }
                  return null;
                },
              ),
              EditableChipField(
                  title: 'Maladies/Handicaps',
                  initialValue: userForm.disabilities,
                  onChanged: (items) {
                    userForm.disabilities = items;
                  }),
            ])));
  }
}
