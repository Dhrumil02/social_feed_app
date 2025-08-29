import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:feed_app/app/core/injection/injection_container.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity = sl<Connectivity>();

  @override
  Future<bool> get isConnected async {
    final result = await connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }
}