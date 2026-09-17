import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import 'home_page.dart';
import 'after_prayer_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  static const List<_AdhkarCategory> _categories = [
    _AdhkarCategory(
      title: 'أذكار الصباح والمساء',
      subtitle: 'أذكار الصباح والمساء',
      icon: Icons.wb_sunny_outlined,
      available: true,
    ),
    _AdhkarCategory(
      title: 'أذكار بعد الصلاة',
      subtitle: 'أذكار ما بعد الصلاة',
      icon: Icons.mosque_outlined,
      available: true,
    ),
    _AdhkarCategory(
      title: 'أذكار الميت',
      subtitle: 'الدعاء والأذكار للميت',
      icon: Icons.volunteer_activism_outlined,
    ),
    _AdhkarCategory(
      title: 'أذكار النوم',
      subtitle: 'أذكار قبل النوم',
      icon: Icons.bedtime_outlined,
    ),
    _AdhkarCategory(
      title: 'أذكار الاستيقاظ',
      subtitle: 'أذكار الاستيقاظ من النوم',
      icon: Icons.wb_twilight_outlined,
    ),
    _AdhkarCategory(
      title: 'أذكار الدخول والخروج',
      subtitle: 'أذكار المنزل',
      icon: Icons.door_front_door_outlined,
    ),
    _AdhkarCategory(
      title: 'أذكار الطعام والشراب',
      subtitle: 'قبل الطعام وبعده',
      icon: Icons.restaurant_outlined,
    ),
    _AdhkarCategory(
      title: 'أذكار السفر',
      subtitle: 'أذكار السفر والركوب',
      icon: Icons.flight_takeoff_outlined,
    ),
    _AdhkarCategory(
      title: 'أدعية متنوعة',
      subtitle: 'مجموعة من الأدعية',
      icon: Icons.auto_awesome_outlined,
    ),
  ];

  void _openCategory(BuildContext context, _AdhkarCategory category) {
    if (!category.available) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => const _ComingSoonPage()));
      return;
    }

    if (category.title == 'أذكار الصباح والمساء') {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => const HomePage()));
      return;
    }

    if (category.title == 'أذكار بعد الصلاة') {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => const AfterPrayerPage()));
    }
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
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Header
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
              sliver: SliverToBoxAdapter(child: _WelcomeHeader()),
            ),

            // Section title
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              sliver: SliverToBoxAdapter(
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 22,
                      decoration: BoxDecoration(
                        color: AppTheme.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),

                    const SizedBox(width: 10),

                    const Text(
                      'الأذكار',
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Categories grid
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 28),
              sliver: SliverGrid.builder(
                itemCount: _categories.length,

                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,

                  // Space between the two cards.
                  crossAxisSpacing: 10,

                  // Space between rows.
                  mainAxisSpacing: 10,

                  // Wider than tall.
                  // This makes the cards compact while keeping
                  // enough room for the Arabic text.
                  childAspectRatio: 1.12,
                ),

                itemBuilder: (context, index) {
                  final category = _categories[index];

                  return _AdhkarCategoryCard(
                    category: category,
                    onTap: () => _openCategory(context, category),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WelcomeHeader extends StatelessWidget {
  const _WelcomeHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 26, 24, 26),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppTheme.primary.withValues(alpha: 0.13)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.24),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          // Icon
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.primary.withValues(alpha: 0.09),
              border: Border.all(
                color: AppTheme.primary.withValues(alpha: 0.16),
              ),
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: AppTheme.primary,
              size: 31,
            ),
          ),

          const SizedBox(height: 17),

          const Text(
            'أذكاري',
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 27,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.2,
            ),
          ),

          const SizedBox(height: 7),

          const Text(
            'اختر نوع الأذكار الذي تريد قراءته',
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _AdhkarCategoryCard extends StatelessWidget {
  final _AdhkarCategory category;
  final VoidCallback onTap;

  const _AdhkarCategoryCard({required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        splashColor: AppTheme.primary.withValues(alpha: 0.08),
        highlightColor: AppTheme.primary.withValues(alpha: 0.04),
        child: Ink(
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(22),

            border: Border.all(
              color: category.available
                  ? AppTheme.primary.withValues(alpha: 0.24)
                  : AppTheme.primary.withValues(alpha: 0.08),
              width: category.available ? 1.2 : 1,
            ),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.16),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),

          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.primary.withValues(alpha: 0.09),
                  ),
                  child: Icon(category.icon, color: AppTheme.primary, size: 24),
                ),

                const SizedBox(height: 10),

                // Title
                Text(
                  category.title,
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 15,
                    height: 1.35,
                    fontWeight: category.available
                        ? FontWeight.w800
                        : FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 5),

                // Small status
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      category.available
                          ? Icons.arrow_back_rounded
                          : Icons.lock_outline_rounded,
                      color: category.available
                          ? AppTheme.primary
                          : AppTheme.textSecondary,
                      size: 13,
                    ),

                    const SizedBox(width: 4),

                    Text(
                      category.available ? 'ابدأ' : 'قريبًا',
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        color: category.available
                            ? AppTheme.primaryLight
                            : AppTheme.textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ComingSoonPage extends StatelessWidget {
  const _ComingSoonPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'أذكاري',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.primary.withValues(alpha: 0.10),
                  border: Border.all(
                    color: AppTheme.primary.withValues(alpha: 0.12),
                  ),
                ),
                child: const Icon(
                  Icons.construction_outlined,
                  color: AppTheme.primary,
                  size: 42,
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'قريبًا إن شاء الله',
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'نعمل على إضافة هذه الأذكار.',
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 15,
                  height: 1.7,
                ),
              ),

              const SizedBox(height: 28),

              FilledButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_forward_rounded),
                label: const Text('العودة'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AdhkarCategory {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool available;

  const _AdhkarCategory({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.available = false,
  });
}
