import 'package:connectivity_plus/connectivity_plus.dart';

import 'connectivity_service.dart';

class FlutterConnectivityService implements ConnectivityService {
  FlutterConnectivityService({Connectivity? connectivity}) : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  @override
  Future<bool> hasConnection() async {
    final results = await _connectivity.checkConnectivity();
    return results.any((result) => result != ConnectivityResult.none);
  }
}