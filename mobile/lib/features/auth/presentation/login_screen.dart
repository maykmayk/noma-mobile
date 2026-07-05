import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_link.dart';
import '../../../shared/widgets/app_text_field.dart';
import 'auth_notifier.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await ref.read(authNotifierProvider.notifier).signIn(
          emailOrUsername: _identifierController.text.trim(),
          password: _passwordController.text,
        );
    if (!mounted) return;
    final error = ref.read(authNotifierProvider).error;
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('auth.login.error.sign_in_failed'.tr()),
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
        title: Text('auth.login.title'.tr()),
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
                    label: 'auth.login.email_label'.tr(),
                    hint: 'auth.login.email_hint'.tr(),
                    controller: _identifierController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'auth.login.error.email_required'.tr();
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    label: 'auth.login.password_label'.tr(),
                    hint: 'auth.login.password_hint'.tr(),
                    controller: _passwordController,
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _submit(),
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return 'auth.login.error.password_required'.tr();
                      }
                      if (v.length < 6) {
                        return 'auth.login.error.password_min'.tr();
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  AppButton(
                    label: 'auth.login.submit'.tr(),
                    onPressed: _submit,
                    isLoading: isLoading,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: AppLink(
                text: 'auth.login.no_account'.tr(),
                linkText: 'auth.login.register_link'.tr(),
                onTap: () => context.go('/register'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
