import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';
import 'core/config/app_config.dart';

const _config = AppConfig(
  flavor: AppFlavor.dev,
  supabaseUrl: String.fromEnvironment('SUPABASE_URL'),
  supabaseAnonKey: String.fromEnvironment('SUPABASE_ANON_KEY'),
  appName: 'Noma Dev',
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: _config.supabaseUrl,
    publishableKey: _config.supabaseAnonKey,
  );

  runApp(
    const ProviderScope(
      child: NomaApp(config: _config),
    ),
  );
}
