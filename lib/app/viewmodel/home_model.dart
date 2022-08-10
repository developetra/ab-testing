import 'package:ab_testing/tests.dart';
import 'package:ab_testing/utility/console_logger.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final _logger = ConsoleLogger('home model');

class HomeModel {
  static HomeModel of(BuildContext context) => Provider.of<HomeModel>(context, listen: false);

  final TestConfig _tests;

  HomeModel(this._tests);

  int get exampleValueInt => _tests.exampleValueInt;
  bool get exampleValueBool => _tests.exampleValueBool;
  ExampleEnum get exampleValueEnum => _tests.exampleValueEnum;

  Future<void> fetchNewConfigValues() async {
    await _tests.update();
    _logger.log('fetch new config values');
  }
}
