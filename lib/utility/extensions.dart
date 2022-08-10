import 'dart:math';

import 'package:collection/collection.dart';

T? enumFromString<T>(List<T> values, String? value) {
  return values.firstWhereOrNull((it) => enumToString(it) == value);
}

T enumFromStringOrDefault<T>(List<T> values, String? value, T defaultValue) {
  return values.firstWhere((it) => enumToString(it) == value, orElse: () => defaultValue);
}

/// Provide own implementation of enumToString (describeEnum) method to
/// avoid dependency to flutter foundation package in import scripts
String enumToString<T>(T member) {
  final String name = member.toString();
  return name.substring(name.indexOf('.') + 1);
}

String enumToUpperSnakeCase<T>(T member) {
  return enumToString(member).toUpperSnakeCase();
}

extension ValueExtension<T> on T {
  R let<R>(R Function(T) handler) => handler(this);
  bool oneOf(Iterable<T> values) => values.contains(this);
}

/// Provide own implementation of listEquals method to avoid dependency
/// to flutter foundation package in import scripts
bool listEquals<T>(List<T>? left, List<T>? right) {
  if (left == null) {
    return right == null;
  } else if (right == null || left.length != right.length) {
    return false;
  } else if (identical(left, right)) {
    return true;
  }
  for (int index = 0; index < left.length; index += 1) {
    if (left[index] != right[index]) {
      return false;
    }
  }
  return true;
}

Map<K, V> mapFromKeys<K, V>(Iterable<K> keys, V Function(K) mapper) {
  return Map.fromIterables(keys, keys.map(mapper));
}

Map<K, V> mapFromValues<K, V>(Iterable<V> values, K Function(V) mapper) {
  return Map.fromIterables(values.map(mapper), values);
}

extension MapExtension<K, V> on Map<K, V> {
  Map<K, V> where(bool Function(K, V) predicate) {
    return {
      for (final entry in entries)
        if (predicate(entry.key, entry.value)) entry.key: entry.value
    };
  }

  Map<K, V> pick(Iterable<K> keys) {
    final Map<K, V> map = {};
    for (final key in keys) {
      final value = this[key];
      if (value != null) {
        map[key] = value;
      }
    }
    return map;
  }

  Map<R, V> mapKeys<R>(R Function(K) mapper) {
    return map((key, value) => MapEntry(mapper(key), value));
  }

  Map<K, W> mapValues<W>(W Function(V, K) mapper) {
    return map((key, value) => MapEntry(key, mapper(value, key)));
  }

  void removeAll(Iterable<K> keys) {
    keys.forEach(remove);
  }
}

extension RandomExtension on Random {
  int nextIntBetween(int min, int max) {
    if (max - min == 0) {
      return min;
    }
    return min + nextInt(max - min);
  }

  double nextDoubleBetween(double min, double max) => nextDouble() * (max - min) + min;

  T nextItem<T>(List<T> items) {
    return items[nextInt(items.length)];
  }

  Iterable<T> nextItems<T>(List<T> items, int count) {
    return (items.toList()..shuffle(this)).take(count);
  }
}

extension StringExtension on String {
  String toSnakeCase() {
    return replaceAllMapped(RegExp('[A-Z]'), (match) => '_${match[0]!.toLowerCase()}');
  }

  String toUpperSnakeCase() {
    return toSnakeCase().toUpperCase();
  }

  String fromUpperSnakeCase() {
    final parts = split('_');
    final casedParts = [
      parts[0].toLowerCase(),
      for (int index = 1; index < parts.length; index++) //
        parts[index].toLowerCase().capitalize(),
    ];
    return casedParts.join();
  }

  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String ellipsis(int length) {
    return this.length > length ? '${substring(0, length)}\u2026' : this;
  }
}

extension EnumExtension on Enum {
  String get snakeCase => name.toSnakeCase();
}

extension EnumByNameExtension<T extends Enum> on Iterable<T> {
  T byName(String name, {T? defaultValue}) {
    for (var value in this) {
      if (value.name == name) return value;
    }
    if (defaultValue != null) {
      return defaultValue;
    }
    throw ArgumentError.value(name, 'name', 'No enum value with that name');
  }
}

extension DateTimeExtension on DateTime {
  DateTime get startOfDay => DateTime(year, month, day);

  int get weekOfYear {
    final startOfYear = DateTime(year, 1, 1, 0, 0);
    final firstMonday = startOfYear.weekday;
    final daysInFirstWeek = 8 - firstMonday;
    final diff = difference(startOfYear);
    int weeks = ((diff.inDays - daysInFirstWeek) / 7).ceil();
    if (daysInFirstWeek > 3) {
      weeks += 1;
    }
    return weeks;
  }

  /// Returns an ISO 8601 conform datetime string, that omits the microseconds part
  String toShortIso8601String() {
    return toIso8601String().replaceFirst(RegExp(r'\.\d+'), '');
  }
}
