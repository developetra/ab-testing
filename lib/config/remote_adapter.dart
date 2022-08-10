import 'package:ab_testing/config/config.dart';
import 'package:ab_testing/utility/console_logger.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

final _logger = ConsoleLogger('remote adapter');

class RemoteConfigAdapter implements UpdatableConfigAdapter {
  final Duration _expiration;
  final _fetchTimeout = const Duration(minutes: 1); // SDK default
  late final FirebaseRemoteConfig _config;
  Map<String, RemoteConfigValue> _values = {};

  RemoteConfigAdapter([this._expiration = const Duration(hours: 4)]);

  @override
  bool get local => false;

  /// The init method will only initialize the previously loaded values
  /// of the remote config. IF the specified value parameter is empty,
  /// the RemoteConfigAdapter will stay uninitialized.
  @override
  Future<void> init(Iterable<ConfigItem> items) async {
    if (items.every((item) => item.local)) return;
    _config = FirebaseRemoteConfig.instance;

    await _config.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: _fetchTimeout,
      minimumFetchInterval: _expiration,
    ));

    await _config.activate();
    await _config.ensureInitialized();

    _values = _config.getAll();
    _logger.log('remote config initialized');
  }

  /// The update method will fetch the config values from the remote node.
  @override
  Future<void> update({bool force = false}) async {
    if (force) {
      await _setFetchInterval(Duration.zero);
    }
    try {
      await _config.fetch();
      if (force) {
        await _config.activate();
      }
    } catch (error) {
      _logger.log('Failed to fetch remote config');
    }
    _values = _config.getAll();
    if (force) {
      await _setFetchInterval(_expiration);
    }
  }

  @override
  bool has(String id) => _values.containsKey(id);

  @override
  T? get<T>(String id) {
    final value = _values[id];
    if (value == null) {
      return null;
    } else if (T == bool) {
      return value.asBool() as T;
    } else if (T == int) {
      return value.asInt() as T;
    } else {
      return value.asString() as T;
    }
  }

  Future<void> _setFetchInterval(Duration duration) {
    return _config.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: _fetchTimeout,
        minimumFetchInterval: duration,
      ),
    );
  }
}
