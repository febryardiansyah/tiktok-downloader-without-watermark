import 'package:firebase_remote_config/firebase_remote_config.dart';

class FirebaseService {
   Future<FirebaseRemoteConfig> getRemoteConfig() async {
    try {
      final remoteConfig = FirebaseRemoteConfig.instance;

      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(seconds: 10),
      ));

      await remoteConfig.fetchAndActivate();

      return remoteConfig;
    } catch (e) {
      rethrow;
    }
  }

}
