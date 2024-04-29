import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothProvider extends ChangeNotifier {
  BluetoothAdapterState adapterState = BluetoothAdapterState.unknown;
  late StreamSubscription<BluetoothAdapterState> _adapterStateSubscription;
  List<BluetoothDevice> _systemDevices = [];
  List<ScanResult> _scanResults = [];

  List<BluetoothDevice> get systemDevices => _systemDevices;
  set systemDevices(List<BluetoothDevice> value) {
    _systemDevices = value;
  }

  List<ScanResult> get scanResults => _scanResults;
  set scanResults(List<ScanResult> value) {
    _scanResults = value;
  }

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
  late BluetoothCharacteristic _characteristic;
  late List<int> data;

  BluetoothProvider() {
    FlutterBluePlus.setLogLevel(LogLevel.verbose, color: true);
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
      await FlutterBluePlus.startScan(
          timeout: const Duration(seconds: 15));
    } catch (e) {}
  }

  void stopScaning() async {
    try {
      FlutterBluePlus.stopScan();
    } catch (e) {}
  }

  void refresh() {
    if (_isScanning == false) {
      FlutterBluePlus.startScan(
          timeout: const Duration(seconds: 15));
    }
    notifyListeners();
  }

  void connect(BluetoothDevice device) {
    _device = device;
    _device.connect(autoConnect: true);
    notifyListeners();
  }

  void disconect() async {
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

  void selectCharacteristic(BluetoothCharacteristic characteristic) {
    _characteristic = characteristic;
    notifyListeners();
  }

  Future<void> writeDataInt(int data, int size) async {
    ByteData bytes = ByteData(size);
    switch (size) {
      case 1:
        bytes.setInt8(0, data);
        break;
      case 2:
        bytes.setInt16(0, data, Endian.little);
        break;
      case 4:
        bytes.setInt32(0, data, Endian.little);
        break;
      case 8:
        bytes.setInt64(0, data, Endian.little);
        break;
      default:
        throw ArgumentError('Unsupported integer size: $size');
    }
    List<int> dataList = bytes.buffer.asUint8List();
    try {
      await _characteristic.write(dataList);
    } catch (e) {
      // Handle write data error
    }
  }

  void writeDataInt8(int data) async {
    await writeDataInt(data, 1);
  }

  void writeDataInt32(int data) async {
    await writeDataInt(data, 4);
  }

  void writeDataInt64(int data) async {
    await writeDataInt(data, 8);
  }

  Future<void> writeDataFloat(double data) async {
    ByteData bytes = ByteData(4);
    bytes.setFloat32(0, data, Endian.little);
    List<int> dataList = bytes.buffer.asUint8List();
    try {
      await _characteristic.write(dataList);
    } catch (e) {
      // Handle write data error
    }
  }

  Future<int?> readDataInt(int size) async {
    try {
      List<int> data = await _characteristic.read();
      if (data.length < size) {
        throw FormatException('Insufficient data length');
      }
      ByteData bytes = ByteData.sublistView(Uint8List.fromList(data));
      switch (size) {
        case 1:
          return bytes.getInt8(0);
        case 2:
          return bytes.getInt16(0, Endian.little);
        case 4:
          return bytes.getInt32(0, Endian.little);
        case 8:
          return bytes.getInt64(0, Endian.little);
        default:
          throw ArgumentError('Unsupported integer size: $size');
      }
    } catch (e) {
      // Handle read data error
      return null;
    }
  }

  void readDataInt8() async {
    await readDataInt(1);
  }

  void readDataInt32() async {
    await readDataInt(4);
  }

  void readDataInt64() async {
    await readDataInt(8);
  }

  Future<double?> readDataFloat32() async {
    try {
      List<int> data = await _characteristic.read();
      if (data.length < 4) {
        throw FormatException('Insufficient data length');
      }
      ByteData bytes = ByteData.sublistView(Uint8List.fromList(data));
      bytes.getFloat32(0, Endian.little);
    } catch (e) {
      // Handle read data error
      return null;
    }
  }
}
