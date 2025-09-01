import 'dart:html' as html;
import 'package:anestesia_web/src/common/ui_state.dart';
import 'package:flutter/material.dart';
import '../../../features.dart';
import 'package:intl/intl.dart';

class HomeAdminPage extends StatefulWidget {
  final LoginAdminPresenter presenter;

  const HomeAdminPage({super.key, required this.presenter});

  @override
  State<HomeAdminPage> createState() => _HomeAdminPageState();
}

class _HomeAdminPageState extends State<HomeAdminPage> {
  final formKey = GlobalKey<FormState>();

  static final emailController = TextEditingController();
  static final passwordController = TextEditingController();

  @override
  void initState() {
    widget.presenter.init();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;

    return Scaffold(
      backgroundColor: color.background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Home',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: color.onBackground.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
