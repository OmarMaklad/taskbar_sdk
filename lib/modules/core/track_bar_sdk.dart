import 'package:trackbar_sdk/modules/core/redar_sensor.dart';
import 'package:trackbar_sdk/modules/core/sensor.dart';

import 'BLT_connection_manager.dart';
import 'connections_manager.dart';
import 'data_poit.dart';

class TrackbarSDK {
  final Sensor sensor;
  final ConnectionsManager communicationManager;

  TrackbarSDK(this.sensor, this.communicationManager);

  Future<void> connectToSensor() async {
    await sensor.connectToSensor();
    await communicationManager.connect();
  }

  Future<void> startSensor() async {
    await sensor.startSensor();

  }

  Future<DataPoint> getDataPoint() async {
    return await sensor.getDataPoint();
  }

  Future<void> stopSensor() async {
    await sensor.stopSensor();
    await communicationManager.disconnect();
  }
}

void main() async {
  final ConnectionsManager communicationManager = BLEConnectionManager();
  final Sensor sensor = RadarSensor();
  final TrackbarSDK sdk = TrackbarSDK(sensor, communicationManager);

  await sdk.connectToSensor();
  await sdk.startSensor();

  for (int i = 0; i < 10; i++) {
    final dataPoint = await sdk.getDataPoint();
    print('Received Data: $dataPoint');
  }

  await sdk.stopSensor();
}






