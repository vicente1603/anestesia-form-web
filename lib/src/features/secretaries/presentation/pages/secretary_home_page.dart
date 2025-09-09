import 'package:flutter/material.dart';

import '../../../../common/common.dart';
import '../../../features.dart';

class SecretaryPage extends StatefulWidget {
  final SecretariesPresenter secretariesPresenter;
  final DoctorPresenter doctorPresenter;
  final PatientsPresenter patientsPresenter;
  final LoginPresenter loginPresenter;

  const SecretaryPage({
    super.key,
    required this.secretariesPresenter,
    required this.doctorPresenter,
    required this.patientsPresenter,
    required this.loginPresenter,
  });

  @override
  State<SecretaryPage> createState() => _SecretaryPageState();
}

class _SecretaryPageState extends State<SecretaryPage> {
  @override
  void initState() {
    getDoctor();
    getPatients();

    super.initState();
  }

  Future<void> getDoctor() async {
    await widget.doctorPresenter.init();
    await widget.doctorPresenter.getsecretaryId();
    await widget.doctorPresenter.getDoctorIdBySecretary();
    await widget.doctorPresenter.getDoctor();
  }

  Future<void> getPatients() async {
    await widget.patientsPresenter.init();
    await widget.patientsPresenter.getSecretaryId();
    await widget.patientsPresenter.getDoctorIdBySecretary();
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
                  'Área da Secretária',
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
            '/register-patient',
          );

          if (shouldRefresh == true) {
            setState(() {
              getPatients();
            });
          }
        },
        label: const Text("Cadastrar Paciente"),
        icon: const Icon(Icons.person_add_alt_1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(
              'Médico Responsável',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: color.primary,
              ),
            ),
            const SizedBox(height: 12),

            ValueListenableBuilder(
              valueListenable: widget.doctorPresenter.state,
              builder: (context, state, _) {
                if (state is UILoadingState) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  final doctor = widget.doctorPresenter.doctor.value;
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.person_outline),
                      title: Text(doctor?.fullName ?? ''),
                      subtitle: Text(doctor?.email ?? ''),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {},
                    ),
                  );
                }
              },
            ),

            const SizedBox(height: 24),
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
          ],
        ),
      ),
    );
  }
}
