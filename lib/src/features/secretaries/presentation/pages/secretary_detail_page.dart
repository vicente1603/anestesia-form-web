import 'package:flutter/material.dart';
import '../../../features.dart';

class SecretaryDetailPage extends StatefulWidget {
  final GetSecretaryModel secretary;
  final SecretariesPresenter presenter;

  const SecretaryDetailPage({
    super.key,
    required this.secretary,
    required this.presenter,
  });

  @override
  State<SecretaryDetailPage> createState() => _RegisterPacientPageState();
}

class _RegisterPacientPageState extends State<SecretaryDetailPage> {
  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text('Detalhes da Secretária')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),

            _buildInfoTile('Nome', widget.secretary.fullName),
            _buildInfoTile('CPF', widget.secretary.cpf),
            _buildInfoTile('E-mail', widget.secretary.email),
            _buildInfoTile(
              'Data de cadastro',
              widget.secretary.createdAt?.toString() ?? 'Não informado',
            ),

            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 24),

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
                        'Excluir secretária',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      content: const Text(
                        'Tem certeza que deseja excluir esta secretária?',
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
                  widget.presenter.deleteSecretary(widget.secretary);

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
                'Excluir secretária',
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
