import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothController{


  Future scanDevice()async {
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 15), androidUsesFineLocation: false);

  }
  Future stopScan()async{
    FlutterBluePlus.stopScan();
  }

  Stream<List<ScanResult>> get scanResults=> FlutterBluePlus.scanResults;



}