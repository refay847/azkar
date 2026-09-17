// lib/features/adhkar/presentation/pages/home_page.dart
import 'package:flutter/material.dart';

import '../../../../core/storage/adhkar_storage.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/adhkar_data.dart';
import '../../models/dhikr.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/dhikr_card.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _tabIndex = 0;

  final PageController _pageController = PageController();

  late List<int> _morningCounts;
  late List<int> _eveningCounts;

  int _morningIndex = 0;
  int _eveningIndex = 0;

  bool _loading = true;

  bool get _isMorning => _tabIndex == 0;

  List<Dhikr> get _currentAdhkar =>
      _isMorning ? morningAdhkar : eveningAdhkar;

  List<int> get _currentCounts =>
      _isMorning ? _morningCounts : _eveningCounts;

  int get _currentIndex =>
      _isMorning ? _morningIndex : _eveningIndex;

  @override
  void initState() {
    super.initState();

    _initialize();
  }

  Future<void> _initialize() async {
    final morningSavedCounts =
        await AdhkarStorage.getCounts(isMorning: true);

    final eveningSavedCounts =
        await AdhkarStorage.getCounts(isMorning: false);

    final savedMorningIndex =
        await AdhkarStorage.getIndex(isMorning: true);

    final savedEveningIndex =
        await AdhkarStorage.getIndex(isMorning: false);

    if (!mounted) return;

    setState(() {
      _morningCounts =
          _normalizeCounts(morningAdhkar, morningSavedCounts);

      _eveningCounts =
          _normalizeCounts(eveningAdhkar, eveningSavedCounts);

      _morningIndex = _safeIndex(
        savedMorningIndex,
        morningAdhkar.length,
      );

      _eveningIndex = _safeIndex(
        savedEveningIndex,
        eveningAdhkar.length,
      );

      _loading = false;
    });
  }

  List<int> _normalizeCounts(
    List<Dhikr> adhkar,
    List<int>? saved,
  ) {
    if (saved == null || saved.length != adhkar.length) {
      return adhkar.map((dhikr) => dhikr.count).toList();
    }

    return List<int>.from(saved);
  }

  int _safeIndex(int index, int length) {
    if (length == 0) return 0;

    if (index < 0) return 0;

    if (index >= length) {
      return length - 1;
    }

    return index;
  }

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  Future<void> _saveCurrentProgress() async {
    await AdhkarStorage.saveProgress(
      isMorning: _isMorning,
      index: _currentIndex,
      counts: _currentCounts,
    );
  }

  Future<void> _changeTab(int index) async {
    if (_tabIndex == index) return;

    setState(() {
      _tabIndex = index;
    });

    await _pageController.animateToPage(
      _currentIndex,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> _onPageChanged(int index) async {
    setState(() {
      if (_isMorning) {
        _morningIndex = index;
      } else {
        _eveningIndex = index;
      }
    });

    await _saveCurrentProgress();
  }

  Future<void> _decrementCounter() async {
    if (_loading) return;

    final index = _currentIndex;
    final counts = _currentCounts;

    if (counts[index] <= 0) {
      return;
    }

    setState(() {
      counts[index]--;
    });

    if (counts[index] > 0) {
      await _saveCurrentProgress();
      return;
    }

    await _saveCurrentProgress();

    await Future.delayed(
      const Duration(milliseconds: 250),
    );

    if (!mounted) return;

    final lastIndex = _currentAdhkar.length - 1;

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
    final isMorning = _isMorning;

    final originalAdhkar =
        isMorning ? morningAdhkar : eveningAdhkar;

    final freshCounts =
        originalAdhkar.map((dhikr) => dhikr.count).toList();

    setState(() {
      if (isMorning) {
        _morningCounts = freshCounts;
        _morningIndex = 0;
      } else {
        _eveningCounts = freshCounts;
        _eveningIndex = 0;
      }
    });

    await AdhkarStorage.saveProgress(
      isMorning: isMorning,
      index: 0,
      counts: freshCounts,
    );

    if (!mounted) return;

    await _pageController.animateToPage(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'ما شاء الله، تمت الأذكار 🌙',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Future<void> _resetCurrentSession() async {
    final isMorning = _isMorning;

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

    final adhkar = isMorning
        ? morningAdhkar
        : eveningAdhkar;

    final freshCounts =
        adhkar.map((dhikr) => dhikr.count).toList();

    setState(() {
      if (isMorning) {
        _morningCounts = freshCounts;
        _morningIndex = 0;
      } else {
        _eveningCounts = freshCounts;
        _eveningIndex = 0;
      }
    });

    await AdhkarStorage.reset(
      isMorning: isMorning,
    );

    await AdhkarStorage.saveProgress(
      isMorning: isMorning,
      index: 0,
      counts: freshCounts,
    );

    if (!mounted) return;

    await _pageController.animateToPage(
      0,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: AppTheme.primary,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isMorning
              ? 'أذكار الصباح'
              : 'أذكار المساء',
          style: const TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'إعادة الضبط',
            onPressed: _resetCurrentSession,
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

          // In RTL Flutter naturally treats the horizontal
          // direction as right-to-left.
          physics: const BouncingScrollPhysics(),

          itemCount: _currentAdhkar.length,

          onPageChanged: _onPageChanged,

          itemBuilder: (context, index) {
            final dhikr = _currentAdhkar[index];

            return DhikrCard(
              key: ValueKey(
                '${_tabIndex}_$index',
              ),
              dhikr: dhikr,
              remaining: _currentCounts[index],
              currentIndex: index,
              total: _currentAdhkar.length,
              onTap: _decrementCounter,
            );
          },
        ),
      ),

      bottomNavigationBar: AdhkarBottomNavigation(
        currentIndex: _tabIndex,
        onChanged: _changeTab,
      ),
    );
  }
}