import 'dart:async';
import 'dart:developer' as developer;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class ConnectivityService extends GetxService {
  var connectionStatus = <ConnectivityResult>[ConnectivityResult.none].obs;
  var hasInternet = false.obs;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void onInit() {
    super.onInit();
    _initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> _initConnectivity() async {
    try {
      List<ConnectivityResult> result = await _connectivity.checkConnectivity();
      _updateConnectionStatus(result);
    } catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
    }
  }

  void _updateConnectionStatus(List<ConnectivityResult> result) {
    connectionStatus.value = result;
    hasInternet.value = result.any((status) =>
        status == ConnectivityResult.mobile ||
        status == ConnectivityResult.wifi);

    print(
        'Connectivity changed: ${hasInternet.value ? "Connected" : "Disconnected"}');
  }

  @override
  void onClose() {
    _connectivitySubscription.cancel();
    super.onClose();
  }
}
