import 'package:anestesia_web/src/common/ui_state.dart';
import 'package:flutter/material.dart';
import '../../../features.dart';

class AdminHomePage extends StatefulWidget {
  final AdminPresenter adminPresenter;
  final LoginPresenter loginPresenter;

  const AdminHomePage({
    super.key,
    required this.adminPresenter,
    required this.loginPresenter,
  });

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  @override
  void initState() {
    super.initState();
    widget.adminPresenter.init();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.adminPresenter.getDoctors();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;

    return Scaffold(
      backgroundColor: color.surfaceVariant.withOpacity(0.05),

      appBar: AppBar(
        backgroundColor: color.primary,
        foregroundColor: color.onPrimary,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Gestão de Médicos"),
            ElevatedButton.icon(
              onPressed: () async {
                final shouldRefresh = await Navigator.pushNamed(
                  context,
                  '/register-doctor',
                );

                if (shouldRefresh == true) {
                  setState(() {
                    widget.adminPresenter.getDoctors();
                  });
                }
              },
              icon: const Icon(Icons.add),
              label: const Text("Cadastrar Médico"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.blueGrey),
              tooltip: 'Sair',
              onPressed: () async {
                await widget.loginPresenter.signOut();
                Navigator.pushReplacementNamed(context, '/admin-login');
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),

            Expanded(
              child: ValueListenableBuilder(
                valueListenable: widget.adminPresenter.state,
                builder: (context, state, _) {
                  if (state is UILoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return ValueListenableBuilder<List<DoctorEntity>>(
                    valueListenable: widget.adminPresenter.doctors,
                    builder: (context, doctors, _) {
                      if (doctors.isEmpty) {
                        return const Center(
                          child: Text("Nenhum médico cadastrado."),
                        );
                      }

                      return Container(
                        decoration: BoxDecoration(
                          color: color.surface,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: SingleChildScrollView(
                          child: DataTable(
                            headingRowColor: MaterialStateProperty.all(
                              color.primary.withOpacity(0.1),
                            ),
                            columns: const [
                              DataColumn(label: Text("Nome")),
                              DataColumn(label: Text("CRM")),
                              DataColumn(label: Text("E-mail")),
                              DataColumn(label: Text("Habilitado")),
                            ],
                            rows:
                                doctors.map((doctor) {
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(doctor.fullName)),
                                      DataCell(Text(doctor.crm)),
                                      DataCell(Text(doctor.email)),
                                      DataCell(
                                        Switch(
                                          value: true,
                                          onChanged:
                                              (value) => widget.adminPresenter
                                                  .disableDoctor(doctor),
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
