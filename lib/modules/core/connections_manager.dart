import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:trackbar_sdk/modules/core/data_poit.dart';

abstract class ConnectionsManager {
  Future<void> connect();
  Future<void> disconnect();
  Stream<DataPoint> receiveData();
}