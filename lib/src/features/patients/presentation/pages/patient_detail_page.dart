import 'package:flutter/material.dart';
import '../../../features.dart';

class PatientDetailPage extends StatefulWidget {
  final GetPatientModel patient;
  final PatientsPresenter presenter;

  const PatientDetailPage({
    super.key,
    required this.patient,
    required this.presenter,
  });

  @override
  State<PatientDetailPage> createState() => _RegisterPacientPageState();
}

class _RegisterPacientPageState extends State<PatientDetailPage> {
  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text('Detalhes do Paciente')),
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

              if (widget.patient.form != null)
                _buildFormSection(widget.patient.form!),

              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 24),

              widget.patient.formStatus == 'pending'
                  ? ElevatedButton(
                    onPressed:
                        () => widget.presenter.sendLink(
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
                    widget.presenter.deletePatient(widget.patient);

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

  Widget _buildFormSection(FormDataEntity form) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Divider(),
        const SizedBox(height: 16),

        Text(
          "Formulário preenchido",
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        _buildInfoTile("Cirurgia", form.surgery),
        _buildInfoTile("Cirurgião", form.surgeon),
        _buildInfoTile("Hospital", form.hospital),
        _buildInfoTile("Sexo", form.gender),
        _buildInfoTile("Peso (kg)", form.weight),
        _buildInfoTile("Altura (cm)", form.height),

        _buildInfoTile("Possui alergias?", form.hasAllergies),
        _buildInfoTile("Detalhes das alergias", form.allergiesDetail),

        _buildInfoTile("Possui doenças?", form.hasDiseases),
        _buildInfoTile("Detalhes das doenças", form.diseasesDetail),

        _buildInfoTile("Usa medicação?", form.usesMedication),
        _buildInfoTile("Medicamentos", form.medicationsDetail),

        _buildInfoTile("Fumante?", form.smokes),
        _buildInfoTile("Usa drogas?", form.usesDrugs),
        _buildInfoTile("Detalhes drogas", form.drugsDetail),

        _buildInfoTile("Já ficou na UTI?", form.icuHistory),
        _buildInfoTile("Detalhes UTI", form.icuHistoryDetail),

        _buildInfoTile("Deficiências?", form.disabilities),
        _buildInfoTile("Detalhes deficiências", form.disabilitiesDetail),

        _buildInfoTile("Cirurgias anteriores?", form.hasPreviousSurgeries),
        _buildInfoTile(
          "Detalhes cirurgias anteriores",
          form.previousSurgeriesDetail,
        ),

        _buildInfoTile(
          "Complicações pós-operatórias",
          form.postOpComplications,
        ),
        _buildInfoTile(
          "Histórico familiar de anestesia",
          form.familyAnesthesiaHistory,
        ),
      ],
    );
  }
}
