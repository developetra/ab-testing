import 'dart:async';

import 'package:ab_testing/config/value.dart';
import 'package:flutter/widgets.dart';

class ConfigItem<T> {
  final String id;
  final T defaultValue;
  final List<T>? validValues;
  final double sampleSize;
  final bool local;
  final bool paused;

  ConfigItem(
    this.id,
    this.defaultValue,
    this.validValues,
    this.sampleSize, {
    required this.local,
    required this.paused,
  });
}

abstract class ConfigAdapter {
  bool get local;
  Future<void> init(Iterable<ConfigItem> items);
  bool has(String id);
  T? get<T>(String id);
}

abstract class UpdatableConfigAdapter extends ConfigAdapter {
  Future<void> update({bool force = false});
}

class ConfigProvider {
  final List<ConfigValueImpl> values = [];
  final List<ConfigAdapter> _adapters;

  ConfigProvider(this._adapters);

  List<ConfigItem> get items => values.map((value) => value.item).toList();

  List<ConfigValueImpl> get activeValues => values.where((value) => !value.paused).toList();

  Future<void> init() async {
    await Future.wait(_adapters.map((adapter) => adapter.init(items)));
    update(force: true); //TODO: delete force
  }

  Future<void> update({bool force = false}) async {
    final adapters = _adapters.whereType<UpdatableConfigAdapter>();
    if (adapters.isNotEmpty) {
      await Future.wait(adapters.map((adapter) => adapter.update(force: force)));
    }
  }

  ConfigValue<bool> boolValue({
    required String id,
    bool defaultValue = false,
    double sampleSize = 1,
    bool local = false,
    bool paused = false,
  }) {
    return _add(
      BoolConfigValue(
        ConfigItem(id, defaultValue, [true, false], sampleSize, local: local, paused: paused),
        adapter(local: local),
      ),
    );
  }

  ConfigValue<int> intValue<T>({
    required String id,
    int defaultValue = 0,
    List<int>? validValues,
    double sampleSize = 1,
    bool local = false,
    bool paused = false,
  }) {
    return _add(IntConfigValue(
      ConfigItem(id, defaultValue, validValues, sampleSize, local: local, paused: paused),
      adapter(local: local),
    ));
  }

  ConfigValue<T> enumValue<T>({
    required String id,
    required T defaultValue,
    required List<T> validValues,
    double sampleSize = 1,
    bool local = false,
    bool paused = false,
  }) {
    return _add(EnumConfigValue<T>(
      ConfigItem(id, defaultValue, validValues, sampleSize, local: local, paused: paused),
      adapter(local: local),
    ));
  }

  ConfigValue<T> _add<T>(ConfigValueImpl<T> value) {
    values.add(value);
    return value;
  }

  @protected
  ConfigAdapter adapter({required bool local}) {
    return _adapters.firstWhere((adapter) => adapter.local == local);
  }

  Map<String, String> asMap() => {for (var item in values) item.id: item.stringValue};
}
