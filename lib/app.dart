// lib/app.dart
import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/adhkar/presentation/pages/welcome_page.dart';

class AdhkarApp extends StatelessWidget {
  const AdhkarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'أذكاري',
      theme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      locale: const Locale('ar'),
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
      home: const WelcomePage(),
    );
  }
}