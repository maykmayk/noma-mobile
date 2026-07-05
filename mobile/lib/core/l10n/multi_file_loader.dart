import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class MultiFileLoader extends AssetLoader {
  const MultiFileLoader();

  static const _namespaces = [
    'auth',
    'home',
    'ride',
    'profile',
    'settings',
    'common',
  ];

  @override
  Future<Map<String, dynamic>> load(String path, Locale locale) async {
    final Map<String, dynamic> result = {};
    for (final ns in _namespaces) {
      try {
        final raw = await rootBundle.loadString(
          '$path/${ns}_${locale.languageCode}.json',
        );
        _deepMerge(result, json.decode(raw) as Map<String, dynamic>);
      } catch (_) {}
    }
    return result;
  }

  void _deepMerge(Map<String, dynamic> target, Map<String, dynamic> source) {
    for (final key in source.keys) {
      final t = target[key];
      final s = source[key];
      if (t is Map<String, dynamic> && s is Map<String, dynamic>) {
        _deepMerge(t, s);
      } else {
        target[key] = s;
      }
    }
  }
}
