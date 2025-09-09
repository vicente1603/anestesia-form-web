import '../../../../common/ui_state.dart';
import '../../../features.dart';
import 'package:flutter/material.dart';

class DoctorPage extends StatefulWidget {
  final DoctorPresenter doctorPresenter;
  final SecretariesPresenter secretariesPresenter;
  final PatientsPresenter patientsPresenter;
  final LoginPresenter loginPresenter;

  const DoctorPage({
    super.key,
    required this.doctorPresenter,
    required this.secretariesPresenter,
    required this.patientsPresenter,
    required this.loginPresenter,
  });

  @override
  State<DoctorPage> createState() => _DoctorPageState();
}

class _DoctorPageState extends State<DoctorPage> {
  @override
  void initState() {
    getSecretaries();
    getPatients();

    super.initState();
  }

  Future<void> getSecretaries() async {
    await widget.secretariesPresenter.init();
    await widget.secretariesPresenter.getDoctorId();
    await widget.secretariesPresenter.getSecretaries();
  }

  Future<void> getPatients() async {
    await widget.patientsPresenter.init();
    await widget.patientsPresenter.getDoctorId();
    await widget.patientsPresenter.getPatients();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          elevation: 10.0,
          surfaceTintColor: Colors.transparent,
          automaticallyImplyLeading: false,
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Área do Médico',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.logout, color: Colors.blueGrey),
                  tooltip: 'Sair',
                  onPressed: () async {
                    await widget.loginPresenter.signOut();
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final shouldRefresh = await Navigator.pushNamed(
            context,
            '/register-secretary',
          );

          if (shouldRefresh == true) {
            setState(() {
              getSecretaries();
            });
          }
        },
        label: const Text("Criar Secretária"),
        icon: const Icon(Icons.person_add_alt_1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(
              'Pacientes',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: color.primary,
              ),
            ),
            const SizedBox(height: 12),

            ValueListenableBuilder(
              valueListenable: widget.patientsPresenter.state,
              builder: (context, state, _) {
                if (state is UILoadingState) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  if (widget.patientsPresenter.patients.value.isEmpty) {
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text('Nenhum paciente encontrado'),
                        ),
                      ),
                    );
                  } else {
                    return Column(
                      children:
                          widget.patientsPresenter.patients.value
                              .map(
                                (patient) => Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ListTile(
                                    leading: const Icon(Icons.person_outline),
                                    title: Text(patient.fullName),
                                    subtitle: Text(patient.email),
                                    trailing: const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 16,
                                    ),
                                    onTap: () async {
                                      final shouldRefresh =
                                          await Navigator.pushNamed(
                                            context,
                                            '/patient-detail',
                                            arguments: {'patient': patient},
                                          );

                                      if (shouldRefresh == true) {
                                        setState(() {
                                          getPatients();
                                        });
                                      }
                                    },
                                  ),
                                ),
                              )
                              .toList(),
                    );
                  }
                }
              },
            ),

            const SizedBox(height: 24),

            Text(
              'Secretárias',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: color.primary,
              ),
            ),
            const SizedBox(height: 12),

            ValueListenableBuilder(
              valueListenable: widget.secretariesPresenter.state,
              builder: (context, state, _) {
                if (state is UILoadingState) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  if (widget.secretariesPresenter.secretaries.value.isEmpty) {
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text('Nenhuma secretária encontrada'),
                        ),
                      ),
                    );
                  } else {
                    return Column(
                      children:
                          widget.secretariesPresenter.secretaries.value
                              .map(
                                (secretary) => Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ListTile(
                                    leading: const Icon(Icons.person_outline),
                                    title: Text(secretary.fullName),
                                    subtitle: Text(secretary.email),
                                    trailing: const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 16,
                                    ),

                                    onTap: () async {
                                      final shouldRefresh =
                                          await Navigator.pushNamed(
                                            context,
                                            '/secretary-detail',
                                            arguments: {'secretary': secretary},
                                          );

                                      if (shouldRefresh == true) {
                                        setState(() {
                                          getSecretaries();
                                        });
                                      }
                                    },
                                  ),
                                ),
                              )
                              .toList(),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
