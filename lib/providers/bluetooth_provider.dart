import 'dart:async';
import 'dart:js_util';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothProvider extends ChangeNotifier {
  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;
  late StreamSubscription<BluetoothAdapterState> _adapterStateSubscription;
  List<BluetoothDevice> _systemDevices = [];
  List<ScanResult> _scanResults = [];
  bool _isScanning = false;
  late StreamSubscription<List<ScanResult>> _scanResultsSubscription;
  late StreamSubscription<bool> _isScanningSubscription;

  //used for connected state
  late BluetoothDevice _device;
  int? _rssi;
  int? _mtuSize;
  BluetoothConnectionState _connectionState =
      BluetoothConnectionState.disconnected;
  List<BluetoothService> _services = [];
  bool _isDiscoveringServices = false;
  bool _isConnecting = false;
  bool _isDisconnecting = false;
  late StreamSubscription<BluetoothConnectionState>
      _connectionStateSubscription;
  late StreamSubscription<int> _mtuSubscription;

  BluetoothProvider() {
    FlutterBluePlus.setLogLevel(LogLevel.verbose, color: true);
  }

  void startListentingToAdapterState() {
    _adapterStateSubscription = FlutterBluePlus.adapterState.listen((state) {
      _adapterState = state;
      notifyListeners();
    });
  }

  void stopListentingToAdapterState() {
    _adapterStateSubscription.cancel();
  }

  void startListentingToScanResults() {
    _scanResultsSubscription = FlutterBluePlus.scanResults.listen((results) {
      _scanResults = results;
      notifyListeners();
    }, onError: (e) {});

    _isScanningSubscription = FlutterBluePlus.isScanning.listen((state) {
      _isScanning = state;
      notifyListeners();
    });
  }

  void stopListentingToScanResults() {
    _scanResultsSubscription.cancel();
    _isScanningSubscription.cancel();
  }

  void startScaning() async {
    try {
      _systemDevices = await FlutterBluePlus.systemDevices;
      notifyListeners();
    } catch (e) {}
    try {
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
    } catch (e) {}
  }

  void stopScaning() async {
    try {
      FlutterBluePlus.stopScan();
    } catch (e) {}
  }

  void refresh() {
    if (_isScanning == false) {
      FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
    }
    notifyListeners();
  }

  void connect(BluetoothDevice device) {
    _device = device;
    _device.connect(autoConnect: true);
    notifyListeners();
  }

  void disconnected() async {
    try {
      await _device.disconnect();
    } catch (e) {}
  }

  void initConnection() {
    _connectionStateSubscription =
        _device.connectionState.listen((state) async {
      _connectionState = state;
      if (state == BluetoothConnectionState.connected) {
        _services = []; // must rediscover services
      }
      if (state == BluetoothConnectionState.connected && _rssi == null) {
        _rssi = await _device.readRssi();
      }
      notifyListeners();
    });

    _mtuSubscription = _device.mtu.listen((value) {
      _mtuSize = value;
      notifyListeners();
    });
  }

  void disposeDevice() {
    _connectionStateSubscription.cancel();
    _mtuSubscription.cancel();
  }

  bool get isConnected {
    return _connectionState == BluetoothConnectionState.connected;
  }

  void discoverServices() async {
    _isDiscoveringServices = true;
    notifyListeners();

    try {
      _services = await _device.discoverServices();
    } catch (e) {}
    _isDiscoveringServices = false;
    notifyListeners();
  }
}
