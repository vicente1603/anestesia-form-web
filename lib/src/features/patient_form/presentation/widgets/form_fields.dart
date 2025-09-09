import 'package:flutter/material.dart';
import '../../../features.dart';

class FormFields extends StatefulWidget {
  final PatientFormPresenter presenter;
  const FormFields({super.key, required this.presenter});

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
          onChanged:
              (value) =>
                  widget.presenter.formDataEntity = widget
                      .presenter
                      .formDataEntity
                      .copyWith(surgery: value),
          validator:
              (value) =>
                  value!.isEmpty ? 'Informe qual cirurgia vai realizar' : null,
        ),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Quem é o seu cirurgião?',
          ),
          onChanged:
              (value) =>
                  widget.presenter.formDataEntity = widget
                      .presenter
                      .formDataEntity
                      .copyWith(surgeon: value),

          validator:
              (value) => value!.isEmpty ? 'Informe o nome do cirurgião' : null,
        ),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Tem alguma alergia a medicamentos ou alimentos?',
          ),
          onChanged:
              (value) =>
                  widget.presenter.formDataEntity = widget
                      .presenter
                      .formDataEntity
                      .copyWith(allergies: value),
          validator:
              (value) => value!.isEmpty ? 'Informe se tem alergia' : null,
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Tem alguma doença?'),
          onChanged:
              (value) =>
                  widget.presenter.formDataEntity = widget
                      .presenter
                      .formDataEntity
                      .copyWith(diseases: value),
          validator:
              (value) => value!.isEmpty ? 'Informe se tem alguma doença' : null,
        ),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Quais medicamentos em uso habitual/repetido?',
          ),
          onChanged:
              (value) =>
                  widget.presenter.formDataEntity = widget
                      .presenter
                      .formDataEntity
                      .copyWith(medications: value),
          validator:
              (value) => value!.isEmpty ? 'Informe os medicamentos' : null,
        ),
        const SizedBox(height: 16),
        buildYesNoField(
          label: "Fuma?",
          groupValue: widget.presenter.formDataEntity.smokes,
          onChanged:
              (v) => setState(
                () =>
                    widget.presenter.formDataEntity = widget
                        .presenter
                        .formDataEntity
                        .copyWith(smokes: v),
              ),
        ),

        buildYesNoField(
          label: 'Usa alguma droga?',
          groupValue: widget.presenter.formDataEntity.drugs,
          onChanged:
              (v) => setState(() {
                widget.presenter.formDataEntity = widget
                    .presenter
                    .formDataEntity
                    .copyWith(drugs: v);
              }),
          textValue: widget.presenter.formDataEntity.drugsDetail,
          onTextChanged: (v) {
            widget.presenter.formDataEntity = widget.presenter.formDataEntity
                .copyWith(drugsDetail: v);
          },
          textLabel: "Qual(is)?",
        ),

        buildYesNoField(
          label: 'Já esteve internado em UTI?',
          groupValue: widget.presenter.formDataEntity.icuHistory,
          onChanged:
              (v) => setState(
                () =>
                    widget.presenter.formDataEntity = widget
                        .presenter
                        .formDataEntity
                        .copyWith(icuHistory: v),
              ),
        ),
        buildYesNoField(
          label: 'Tem alguma perda de visão, audição ou movimento?',
          groupValue: widget.presenter.formDataEntity.disabilities,
          onChanged:
              (v) => setState(
                () =>
                    widget.presenter.formDataEntity = widget
                        .presenter
                        .formDataEntity
                        .copyWith(disabilities: v),
              ),
        ),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Quais cirurgias já fez?',
          ),
          onChanged:
              (value) =>
                  widget.presenter.formDataEntity = widget
                      .presenter
                      .formDataEntity
                      .copyWith(previousSurgeries: value),
          validator:
              (value) =>
                  value!.isEmpty ? 'Informe suas cirurgias anteriores' : null,
        ),
        TextFormField(
          decoration: const InputDecoration(
            labelText:
                'Nas suas cirurgias prévias teve náusea ou vômito no pós-operatório? Houve alguma complicação?',
          ),
          onChanged:
              (value) =>
                  widget.presenter.formDataEntity = widget
                      .presenter
                      .formDataEntity
                      .copyWith(postOpComplications: value),
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
          groupValue: widget.presenter.formDataEntity.familyAnesthesiaHistory,
          onChanged:
              (v) => setState(
                () =>
                    widget.presenter.formDataEntity = widget
                        .presenter
                        .formDataEntity
                        .copyWith(familyAnesthesiaHistory: v),
              ),
        ),
      ],
    );
  }
}
