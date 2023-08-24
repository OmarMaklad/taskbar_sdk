
import 'dart:async';

import 'package:flutter_sensors/flutter_sensors.dart';
import 'package:trackbar_sdk/modules/core/data_poit.dart';
import 'package:trackbar_sdk/modules/core/sensor.dart';

class RadarSensor implements Sensor {
  @override
  Future<void> connectToSensor() {
    // TODO: implement connectToSensor
    throw UnimplementedError();
  }

  @override
  Future<void> startSensor() async{
    await SensorManager().sensorUpdates(
      sensorId: Sensors.ACCELEROMETER,
      interval: Sensors.SENSOR_DELAY_FASTEST,
    );
    throw UnimplementedError();
  }

  @override
  Future<void> stopSensor() {

    throw UnimplementedError();
  }

  @override
  Future<DataPoint> getDataPoint() {
    // TODO: implement getDataPoint
    throw UnimplementedError();
  }

  @override
  Future<void> checkSensorStatus() {
    SensorManager()
        .isSensorAvailable(Sensors.ACCELEROMETER)
        .then((result) {
          return result;
    });
    throw UnimplementedError();
  }
  // Implementation of Radar sensor methods
}