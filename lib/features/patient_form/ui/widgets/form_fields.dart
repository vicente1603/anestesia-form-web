import 'package:anestesia_web/features/patient_form/ui/widgets/build_yes_no_field.dart';
import 'package:flutter/material.dart';
import '../../models/form_data_model.dart';

class FormFields extends StatefulWidget {
  final FormDataModel model;
  const FormFields({super.key, required this.model});

  @override
  State<FormFields> createState() => _FormFieldsState();
}

class _FormFieldsState extends State<FormFields> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Qual cirurgia vai realizar?',
          ),
          onChanged: (value) => widget.model.surgery = value,
          validator:
              (value) =>
                  value!.isEmpty ? 'Informe qual cirurgia vai realizar' : null,
        ),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Quem é o seu cirurgião?',
          ),
          onChanged: (value) => widget.model.surgeon = value,
          validator:
              (value) => value!.isEmpty ? 'Informe o nome do cirurgião' : null,
        ),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Tem alguma alergia a medicamentos ou alimentos?',
          ),
          onChanged: (value) => widget.model.allergies = value,
          validator:
              (value) => value!.isEmpty ? 'Informe se tem alergia' : null,
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Tem alguma doença?'),
          onChanged: (value) => widget.model.diseases = value,
          validator:
              (value) => value!.isEmpty ? 'Informe se tem alguma doença' : null,
        ),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Quais medicamentos em uso habitual/repetido?',
          ),
          onChanged: (value) => widget.model.medications = value,
          validator:
              (value) => value!.isEmpty ? 'Informe os medicamentos' : null,
        ),
        const SizedBox(height: 16),
        buildYesNoField(
          label: "Fuma?",
          groupValue: widget.model.smokes,
          onChanged: (v) => setState(() => widget.model.smokes = v),
        ),
        buildYesNoField(
          label: 'Usa alguma droga?',
          groupValue: widget.model.drugs,
          onChanged: (v) => setState(() => widget.model.drugs = v),
        ),
        buildYesNoField(
          label: 'Já esteve internado em UTI?',
          groupValue: widget.model.icuHistory,
          onChanged: (v) => setState(() => widget.model.icuHistory = v),
        ),
        buildYesNoField(
          label: 'Tem alguma perda de visão, audição ou movimento?',
          groupValue: widget.model.disabilities,
          onChanged: (v) => setState(() => widget.model.disabilities = v),
        ),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Quais cirurgias já fez?',
          ),
          onChanged: (value) => widget.model.previousSurgeries = value,
          validator:
              (value) =>
                  value!.isEmpty ? 'Informe suas cirurgias anteriores' : null,
        ),
        TextFormField(
          decoration: const InputDecoration(
            labelText:
                'Nas suas cirurgias prévias teve náusea ou vômito no pós-operatório? Houve alguma complicação?',
          ),
          onChanged: (value) => widget.model.postOpComplications = value,
          validator:
              (value) =>
                  value!.isEmpty
                      ? 'Informe se houve complicações em cirurgias anteriores'
                      : null,
        ),
        const SizedBox(height: 16),
        buildYesNoField(
          label:
              'Alguma história familiar de complicação anestésica grave em parente de 1º grau?',
          groupValue: widget.model.familyAnesthesiaHistory,
          onChanged:
              (v) => setState(() => widget.model.familyAnesthesiaHistory = v),
        ),
      ],
    );
  }
}
