enum AppFlavor { dev, production }

class AppConfig {
  const AppConfig({
    required this.flavor,
    required this.supabaseUrl,
    required this.supabaseAnonKey,
    required this.appName,
  });

  final AppFlavor flavor;
  final String supabaseUrl;
  final String supabaseAnonKey;
  final String appName;

  bool get isDev => flavor == AppFlavor.dev;
}
