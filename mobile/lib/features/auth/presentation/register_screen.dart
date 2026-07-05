import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_date_field.dart';
import '../../../shared/widgets/app_link.dart';
import '../../../shared/widgets/app_text_field.dart';
import 'auth_notifier.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  DateTime? _birthDate;
  bool _showDateError = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final formValid = _formKey.currentState?.validate() ?? false;
    if (_birthDate == null) setState(() => _showDateError = true);
    if (!formValid || _birthDate == null) return;

    await ref.read(authNotifierProvider.notifier).signUp(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          username: _usernameController.text.trim(),
          birthDate: _birthDate!,
        );

    if (!mounted) return;

    final error = ref.read(authNotifierProvider).error;
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authNotifierProvider).isLoading;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('Registrati'),
        titleTextStyle: const TextStyle(
          fontFamily: 'OpenRunde',
          fontSize: 36,
          fontWeight: FontWeight.w700,
          color: AppColors.mainContrast,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  AppTextField(
                    label: 'Username',
                    hint: 'Username',
                    controller: _usernameController,
                    textInputAction: TextInputAction.next,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Inserisci username';
                      }
                      if (v.trim().length < 3) return 'Minimo 3 caratteri';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    label: 'Email',
                    hint: 'Email',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Inserisci email';
                      }
                      if (!v.contains('@')) return 'Email non valida';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    label: 'Password',
                    hint: '••••••••',
                    controller: _passwordController,
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Inserisci password';
                      if (v.length < 6) return 'Minimo 6 caratteri';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  AppDateField(
                    label: 'Data di nascita',
                    value: _birthDate,
                    onChanged: (d) => setState(() {
                      _birthDate = d;
                      _showDateError = false;
                    }),
                    errorText: _showDateError ? 'Seleziona la data di nascita' : null,
                  ),
                  const SizedBox(height: 32),
                  AppButton(
                    label: 'Registrati',
                    onPressed: _submit,
                    isLoading: isLoading,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: AppLink(
                text: 'Hai già un account? ',
                linkText: 'Accedi',
                onTap: () => context.go('/login'),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
