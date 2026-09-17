// lib/features/adhkar/presentation/pages/welcome_page.dart
import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import 'home_page.dart';
import 'placeholder_page.dart';

class _AzkarCategory {
  final String title;
  final IconData icon;
  final WidgetBuilder pageBuilder;

  const _AzkarCategory({
    required this.title,
    required this.icon,
    required this.pageBuilder,
  });
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  static final List<_AzkarCategory> _categories = [
    _AzkarCategory(
      title: 'أذكار الصباح والمساء',
      icon: Icons.wb_twilight_rounded,
      pageBuilder: (_) => const HomePage(),
    ),
    _AzkarCategory(
      title: 'أذكار بعد الصلاة',
      icon: Icons.mosque_rounded,
      pageBuilder: (_) =>
          const PlaceholderPage(title: 'أذكار بعد الصلاة'),
    ),
    _AzkarCategory(
      title: 'أذكار الميت',
      icon: Icons.local_florist_rounded,
      pageBuilder: (_) => const PlaceholderPage(title: 'أذكار الميت'),
    ),
    _AzkarCategory(
      title: 'أذكار النوم',
      icon: Icons.bedtime_rounded,
      pageBuilder: (_) => const PlaceholderPage(title: 'أذكار النوم'),
    ),
    _AzkarCategory(
      title: 'أذكار الاستيقاظ من النوم',
      icon: Icons.wb_sunny_rounded,
      pageBuilder: (_) =>
          const PlaceholderPage(title: 'أذكار الاستيقاظ من النوم'),
    ),
    _AzkarCategory(
      title: 'أذكار الوضوء',
      icon: Icons.water_drop_rounded,
      pageBuilder: (_) => const PlaceholderPage(title: 'أذكار الوضوء'),
    ),
    _AzkarCategory(
      title: 'أذكار دخول وخروج المسجد',
      icon: Icons.door_front_door_rounded,
      pageBuilder: (_) =>
          const PlaceholderPage(title: 'أذكار دخول وخروج المسجد'),
    ),
    _AzkarCategory(
      title: 'أذكار الطعام',
      icon: Icons.restaurant_rounded,
      pageBuilder: (_) => const PlaceholderPage(title: 'أذكار الطعام'),
    ),
    _AzkarCategory(
      title: 'أذكار السفر',
      icon: Icons.flight_takeoff_rounded,
      pageBuilder: (_) => const PlaceholderPage(title: 'أذكار السفر'),
    ),
    _AzkarCategory(
      title: 'الأدعية القرآنية',
      icon: Icons.menu_book_rounded,
      pageBuilder: (_) =>
          const PlaceholderPage(title: 'الأدعية القرآنية'),
    ),
  ];

  void _openCategory(BuildContext context, _AzkarCategory category) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: category.pageBuilder),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'أذكاري',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
          itemCount: _categories.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final category = _categories[index];

            return _CategoryTile(
              title: category.title,
              icon: category.icon,
              onTap: () => _openCategory(context, category),
            );
          },
        ),
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _CategoryTile({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.surface,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 18,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppTheme.primary.withValues(alpha: 0.12),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: AppTheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_left_rounded,
                color: AppTheme.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}