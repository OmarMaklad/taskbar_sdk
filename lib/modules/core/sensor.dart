import 'data_poit.dart';

abstract class Sensor {
  Future<void> checkSensorStatus();
  Future<void> connectToSensor();
  Future<void> startSensor();
  Future<DataPoint> getDataPoint();
  Future<void> stopSensor();
}