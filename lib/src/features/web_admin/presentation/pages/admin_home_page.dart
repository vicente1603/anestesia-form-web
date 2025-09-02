import 'package:anestesia_web/src/common/ui_state.dart';
import 'package:flutter/material.dart';
import '../../../features.dart';

class AdminHomePage extends StatefulWidget {
  final AdminPresenter presenter;

  const AdminHomePage({super.key, required this.presenter});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  @override
  void initState() {
    super.initState();
    widget.presenter.init();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.presenter.getDoctors();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /// Header com título e botão de ação
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Gestão de Médicos",
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color.primary,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/register-doctor')
                          .then((_) => widget.presenter.getDoctors());
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("Cadastrar Médico"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              /// Área principal
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: widget.presenter.state,
                  builder: (context, state, _) {
                    if (state is UILoadingState) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return ValueListenableBuilder<List<DoctorEntity>>(
                      valueListenable: widget.presenter.doctors,
                      builder: (context, doctors, _) {
                        if (doctors.isEmpty) {
                          return const Center(
                              child: Text("Nenhum médico cadastrado."));
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
                              )
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
                                DataColumn(label: Text("Ações")),
                              ],
                              rows: doctors.map((doctor) {
                                return DataRow(cells: [
                                  DataCell(Text(doctor.fullName)),
                                  DataCell(Text(doctor.crm)),
                                  DataCell(Text(doctor.email)),
                                  DataCell(Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit,
                                            color: Colors.blue),
                                        onPressed: () {
                                          // editar médico
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () {
                                          // excluir médico
                                        },
                                      ),
                                    ],
                                  )),
                                ]);
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
      ),
    );
  }
}
