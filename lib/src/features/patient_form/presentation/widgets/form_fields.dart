import 'package:flutter/material.dart';

import '../../../features.dart';

class FormFields extends StatefulWidget {
  final PatientFormPresenter presenter;
  const FormFields({super.key, required this.presenter});

  @override
  State<FormFields> createState() => _FormFieldsState();
}

class _FormFieldsState extends State<FormFields> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final entity = widget.presenter.formDataEntity;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- INFORMAÇÕES DA CIRURGIA ---
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      "Informações da cirurgia",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),

                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Qual cirurgia vai realizar?',
                      ),
                      onChanged:
                          (v) =>
                              widget.presenter.formDataEntity = entity.copyWith(
                                surgery: v,
                              ),
                      validator:
                          (v) =>
                              v!.isEmpty
                                  ? 'Informe qual cirurgia vai realizar'
                                  : null,
                    ),

                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Nome do cirurgião',
                      ),
                      onChanged:
                          (v) =>
                              widget.presenter.formDataEntity = entity.copyWith(
                                surgeon: v,
                              ),
                      validator:
                          (v) => v!.isEmpty ? 'Informe o cirurgião' : null,
                    ),

                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Hospital que vai se operar',
                      ),
                      onChanged:
                          (v) =>
                              widget.presenter.formDataEntity = entity.copyWith(
                                hospital: v,
                              ),
                      validator:
                          (v) => v!.isEmpty ? 'Informe o hospital' : null,
                    ),

                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Sexo'),
                      items: const [
                        DropdownMenuItem(value: 'M', child: Text('Masculino')),
                        DropdownMenuItem(value: 'F', child: Text('Feminino')),
                      ],
                      value: entity.gender,
                      onChanged:
                          (v) => setState(
                            () =>
                                widget.presenter.formDataEntity = entity
                                    .copyWith(gender: v),
                          ),
                      validator: (v) => v == null ? 'Selecione o sexo' : null,
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Peso (kg)',
                            ),
                            keyboardType: TextInputType.number,
                            onChanged:
                                (v) =>
                                    widget.presenter.formDataEntity = entity
                                        .copyWith(weight: double.tryParse(v)),
                            validator:
                                (v) => v!.isEmpty ? 'Informe o peso' : null,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Altura (cm)',
                            ),
                            keyboardType: TextInputType.number,
                            onChanged:
                                (v) =>
                                    widget.presenter.formDataEntity = entity
                                        .copyWith(height: double.tryParse(v)),
                            validator:
                                (v) => v!.isEmpty ? 'Informe a altura' : null,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // --- HISTÓRICO MÉDICO ---
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      "Histórico médico",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),

                    buildYesNoField(
                      label: "Tem alguma alergia a medicamentos ou alimentos?",
                      groupValue: entity.hasAllergies,
                      onChanged:
                          (v) => setState(
                            () =>
                                widget.presenter.formDataEntity = entity
                                    .copyWith(hasAllergies: v),
                          ),
                      textValue: entity.allergiesDetail,
                      onTextChanged:
                          (v) =>
                              widget.presenter.formDataEntity = entity.copyWith(
                                allergiesDetail: v,
                              ),
                      textLabel: "Quais?",
                    ),

                    buildYesNoField(
                      label: "Tem alguma doença?",
                      groupValue: entity.hasDiseases,
                      onChanged:
                          (v) => setState(
                            () =>
                                widget.presenter.formDataEntity = entity
                                    .copyWith(hasDiseases: v),
                          ),
                      textValue: entity.diseasesDetail,
                      onTextChanged:
                          (v) =>
                              widget.presenter.formDataEntity = entity.copyWith(
                                diseasesDetail: v,
                              ),
                      textLabel: "Qual(is)?",
                    ),

                    buildYesNoField(
                      label: "Usa medicamentos de uso habitual/repetido?",
                      groupValue: entity.usesMedication,
                      onChanged:
                          (v) => setState(
                            () =>
                                widget.presenter.formDataEntity = entity
                                    .copyWith(usesMedication: v),
                          ),
                      textValue: entity.medicationsDetail,
                      onTextChanged:
                          (v) =>
                              widget.presenter.formDataEntity = entity.copyWith(
                                medicationsDetail: v,
                              ),
                      textLabel: "Quais e horários de uso?",
                    ),

                    buildYesNoField(
                      label: "Já fez cirurgias prévias?",
                      groupValue: entity.hasPreviousSurgeries,
                      onChanged:
                          (v) => setState(
                            () =>
                                widget.presenter.formDataEntity = entity
                                    .copyWith(hasPreviousSurgeries: v),
                          ),
                      textValue: entity.previousSurgeriesDetail,
                      onTextChanged:
                          (v) =>
                              widget.presenter.formDataEntity = entity.copyWith(
                                previousSurgeriesDetail: v,
                              ),
                      textLabel: "Quais?",
                    ),

                    buildYesNoField(
                      label: "Tem alguma perda de visão, audição ou movimento?",
                      groupValue: entity.disabilities,
                      onChanged:
                          (v) => setState(
                            () =>
                                widget.presenter.formDataEntity = entity
                                    .copyWith(disabilities: v),
                          ),
                      textValue: entity.disabilitiesDetail,
                      onTextChanged:
                          (v) =>
                              widget.presenter.formDataEntity = entity.copyWith(
                                disabilitiesDetail: v,
                              ),
                      textLabel: "Detalhe a perda",
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // --- HÁBITOS E HISTÓRICO ---
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      "Hábitos e histórico",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),

                    buildYesNoField(
                      label: "Fuma?",
                      groupValue: entity.smokes,
                      onChanged:
                          (v) => setState(
                            () =>
                                widget.presenter.formDataEntity = entity
                                    .copyWith(smokes: v),
                          ),
                    ),

                    buildYesNoField(
                      label: "Usa drogas?",
                      groupValue: entity.usesDrugs,
                      onChanged:
                          (v) => setState(
                            () =>
                                widget.presenter.formDataEntity = entity
                                    .copyWith(usesDrugs: v),
                          ),
                      textValue: entity.drugsDetail,
                      onTextChanged:
                          (v) =>
                              widget.presenter.formDataEntity = entity.copyWith(
                                drugsDetail: v,
                              ),
                      textLabel: "Quais?",
                    ),

                    // Histórico de UTI
                    buildYesNoField(
                      label: "Já teve histórico de internação em UTI?",
                      groupValue: widget.presenter.formDataEntity.icuHistory,
                      onChanged:
                          (v) => setState(() {
                            widget.presenter.formDataEntity = widget
                                .presenter
                                .formDataEntity
                                .copyWith(icuHistory: v);
                          }),
                      textValue:
                          widget.presenter.formDataEntity.icuHistoryDetail,
                      onTextChanged:
                          (v) =>
                              widget.presenter.formDataEntity = widget
                                  .presenter
                                  .formDataEntity
                                  .copyWith(icuHistoryDetail: v),
                      textLabel: "Detalhe",
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // --- INFORMAÇÕES ADICIONAIS ---
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      "Informações adicionais",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),

                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Complicações pós-operatórias',
                      ),
                      initialValue: entity.postOpComplications,
                      onChanged:
                          (v) =>
                              widget.presenter.formDataEntity = entity.copyWith(
                                postOpComplications: v,
                              ),
                    ),

                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Histórico familiar de anestesia',
                      ),
                      initialValue: entity.familyAnesthesiaHistory,
                      onChanged:
                          (v) =>
                              widget.presenter.formDataEntity = entity.copyWith(
                                familyAnesthesiaHistory: v,
                              ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
