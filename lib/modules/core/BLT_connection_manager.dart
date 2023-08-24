import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:trackbar_sdk/modules/core/data_poit.dart';
import 'connections_manager.dart';

class BLEConnectionManager implements ConnectionsManager {
  @override
  Future<void> connect() {
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 15), androidUsesFineLocation: false);
    throw UnimplementedError();
  }

  @override
  Future<void> disconnect() {
    FlutterBluePlus.stopScan();
    throw UnimplementedError();
  }

  @override
  Stream<DataPoint> receiveData() {
     FlutterBluePlus.scanResults;
    throw UnimplementedError();
  }



}

