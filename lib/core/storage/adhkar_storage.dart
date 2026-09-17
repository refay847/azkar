import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AdhkarStorage {
  static const String _morningIndexKey = 'morning_index';
  static const String _eveningIndexKey = 'evening_index';

  static const String _morningCountsKey = 'morning_counts';
  static const String _eveningCountsKey = 'evening_counts';

  static Future<void> saveProgress({
    required bool isMorning,
    required int index,
    required List<int> counts,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final indexKey = isMorning
        ? _morningIndexKey
        : _eveningIndexKey;

    final countsKey = isMorning
        ? _morningCountsKey
        : _eveningCountsKey;

    await prefs.setInt(indexKey, index);
    await prefs.setString(
      countsKey,
      jsonEncode(counts),
    );
  }

  static Future<int> getIndex({
    required bool isMorning,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final key = isMorning
        ? _morningIndexKey
        : _eveningIndexKey;

    return prefs.getInt(key) ?? 0;
  }

  static Future<List<int>?> getCounts({
    required bool isMorning,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final key = isMorning
        ? _morningCountsKey
        : _eveningCountsKey;

    final value = prefs.getString(key);

    if (value == null) {
      return null;
    }

    try {
      final decoded = jsonDecode(value);

      return List<int>.from(decoded);
    } catch (_) {
      return null;
    }
  }

  static Future<void> reset({
    required bool isMorning,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final indexKey = isMorning
        ? _morningIndexKey
        : _eveningIndexKey;

    final countsKey = isMorning
        ? _morningCountsKey
        : _eveningCountsKey;

    await prefs.remove(indexKey);
    await prefs.remove(countsKey);
  }
}