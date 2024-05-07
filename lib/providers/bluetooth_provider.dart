import 'dart:async';
import 'dart:io';
import 'package:canti_hub/database/database.dart';
import 'package:canti_hub/providers/bluetooth_helpers/communication.dart';
import 'package:canti_hub/providers/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothProvider extends ChangeNotifier {
  DatabaseProvider? _dbProvider;
  Communication? com;
  BluetoothAdapterState adapterState = BluetoothAdapterState.unknown;
  StreamSubscription<BluetoothAdapterState>? _adapterStateSubscription;
  List<BluetoothDevice> _systemDevices = [];
  List<ScanResult> _scanResults = [];
  bool _initialConfigWasSent = false;

  List<BluetoothDevice> get systemDevices => _systemDevices;
  set systemDevices(List<BluetoothDevice> value) {
    _systemDevices = value;
  }

  List<ScanResult> get scanResults => _scanResults;
  set scanResults(List<ScanResult> value) {
    _scanResults = value;
  }

  set dbProvider(DatabaseProvider? dbProvider) {
    _dbProvider = dbProvider;
  }

  void updateDb(DatabaseProvider? dbProvider) {
    _dbProvider = dbProvider;
  }

  bool _isScanning = false;
  StreamSubscription<List<ScanResult>>? _scanResultsSubscription;
  StreamSubscription<bool>? _isScanningSubscription;

  //used for connected state
  BluetoothDevice? _device;
  int? _rssi;
  int? _mtuSize;
  BluetoothConnectionState _connectionState =
      BluetoothConnectionState.disconnected;
  BluetoothConnectionState get connectionState => _connectionState;
  List<BluetoothService> _services = [];
  bool _isDiscoveringServices = false;
  bool _isConnecting = false;
  bool _isDisconnecting = false;
  StreamSubscription<BluetoothConnectionState>? _connectionStateSubscription;
  StreamSubscription<int>? _mtuSubscription;

  BluetoothProvider() {
    // FlutterBluePlus.setLogLevel(LogLevel.verbose, color: true);
    FlutterBluePlus.setLogLevel(LogLevel.none, color: true);
  }

  void turnOn() async {
    try {
      if (Platform.isAndroid) {
        await FlutterBluePlus.turnOn();
      }
    } catch (e) {}
  }

  void startListentingToAdapterState() {
    _adapterStateSubscription = FlutterBluePlus.adapterState.listen((state) {
      adapterState = state;
      notifyListeners();
    });
  }

  void stopListeningToAdapterState() {
    _adapterStateSubscription?.cancel();
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

  void stopListeningToScanResults() {
    _scanResultsSubscription?.cancel();
    _isScanningSubscription?.cancel();
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
    _device?.connect();
    notifyListeners();
  }

  void disconect() async {
    try {
      await _device?.disconnect();
    } catch (e) {}
  }

  void initConnection() {
    if (_device != null)
      _connectionStateSubscription =
          _device!.connectionState.listen((state) async {
        _connectionState = state;
        if (state == BluetoothConnectionState.connected) {
          _services = []; // must rediscover services
        }
        if (state == BluetoothConnectionState.connected && _rssi == null) {
          _rssi = await _device!.readRssi();
        }
        notifyListeners();
      });

    _mtuSubscription = _device!.mtu.listen((value) {
      _mtuSize = value;
      notifyListeners();
    });
  }

  void disposeDevice() {
    _connectionStateSubscription?.cancel();
    _mtuSubscription?.cancel();
  }

  bool get isConnected {
    return _connectionState == BluetoothConnectionState.connected;
  }

  void discoverServices() async {
    _isDiscoveringServices = true;
    notifyListeners();

    try {
      _services = await _device!.discoverServices();
      com = Communication(_services);
    } catch (e) {}
    _isDiscoveringServices = false;
    notifyListeners();
  }

  BluetoothDevice? _findDevice(DevicesTableData dbDevice) {
    for (BluetoothDevice systemDevice in systemDevices) {
      String remoteId = systemDevice.remoteId.str;
      if (remoteId == dbDevice.remoteId) {
        return systemDevice;
      }
    }

    for (ScanResult scanResult in scanResults) {
      String remoteId = scanResult.device.remoteId.str;
      if (remoteId == dbDevice.remoteId) {
        return scanResult.device;
      }
    }

    return null;
  }

  void sendConfigurationData() {
    if (_initialConfigWasSent == true) {}

    if (_dbProvider != null) {
      while (_dbProvider!.processDeviceSettingChanges.isNotEmpty) {
        // Remove and get the first element
        int deviceId = _dbProvider!.processDeviceSettingChanges.removeAt(0);
//this isthe device.id form the devices list
      }
    }

    // _dbProvider.parametersChanged; this is boolean, handle for all devices
    // _dbProvider.alarmsChanged; this is boolean, handle for all devices
  }

  void readCollectedData() {
    if (_dbProvider != null) {
      if (_dbProvider!.database != null) {
        if (adapterState == BluetoothAdapterState.on) {
          startListentingToScanResults();
          startScaning();
          var devices = _dbProvider!.devices;
          Future.delayed(Duration(seconds: 1), () {
            devices.forEach((dbDevice) async {
              var device = _findDevice(dbDevice);

              _dbProvider!
                  .updateDevice(dbDevice.copyWith(lastOnline: DateTime.now()));

              if (device != null) {
                connect(device);
                initConnection();
                var deviceParameters = _dbProvider!.deviceParameters;
                await Future.delayed(Duration(seconds: 1));
                discoverServices();
                await Future.delayed(Duration(seconds: 1));
                for (var param in deviceParameters) {
                  var index = param.parameterId;
                  var value = await com!.readParameterValue(index);
                  if (value != null) {
                    _dbProvider!.insertCollectedData(
                      ColectedDataTableCompanion.insert(
                        parameterId: index,
                        deviceId: dbDevice.id,
                        value: value,
                      ),
                    );
                  }
                }

                disposeDevice();
                stopListeningToScanResults();
                stopScaning();
              }
            });
          });
        }
      }
    }
  }
}
