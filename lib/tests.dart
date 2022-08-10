import 'package:ab_testing/config/config.dart';
import 'package:ab_testing/config/value.dart';

enum ExampleEnum { standard, control, enabled }

class TestConfig {
  /// ConfigProvider that contains the local and remote config adapters.
  late final ConfigProvider _provider;

  /// Config values for tests.
  final ConfigValue<bool> _exampleValueBool;
  final ConfigValue<int> _exampleValueInt;
  final ConfigValue<ExampleEnum> _exampleValueEnum;

  TestConfig(this._provider)
      : _exampleValueInt = _provider.intValue(id: 'example_int', defaultValue: 10),
        _exampleValueBool = _provider.boolValue(id: 'example_bool', defaultValue: false),
        _exampleValueEnum = _provider.enumValue(
          id: 'example_enum',
          validValues: ExampleEnum.values,
          defaultValue: ExampleEnum.standard,
        );

  int get exampleValueInt => _exampleValueInt.value;
  bool get exampleValueBool => _exampleValueBool.value;
  ExampleEnum get exampleValueEnum => _exampleValueEnum.value;

  Future<void> init() => _provider.init();

  Future<void> update() => _provider.update(force: true);

  Map<String, String> asMap() => _provider.asMap();
}
