import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:mouv_aps/screens/FormPage.dart';
import 'package:mouv_aps/widgets/custom_drop_down_button.dart';
import 'package:mouv_aps/widgets/custom_input_field.dart';
import 'package:mouv_aps/widgets/editable_field_chip.dart';

class PhysicalExerciseFormpage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userForm =
    (context.findAncestorStateOfType<FormPageState>()?.userForm)!;
    return SingleChildScrollView(
        child: Column(children: [
          const SizedBox(height: 10),
          Text('Activité physique',
              style: GoogleFonts.oswald(fontSize: 30)),
          const SizedBox(height: 20),
          EditableChipField(title: 'Activité physique antérieure',
              onChanged: (value) {
                userForm.previousPhysicalActivity = value;
              },
          ),
          EditableChipField(title: 'Activité physique actuelle',
              onChanged: (value) {
                userForm.currentPhysicalActivity = value;
              },
          ),
          CustomDropdownButton(labelText: 'À quelle fréquence ? (par semaine)',
              width: 150,
              onChanged: (value) {
                userForm.physicalActivityFrequency = value!;
              },
              items: List.generate(8, (index) {
                return DropdownMenuItem(
                  value: index,
                  child: Text(index.toString()),
                );
              }),
          ),
          CustomDropdownButton(labelText: 'Pendant quelle durée ? (en heures)',
            width: 150,
            onChanged: (value) {
              userForm.physicalActivityDuration = value!;
            },
            items: List.generate(6, (index) {
              return DropdownMenuItem(
                value: index,
                child: Text(index.toString()),
              );
            }),
          ),
          CustomDropdownButton(labelText: 'À quelle intensité ?',
            width: 150,
            onChanged: (value) {
              userForm.physicalActivityIntensity = value!;
            },
            items: ['Basse', 'Modérée', 'Intense']
                .map((intensity) => DropdownMenuItem(
              value: intensity,
              child: Text(intensity),
            ))
                .toList(),
          ),
          EditableChipField(title: 'Difficultés pour pratiquer',
              onChanged: (value) {
                userForm.medicalCare = value;
              },
              hintText: 'Temps, douleurs, fatigue...'),
          CustomDropdownButton(labelText: 'Savez-vous vous allonger et vous relever ?',
              width: 150,
              onChanged: (value) {
                userForm.canGetUp = true ? value == 'Oui' : false;
              },
              items: ['Oui', 'Non']
                  .map((getUp) => DropdownMenuItem(
                value: getUp,
                child: Text(getUp),
              ))
                  .toList(),
          ),
          CustomDropdownButton(labelText: 'Possédez-vous du matériel sportif ?',
            width: 150,
            onChanged: (value) {
              userForm.sportsEquipment = true ? value == 'Oui' : false;
            },
            items: ['Oui', 'Non']
                .map((equipment) => DropdownMenuItem(
              value: equipment,
              child: Text(equipment),
            ))
                .toList(),
          ),
          CustomInputField(labelText: 'Attentes sur le programme sportif',
              keyboardType: TextInputType.text,
              onChanged: (value) {
                userForm.sportExpectations = value!;
              },
          ),

        ]));
  }
}
