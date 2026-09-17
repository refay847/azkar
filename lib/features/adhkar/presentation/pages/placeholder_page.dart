// lib/features/adhkar/presentation/pages/placeholder_page.dart
import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

/// Temporary page shown for azkar categories that aren't implemented yet.
class PlaceholderPage extends StatelessWidget {
  final String title;

  const PlaceholderPage({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.construction_rounded,
              color: AppTheme.primary.withValues(alpha: 0.6),
              size: 56,
            ),
            const SizedBox(height: 16),
            Text(
              'قريباً إن شاء الله',
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}