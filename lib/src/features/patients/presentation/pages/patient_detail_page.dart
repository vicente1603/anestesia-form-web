import 'package:flutter/material.dart';
import '../../../features.dart';

class PatientDetailPage extends StatefulWidget {
  final GetPatientModel patient;
  final PatientsPresenter patientsPresenter;
  final PatientFormPresenter patientFormPresenter;

  const PatientDetailPage({
    super.key,
    required this.patient,
    required this.patientsPresenter,
    required this.patientFormPresenter,
  });

  @override
  State<PatientDetailPage> createState() => _PatientDetailPageState();
}

class _PatientDetailPageState extends State<PatientDetailPage> {
  bool isEditingForm = false;

  late TextEditingController surgeryController;
  late TextEditingController surgeonController;
  late TextEditingController hospitalController;
  late TextEditingController genderController;
  late TextEditingController weightController;
  late TextEditingController heightController;
  late TextEditingController allergiesDetailController;
  late TextEditingController diseasesDetailController;
  late TextEditingController medicationsDetailController;
  late TextEditingController drugsDetailController;
  late TextEditingController icuHistoryDetailController;
  late TextEditingController disabilitiesDetailController;
  late TextEditingController previousSurgeriesDetailController;
  late TextEditingController postOpComplicationsController;
  late TextEditingController familyAnesthesiaHistoryController;

  late FormDataModel formModel;

  @override
  void initState() {
    super.initState();

    if (widget.patient.form != null) {
      formModel = widget.patient.form as FormDataModel;

      surgeryController = TextEditingController(text: formModel.surgery);
      surgeonController = TextEditingController(text: formModel.surgeon);
      hospitalController = TextEditingController(text: formModel.hospital);
      genderController = TextEditingController(text: formModel.gender);
      weightController = TextEditingController(
        text: formModel.weight.toString(),
      );
      heightController = TextEditingController(
        text: formModel.height.toString(),
      );
      allergiesDetailController = TextEditingController(
        text: formModel.allergiesDetail,
      );
      diseasesDetailController = TextEditingController(
        text: formModel.diseasesDetail,
      );
      medicationsDetailController = TextEditingController(
        text: formModel.medicationsDetail,
      );
      drugsDetailController = TextEditingController(
        text: formModel.drugsDetail,
      );
      icuHistoryDetailController = TextEditingController(
        text: formModel.icuHistoryDetail,
      );
      disabilitiesDetailController = TextEditingController(
        text: formModel.disabilitiesDetail,
      );
      previousSurgeriesDetailController = TextEditingController(
        text: formModel.previousSurgeriesDetail,
      );
      postOpComplicationsController = TextEditingController(
        text: formModel.postOpComplications,
      );
      familyAnesthesiaHistoryController = TextEditingController(
        text: formModel.familyAnesthesiaHistory,
      );
    }
  }

  @override
  void dispose() {
    surgeryController.dispose();
    surgeonController.dispose();
    hospitalController.dispose();
    genderController.dispose();
    weightController.dispose();
    heightController.dispose();
    allergiesDetailController.dispose();
    diseasesDetailController.dispose();
    medicationsDetailController.dispose();
    drugsDetailController.dispose();
    icuHistoryDetailController.dispose();
    disabilitiesDetailController.dispose();
    previousSurgeriesDetailController.dispose();
    postOpComplicationsController.dispose();
    familyAnesthesiaHistoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes do Paciente')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),

              _buildInfoTile('Nome', widget.patient.fullName),
              _buildInfoTile('CPF', widget.patient.cpf),
              _buildInfoTile(
                'Convênio médico',
                widget.patient.medicalInsurance,
              ),
              _buildInfoTile('E-mail', widget.patient.email),
              _buildInfoTile('Telefone', widget.patient.phone),

              if (widget.patient.form != null) _buildFormSection(),

              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 24),

              widget.patient.formStatus == 'pending'
                  ? ElevatedButton(
                    onPressed:
                        () => widget.patientsPresenter.sendLink(
                          context,
                          widget.patient.token ?? '',
                        ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: color.primary,
                      foregroundColor: color.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Copiar link do formulário',
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                  : Container(),
              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      final color = Theme.of(context).colorScheme;

                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        title: const Text(
                          'Excluir paciente',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        content: const Text(
                          'Tem certeza que deseja excluir este paciente?',
                        ),
                        actionsPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            style: TextButton.styleFrom(
                              foregroundColor: color.onSurface,
                            ),
                            child: const Text('Cancelar'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: color.error,
                              foregroundColor: color.onPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Excluir'),
                          ),
                        ],
                      );
                    },
                  );

                  if (confirmed == true) {
                    widget.patientsPresenter.deletePatient(widget.patient);

                    if (context.mounted) {
                      Navigator.pop(context, true);
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: color.error,
                  foregroundColor: color.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Excluir paciente',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile(String label, dynamic value) {
    String displayValue;

    if (value == null) {
      displayValue = 'Não informado';
    } else if (value is bool) {
      displayValue = value ? 'Sim' : 'Não';
    } else {
      displayValue = value.toString();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(displayValue)),
        ],
      ),
    );
  }

  Widget _buildFormSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Divider(),
        const SizedBox(height: 16),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Formulário preenchido",
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                if (isEditingForm)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: OutlinedButton(
                      onPressed: _cancelEdit,
                      child: const Text('Cancelar'),
                    ),
                  ),
                ElevatedButton(
                  onPressed: () {
                    if (isEditingForm) {
                      _saveForm();
                    } else {
                      setState(() {
                        isEditingForm = true;
                      });
                    }
                  },
                  child: Text(
                    isEditingForm ? 'Salvar formulário' : 'Editar formulário',
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 12),

        _buildFormField("Cirurgia", surgeryController),
        _buildFormField("Cirurgião", surgeonController),
        _buildFormField("Hospital", hospitalController),
        _buildFormField("Sexo", genderController),
        _buildFormField("Peso (kg)", weightController),
        _buildFormField("Altura (cm)", heightController),
        _buildFormField("Detalhes alergias", allergiesDetailController),
        _buildFormField("Detalhes doenças", diseasesDetailController),
        _buildFormField("Medicamentos", medicationsDetailController),
        _buildFormField("Detalhes drogas", drugsDetailController),
        _buildFormField("Detalhes UTI", icuHistoryDetailController),
        _buildFormField("Detalhes deficiências", disabilitiesDetailController),
        _buildFormField(
          "Detalhes cirurgias anteriores",
          previousSurgeriesDetailController,
        ),
        _buildFormField(
          "Complicações pós-operatórias",
          postOpComplicationsController,
        ),
        _buildFormField(
          "Histórico familiar de anestesia",
          familyAnesthesiaHistoryController,
        ),
      ],
    );
  }

  Widget _buildFormField(String label, TextEditingController controller) {
    if (isEditingForm) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
        ),
      );
    } else {
      return _buildInfoTile(label, controller.text);
    }
  }

  void _saveForm() {
    final updatedForm = formModel.copyWith(
      surgery: surgeryController.text,
      surgeon: surgeonController.text,
      hospital: hospitalController.text,
      gender: genderController.text,
      weight: double.parse(weightController.text),
      height: double.parse(heightController.text),
      allergiesDetail: allergiesDetailController.text,
      diseasesDetail: diseasesDetailController.text,
      medicationsDetail: medicationsDetailController.text,
      drugsDetail: drugsDetailController.text,
      icuHistoryDetail: icuHistoryDetailController.text,
      disabilitiesDetail: disabilitiesDetailController.text,
      previousSurgeriesDetail: previousSurgeriesDetailController.text,
      postOpComplications: postOpComplicationsController.text,
      familyAnesthesiaHistory: familyAnesthesiaHistoryController.text,
    );

    widget.patientFormPresenter.update(updatedForm);

    setState(() {
      formModel = updatedForm;
      isEditingForm = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Formulário atualizado com sucesso!')),
    );
  }

  void _cancelEdit() {
    surgeryController.text = formModel.surgery ?? '';
    surgeonController.text = formModel.surgeon ?? '';
    hospitalController.text = formModel.hospital ?? '';
    genderController.text = formModel.gender ?? '';
    weightController.text = formModel.weight.toString();
    heightController.text = formModel.height.toString();
    allergiesDetailController.text = formModel.allergiesDetail ?? '';
    diseasesDetailController.text = formModel.diseasesDetail ?? '';
    medicationsDetailController.text = formModel.medicationsDetail ?? '';
    drugsDetailController.text = formModel.drugsDetail ?? '';
    icuHistoryDetailController.text = formModel.icuHistoryDetail ?? '';
    disabilitiesDetailController.text = formModel.disabilitiesDetail ?? '';
    previousSurgeriesDetailController.text =
        formModel.previousSurgeriesDetail ?? '';
    postOpComplicationsController.text = formModel.postOpComplications ?? '';
    familyAnesthesiaHistoryController.text =
        formModel.familyAnesthesiaHistory ?? '';

    setState(() {
      isEditingForm = false;
    });
  }
}
