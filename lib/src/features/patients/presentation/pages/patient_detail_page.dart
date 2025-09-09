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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),

            _buildInfoTile('Nome', widget.patient.fullName),
            _buildInfoTile('CPF', widget.patient.cpf),
            _buildInfoTile('E-mail', widget.patient.email),
            _buildInfoTile('Telefone', widget.patient.phone),

            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: () async {
                widget.presenter.sendLink(widget.patient.token ?? '');
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: color.primary,
                foregroundColor: color.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Enviar link', style: TextStyle(fontSize: 16)),
            ),
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
    );
  }

  Widget _buildInfoTile(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value ?? 'Não informado')),
        ],
      ),
    );
  }
}
