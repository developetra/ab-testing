import 'package:ab_testing/app/storage/storage.dart';
import 'package:ab_testing/app/viewmodel/home_model.dart';
import 'package:ab_testing/config/config.dart';
import 'package:ab_testing/config/local_adapter.dart';
import 'package:ab_testing/config/remote_adapter.dart';
import 'package:ab_testing/tests.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

final _storage = Storage();
final _configAdapters = [LocalConfigAdapter(_storage.userSeed), RemoteConfigAdapter()];
final _configProvider = ConfigProvider(_configAdapters);
final _testConfig = TestConfig(_configProvider);
final _homeModel = HomeModel(_testConfig);

final List<SingleChildWidget> serviceProviders = [
  Provider<ConfigProvider>.value(value: _configProvider),
  Provider<TestConfig>.value(value: _testConfig),
  Provider<HomeModel>.value(value: _homeModel),
];

Future<void> initServices() async {
  await _testConfig.init();
}
