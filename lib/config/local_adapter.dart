import 'dart:math';

import 'package:ab_testing/config/config.dart';
import 'package:ab_testing/utility/extensions.dart';

class LocalConfigAdapter implements ConfigAdapter {
  final Future<int> _userSeed;
  final Map<String, dynamic> _values = {};

  LocalConfigAdapter(this._userSeed);

  @override
  bool get local => true;

  @override
  Future<void> init(Iterable<ConfigItem> items) async {
    final matches = items.where((item) => item.local).toList();
    if (matches.isEmpty) return;

    final userSeed = await _userSeed;
    final userSegment = Random(userSeed).nextDouble();

    _values.addAll(Map.fromEntries(matches.where((item) {
      // check if the user falls into the sample size of the local test
      return item.local && userSegment < item.sampleSize;
    }).map((item) {
      if (item.paused) {
        return MapEntry(item.id, item.defaultValue is Enum ? (item.defaultValue as Enum).name : item.defaultValue);
      }

      // deterministically generate the test value by initializing the random
      // generator with a combination of the user seed and test id hashcode
      final random = Random(userSeed ^ item.id.hashCode);
      final value = item.validValues == null ? null : random.nextItem(item.validValues!);
      return MapEntry(item.id, value is Enum ? value.name : value);
    })));
  }

  @override
  bool has(String id) => _values.containsKey(id);

  @override
  T? get<T>(String id) => _values[id] as T?;
}
