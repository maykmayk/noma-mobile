import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';
import 'core/config/app_config.dart';
import 'core/l10n/multi_file_loader.dart';

const _config = AppConfig(
  flavor: AppFlavor.dev,
  supabaseUrl: String.fromEnvironment('SUPABASE_URL'),
  supabaseAnonKey: String.fromEnvironment('SUPABASE_ANON_KEY'),
  appName: 'Noma Dev',
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await Supabase.initialize(
    url: _config.supabaseUrl,
    publishableKey: _config.supabaseAnonKey,
  );

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('it'), Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      assetLoader: const MultiFileLoader(),
      child: const ProviderScope(
        child: NomaApp(config: _config),
      ),
    ),
  );
}
