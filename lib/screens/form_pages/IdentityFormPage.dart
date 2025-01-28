import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:mouv_aps/screens/FormPage.dart';
import 'package:mouv_aps/widgets/custom_drop_down_button.dart';
import 'package:mouv_aps/widgets/custom_input_field.dart';
import 'package:mouv_aps/widgets/editable_field_chip.dart';

class IdentityFormPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userForm =
        (context.findAncestorStateOfType<FormPageState>()?.userForm)!;
    return SingleChildScrollView(
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
      ),
      CustomInputField(
        labelText: 'Taille (cm)',
        keyboardType: TextInputType.number,
        onChanged: (value) {
          if (int.tryParse(value!) != null) {
            if (int.parse(value) > 0 && int.parse(value) < 250) {
              userForm.height = int.parse(value);
            }
          }
        },
        validator: (value) {
          if (int.parse(value!) < 0 || int.parse(value) > 250) {
            return 'Veuillez entrer une taille valide';
          }
          return null;
        },
      ),
      CustomInputField(
        labelText: 'Poids (kg)',
        keyboardType: TextInputType.number,
        onChanged: (value) {
          if (int.tryParse(value!) != null) {
            if (int.parse(value) > 0 && int.parse(value) < 500) {
              userForm.height = int.parse(value);
            }
          }
        },
        validator: (value) {
          if (int.parse(value!) < 0 || int.parse(value) > 250) {
            return 'Veuillez entrer un poids valide';
          }
          return null;
        },
      ),
      EditableChipField(
          title: 'Maladies/Handicaps',
          onChanged: (items) {
            userForm.disabilities = items;
          }),
    ]));
  }
}
