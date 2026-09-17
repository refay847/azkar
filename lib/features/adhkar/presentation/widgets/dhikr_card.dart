// lib/features/adhkar/presentation/widgets/dhikr_card.dart
import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../models/dhikr.dart';

class DhikrCard extends StatelessWidget {
  final Dhikr dhikr;
  final int remaining;
  final int currentIndex;
  final int total;
  final VoidCallback onTap;

  const DhikrCard({
    super.key,
    required this.dhikr,
    required this.remaining,
    required this.currentIndex,
    required this.total,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final progress = total == 0 ? 0.0 : (currentIndex + 1) / total;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
      child: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: AppTheme.primary.withValues(alpha: 0.15),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 30,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withValues(alpha: 0.04),
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(28),
                          bottomLeft: Radius.circular(120),
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.primary.withValues(alpha: 0.10),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text(
                                '${currentIndex + 1} / $total',
                                style: const TextStyle(
                                  color: AppTheme.primaryLight,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                ),
                              ),
                            ),

                            const Icon(
                              Icons.auto_awesome,
                              color: AppTheme.primary,
                              size: 22,
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),

                        Expanded(
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              children: [
                                Text(
                                  dhikr.text,
                                  textAlign: TextAlign.center,
                                  textDirection: TextDirection.rtl,
                                  style: const TextStyle(
                                    color: AppTheme.textPrimary,
                                    fontSize: 23,
                                    height: 2.05,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),

                                if (dhikr.virtue != null &&
                                    dhikr.virtue!.trim().isNotEmpty) ...[
                                  const SizedBox(height: 24),

                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: AppTheme.primary.withValues(
                                        alpha: 0.055,
                                      ),
                                      borderRadius: BorderRadius.circular(18),
                                      border: Border.all(
                                        color: AppTheme.primary.withValues(
                                          alpha: 0.10,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      dhikr.virtue!,
                                      textAlign: TextAlign.center,
                                      textDirection: TextDirection.rtl,
                                      style: const TextStyle(
                                        color: AppTheme.textSecondary,
                                        fontSize: 14,
                                        height: 1.8,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),

          Text(
            'اضغط للتسبيح',
            style: TextStyle(
              color: AppTheme.textSecondary.withValues(alpha: 0.8),
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 6),

          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: remaining > 0 ? onTap : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 92,
              height: 92,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: remaining > 0 ? AppTheme.primary : Colors.grey.shade700,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primary.withValues(alpha: 0.20),
                    blurRadius: 22,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 120),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child: Text(
                    '$remaining',
                    key: ValueKey(remaining),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 10),

          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 4,
              backgroundColor: Colors.white.withValues(alpha: 0.06),
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primary),
            ),
          ),
        ],
      ),
    );
  }
}
