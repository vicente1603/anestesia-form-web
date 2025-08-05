import 'package:flutter/material.dart';
import '../../models/form_data_model.dart';

class FormFields extends StatelessWidget {
  final FormDataModel model;
  const FormFields({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(labelText: 'Idade'),
          onChanged: (value) => model.age = value,
          validator: (value) => value!.isEmpty ? 'Informe a idade' : null,
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Peso'),
          onChanged: (value) => model.weight = value,
          validator: (value) => value!.isEmpty ? 'Informe o Peso' : null,
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Altura'),
          onChanged: (value) => model.height = value,
          validator: (value) => value!.isEmpty ? 'Informe a Altura ' : null,
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Qual cirurgia vai realizar? Quem é o seu cirurgião?'),
          onChanged: (value) => model.surgery = value,
          validator: (value) => value!.isEmpty ? 'Qual cirurgia vai realizar? Quem é o seu cirurgião?' : null,
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Tem alguma alergia a medicamentos ou alimentos?'),
          onChanged: (value) => model.allergies = value,
          validator: (value) => value!.isEmpty ? 'Informe Peso Peso' : null,
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Tem alguma doença?'),
          onChanged: (value) => model.diseases = value,
          validator: (value) => value!.isEmpty ? 'Informe Peso Peso' : null,
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Medicamentos em uso habitual/repetido'),
          onChanged: (value) => model.medications = value,
          validator: (value) => value!.isEmpty ? 'Informe Peso Peso' : null,
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Fuma? Usa alguma droga?'),
          onChanged: (value) => model.drugs = value,
          validator: (value) => value!.isEmpty ? 'Informe Peso Peso' : null,
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Já esteve internado em UTI?'),
          onChanged: (value) => model.icuHistory = value,
          validator: (value) => value!.isEmpty ? 'Informe Peso Peso' : null,
        ),
           TextFormField(
          decoration: const InputDecoration(labelText: 'Tem alguma perda de visão, audição ou movimento?'),
          onChanged: (value) => model.disabilities = value,
          validator: (value) => value!.isEmpty ? 'Informe Peso Peso' : null,
        ),
           TextFormField(
          decoration: const InputDecoration(labelText: 'Quais cirurgias já fez?'),
          onChanged: (value) => model.previousSurgeries = value,
          validator: (value) => value!.isEmpty ? 'Informe Peso Peso' : null,
        ),
      ],
    );
  }
}
