// lib/features/adhkar/presentation/pages/sleep_page.dart
import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../data/sleep_adhkar_data.dart';
import '../widgets/dhikr_card.dart';

class SleepPage extends StatefulWidget {
  const SleepPage({super.key});

  @override
  State<SleepPage> createState() => _SleepPageState();
}

class _SleepPageState extends State<SleepPage> {
  final PageController _pageController = PageController();

  late List<int> _counts;

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    _counts = sleepAdhkar.map((dhikr) => dhikr.count).toList();
  }

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  Future<void> _onPageChanged(int index) async {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<void> _decrementCounter() async {
    final index = _currentIndex;

    if (_counts[index] <= 0) {
      return;
    }

    setState(() {
      _counts[index]--;
    });

    if (_counts[index] > 0) {
      return;
    }

    await Future.delayed(
      const Duration(milliseconds: 250),
    );

    if (!mounted) return;

    final lastIndex = sleepAdhkar.length - 1;

    if (index == lastIndex) {
      await _finishAdhkar();

      return;
    }

    await _pageController.nextPage(
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> _finishAdhkar() async {
    final freshCounts = sleepAdhkar.map((dhikr) => dhikr.count).toList();

    setState(() {
      _counts = freshCounts;
      _currentIndex = 0;
    });

    await _pageController.animateToPage(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'أتممت أذكار النوم، نومًا هنيئًا 🌙',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Future<void> _resetSession() async {
    final shouldReset = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppTheme.surface,
          title: const Text(
            'إعادة ضبط الأذكار',
            textAlign: TextAlign.right,
          ),
          content: const Text(
            'هل تريد إعادة جميع العدادات والبدء من أول ذكر؟',
            textAlign: TextAlign.right,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('إلغاء'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('إعادة الضبط'),
            ),
          ],
        );
      },
    );

    if (shouldReset != true) return;

    final freshCounts = sleepAdhkar.map((dhikr) => dhikr.count).toList();

    setState(() {
      _counts = freshCounts;
      _currentIndex = 0;
    });

    await _pageController.animateToPage(
      0,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'أذكار النوم',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'إعادة الضبط',
            onPressed: _resetSession,
            icon: const Icon(
              Icons.restart_alt_rounded,
            ),
          ),

          const SizedBox(width: 6),
        ],
      ),

      body: SafeArea(
        child: PageView.builder(
          controller: _pageController,

          physics: const BouncingScrollPhysics(),

          itemCount: sleepAdhkar.length,

          onPageChanged: _onPageChanged,

          itemBuilder: (context, index) {
            final dhikr = sleepAdhkar[index];

            return DhikrCard(
              key: ValueKey(index),
              text: dhikr.text,
              note: dhikr.note,
              remaining: _counts[index],
              currentIndex: index,
              total: sleepAdhkar.length,
              onTap: _decrementCounter,
            );
          },
        ),
      ),
    );
  }
}