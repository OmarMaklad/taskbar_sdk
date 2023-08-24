import 'dart:async';


class SensorsController{
  List<double>? userAccelerometerValues;
  List<double>? accelerometerValues;
  List<double>? gyroscopeValues;
  List<double>? magnetometerValues;
  final streamSubscriptions = <StreamSubscription<dynamic>>[];

}