import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  
  final StreamController<bool> _connectionStatusController = 
      StreamController<bool>.broadcast();
  
  Stream<bool> get connectionStatus => _connectionStatusController.stream;
  bool _isConnected = true;
  bool get isConnected => _isConnected;

  void startMonitoring() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (List<ConnectivityResult> results) {
        final bool connected = !results.contains(ConnectivityResult.none);
        if (connected != _isConnected) {
          _isConnected = connected;
          _connectionStatusController.add(_isConnected);
        }
      },
    );
    
    checkInitialConnectivity();
  }

  Future<void> checkInitialConnectivity() async {
    final List<ConnectivityResult> results = await _connectivity.checkConnectivity();
    final bool connected = !results.contains(ConnectivityResult.none);
    if (connected != _isConnected) {
      _isConnected = connected;
      _connectionStatusController.add(_isConnected);
    }
  }

  Future<bool> checkConnection() async {
    final List<ConnectivityResult> results = await _connectivity.checkConnectivity();
    final bool connected = !results.contains(ConnectivityResult.none);
    _isConnected = connected;
    _connectionStatusController.add(_isConnected);
    return connected;
  }

  void dispose() {
    _connectivitySubscription.cancel();
    _connectionStatusController.close();
  }
}