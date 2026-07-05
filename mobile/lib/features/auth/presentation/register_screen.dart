import 'package:easy_localization/easy_localization.dart';
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
          content: Text('auth.register.error.sign_up_failed'.tr()),
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
        title: Text('auth.register.title'.tr()),
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
                    label: 'auth.register.username_label'.tr(),
                    hint: 'auth.register.username_hint'.tr(),
                    controller: _usernameController,
                    textInputAction: TextInputAction.next,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'auth.register.error.username_required'.tr();
                      }
                      if (v.trim().length < 3) {
                        return 'auth.register.error.username_min'.tr();
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    label: 'auth.register.email_label'.tr(),
                    hint: 'auth.register.email_hint'.tr(),
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'auth.register.error.email_required'.tr();
                      }
                      if (!v.contains('@')) {
                        return 'auth.register.error.email_invalid'.tr();
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    label: 'auth.register.password_label'.tr(),
                    hint: 'auth.register.password_hint'.tr(),
                    controller: _passwordController,
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return 'auth.register.error.password_required'.tr();
                      }
                      if (v.length < 6) {
                        return 'auth.register.error.password_min'.tr();
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  AppDateField(
                    label: 'auth.register.birthdate_label'.tr(),
                    value: _birthDate,
                    onChanged: (d) => setState(() {
                      _birthDate = d;
                      _showDateError = false;
                    }),
                    errorText: _showDateError
                        ? 'auth.register.error.birthdate_required'.tr()
                        : null,
                  ),
                  const SizedBox(height: 32),
                  AppButton(
                    label: 'auth.register.submit'.tr(),
                    onPressed: _submit,
                    isLoading: isLoading,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: AppLink(
                text: 'auth.register.has_account'.tr(),
                linkText: 'auth.register.login_link'.tr(),
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
