import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class DataPoint {
  Stream<List<ScanResult>> get scanResults=> FlutterBluePlus.scanResults;
}

