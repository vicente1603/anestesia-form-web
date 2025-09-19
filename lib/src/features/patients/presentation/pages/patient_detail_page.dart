import 'package:flutter/material.dart';
import '../../../features.dart';

extension FormDataMapper on FormDataEntity {
  FormDataModel toModel() {
    return FormDataModel(
      surgery: surgery,
      surgeon: surgeon,
      hospital: hospital,
      gender: gender,
      weight: weight,
      height: height,
      allergiesDetail: allergiesDetail,
      diseasesDetail: diseasesDetail,
      medicationsDetail: medicationsDetail,
      drugsDetail: drugsDetail,
      icuHistoryDetail: icuHistoryDetail,
      disabilitiesDetail: disabilitiesDetail,
      previousSurgeriesDetail: previousSurgeriesDetail,
      postOpComplications: postOpComplications,
      familyAnesthesiaHistory: familyAnesthesiaHistory,
      formId: formId,
      formStatus: formStatus,
      token: token,
      createAt: createAt,
      updatedAt: updatedAt,
    );
  }
}

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
  late List<FormDataEntity> sentForms;
  late List<FormDataEntity> pendingForms;

  // Cada form terá seu próprio TextEditingController set
  late Map<String, Map<String, TextEditingController>> formControllers;
  late Map<String, FormDataModel> formModels;
  late Map<String, bool> isEditingFormMap;

  @override
  void initState() {
    super.initState();
    _separateForms();
    _initializeControllers();
  }

  void _separateForms() {
    sentForms =
        widget.patient.forms.where((f) => f.formStatus == 'send').toList();
    pendingForms =
        widget.patient.forms.where((f) => f.formStatus == 'pending').toList();
  }

  void _initializeControllers() {
    formControllers = {};
    formModels = {};
    isEditingFormMap = {};

    for (var form in sentForms) {
      final model = form.toModel();
      formModels[form.formId] = model;
      isEditingFormMap[form.formId] = false;

      formControllers[form.formId] = {
        'surgery': TextEditingController(text: model.surgery),
        'surgeon': TextEditingController(text: model.surgeon),
        'hospital': TextEditingController(text: model.hospital),
        'gender': TextEditingController(text: model.gender),
        'weight': TextEditingController(text: model.weight?.toString() ?? ''),
        'height': TextEditingController(text: model.height?.toString() ?? ''),
        'allergiesDetail': TextEditingController(text: model.allergiesDetail),
        'diseasesDetail': TextEditingController(text: model.diseasesDetail),
        'medicationsDetail': TextEditingController(
          text: model.medicationsDetail,
        ),
        'drugsDetail': TextEditingController(text: model.drugsDetail),
        'icuHistoryDetail': TextEditingController(text: model.icuHistoryDetail),
        'disabilitiesDetail': TextEditingController(
          text: model.disabilitiesDetail,
        ),
        'previousSurgeriesDetail': TextEditingController(
          text: model.previousSurgeriesDetail,
        ),
        'postOpComplications': TextEditingController(
          text: model.postOpComplications,
        ),
        'familyAnesthesiaHistory': TextEditingController(
          text: model.familyAnesthesiaHistory,
        ),
      };
    }
  }

  @override
  void dispose() {
    for (var controllers in formControllers.values) {
      for (var c in controllers.values) {
        c.dispose();
      }
    }
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
              _buildInfoTile('Nome', widget.patient.fullName),
              _buildInfoTile('CPF', widget.patient.cpf),
              _buildInfoTile(
                'Convênio médico',
                widget.patient.medicalInsurance,
              ),
              _buildInfoTile('E-mail', widget.patient.email),
              _buildInfoTile('Telefone', widget.patient.phone),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 24),

              /// Botão gerar link
              pendingForms.isNotEmpty
                  ? ElevatedButton(
                    onPressed: null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("Já existe link pendente"),
                  )
                  : ElevatedButton(
                    onPressed:
                        () => widget.patientsPresenter.generateFormLink(
                          context,
                          widget.patient.id,
                        ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: color.primary,
                      foregroundColor: color.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("Gerar link para paciente"),
                  ),
              const SizedBox(height: 24),

              /// Lista de formulários enviados
              if (sentForms.isNotEmpty) ...[
                Text(
                  "Formulários enviados:",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ...sentForms.map((form) => _buildFormCard(form, color)),
              ],

              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 24),

              /// Botão excluir paciente
              ElevatedButton(
                onPressed: _confirmDeletePatient,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: color.error,
                  foregroundColor: color.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Excluir paciente",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormCard(FormDataEntity form, ColorScheme color) {
    final controllers = formControllers[form.formId]!;
    final model = formModels[form.formId]!;
    final isEditing = isEditingFormMap[form.formId]!;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Formulário #${form.formId}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    if (isEditing)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: OutlinedButton(
                          onPressed: () => _cancelEdit(form.formId),
                          child: const Text("Cancelar"),
                        ),
                      ),
                    ElevatedButton(
                      onPressed: () {
                        if (isEditing) {
                          _saveForm(form.formId);
                        } else {
                          setState(() => isEditingFormMap[form.formId] = true);
                        }
                      },
                      child: Text(
                        isEditing ? "Salvar formulário" : "Editar formulário",
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),

            /// Campos do formulário
            _buildFormField("Cirurgia", controllers['surgery']!, isEditing),
            _buildFormField("Cirurgião", controllers['surgeon']!, isEditing),
            _buildFormField("Hospital", controllers['hospital']!, isEditing),
            _buildFormField("Sexo", controllers['gender']!, isEditing),
            _buildFormField("Peso (kg)", controllers['weight']!, isEditing),
            _buildFormField("Altura (cm)", controllers['height']!, isEditing),
            _buildFormField(
              "Detalhes alergias",
              controllers['allergiesDetail']!,
              isEditing,
            ),
            _buildFormField(
              "Detalhes doenças",
              controllers['diseasesDetail']!,
              isEditing,
            ),
            _buildFormField(
              "Medicamentos",
              controllers['medicationsDetail']!,
              isEditing,
            ),
            _buildFormField(
              "Detalhes drogas",
              controllers['drugsDetail']!,
              isEditing,
            ),
            _buildFormField(
              "Detalhes UTI",
              controllers['icuHistoryDetail']!,
              isEditing,
            ),
            _buildFormField(
              "Detalhes deficiências",
              controllers['disabilitiesDetail']!,
              isEditing,
            ),
            _buildFormField(
              "Detalhes cirurgias anteriores",
              controllers['previousSurgeriesDetail']!,
              isEditing,
            ),
            _buildFormField(
              "Complicações pós-operatórias",
              controllers['postOpComplications']!,
              isEditing,
            ),
            _buildFormField(
              "Histórico familiar de anestesia",
              controllers['familyAnesthesiaHistory']!,
              isEditing,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormField(
    String label,
    TextEditingController controller,
    bool isEditing,
  ) {
    if (isEditing) {
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
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$label: ",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: Text(controller.text.isNotEmpty ? controller.text : "-"),
            ),
          ],
        ),
      );
    }
  }

  void _saveForm(String formId) {
    final controllers = formControllers[formId]!;
    final updatedForm = formModels[formId]!.copyWith(
      surgery: controllers['surgery']!.text,
      surgeon: controllers['surgeon']!.text,
      hospital: controllers['hospital']!.text,
      gender: controllers['gender']!.text,
      weight: double.tryParse(controllers['weight']!.text),
      height: double.tryParse(controllers['height']!.text),
      allergiesDetail: controllers['allergiesDetail']!.text,
      diseasesDetail: controllers['diseasesDetail']!.text,
      medicationsDetail: controllers['medicationsDetail']!.text,
      drugsDetail: controllers['drugsDetail']!.text,
      icuHistoryDetail: controllers['icuHistoryDetail']!.text,
      disabilitiesDetail: controllers['disabilitiesDetail']!.text,
      previousSurgeriesDetail: controllers['previousSurgeriesDetail']!.text,
      postOpComplications: controllers['postOpComplications']!.text,
      familyAnesthesiaHistory: controllers['familyAnesthesiaHistory']!.text,
    );

    widget.patientFormPresenter.update(updatedForm);

    setState(() {
      formModels[formId] = updatedForm;
      isEditingFormMap[formId] = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Formulário atualizado com sucesso!')),
    );
  }

  void _cancelEdit(String formId) {
    final model = formModels[formId]!;
    final controllers = formControllers[formId]!;

    controllers['surgery']!.text = model.surgery ?? '';
    controllers['surgeon']!.text = model.surgeon ?? '';
    controllers['hospital']!.text = model.hospital ?? '';
    controllers['gender']!.text = model.gender ?? '';
    controllers['weight']!.text = model.weight?.toString() ?? '';
    controllers['height']!.text = model.height?.toString() ?? '';
    controllers['allergiesDetail']!.text = model.allergiesDetail ?? '';
    controllers['diseasesDetail']!.text = model.diseasesDetail ?? '';
    controllers['medicationsDetail']!.text = model.medicationsDetail ?? '';
    controllers['drugsDetail']!.text = model.drugsDetail ?? '';
    controllers['icuHistoryDetail']!.text = model.icuHistoryDetail ?? '';
    controllers['disabilitiesDetail']!.text = model.disabilitiesDetail ?? '';
    controllers['previousSurgeriesDetail']!.text =
        model.previousSurgeriesDetail ?? '';
    controllers['postOpComplications']!.text = model.postOpComplications ?? '';
    controllers['familyAnesthesiaHistory']!.text =
        model.familyAnesthesiaHistory ?? '';

    setState(() {
      isEditingFormMap[formId] = false;
    });
  }

  void _confirmDeletePatient() async {
    final color = Theme.of(context).colorScheme;

    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
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
                style: TextButton.styleFrom(foregroundColor: color.onSurface),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
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
          ),
    );

    if (confirmed == true) {
      widget.patientsPresenter.deletePatient(widget.patient);
      if (context.mounted) Navigator.pop(context, true);
    }
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
}
