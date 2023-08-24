import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:trackbar_sdk/screens/sensor_screen.dart';
import '../main.dart';
import '../widgets.dart';

class DeviceScreen extends StatelessWidget {
  final BluetoothDevice device;

  const DeviceScreen({Key? key, required this.device}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: snackBarKeyC,
      child: Scaffold(
        appBar: AppBar(
          title: Text(device.localName),
          actions: <Widget>[
            StreamBuilder<BluetoothConnectionState>(
              stream: device.connectionState,
              initialData: BluetoothConnectionState.connecting,
              builder: (c, snapshot) {
                VoidCallback? onPressed;
                String text;
                switch (snapshot.data) {
                  case BluetoothConnectionState.connected:
                    onPressed = () async {
                      isConnectingOrDisconnecting[device.remoteId] ??= ValueNotifier(true);
                      isConnectingOrDisconnecting[device.remoteId]!.value = true;
                      try {
                        await device.disconnect();
                        final snackBar = snackBarGood("Disconnect: Success");
                        snackBarKeyC.currentState?.removeCurrentSnackBar();
                        snackBarKeyC.currentState?.showSnackBar(snackBar);
                      } catch (e) {
                        final snackBar = snackBarFail(prettyException("Disconnect Error:", e));
                        snackBarKeyC.currentState?.removeCurrentSnackBar();
                        snackBarKeyC.currentState?.showSnackBar(snackBar);
                      }
                      isConnectingOrDisconnecting[device.remoteId] ??= ValueNotifier(false);
                      isConnectingOrDisconnecting[device.remoteId]!.value = false;
                    };
                    text = 'DISCONNECT';
                    break;
                  case BluetoothConnectionState.disconnected:
                    onPressed = () async {
                      isConnectingOrDisconnecting[device.remoteId] ??= ValueNotifier(true);
                      isConnectingOrDisconnecting[device.remoteId]!.value = true;
                      try {
                        await device.connect(timeout: Duration(seconds: 35));
                        final snackBar = snackBarGood("Connect: Success");
                        snackBarKeyC.currentState?.removeCurrentSnackBar();
                        snackBarKeyC.currentState?.showSnackBar(snackBar);
                      } catch (e) {
                        final snackBar = snackBarFail(prettyException("Connect Error:", e));
                        snackBarKeyC.currentState?.removeCurrentSnackBar();
                        snackBarKeyC.currentState?.showSnackBar(snackBar);
                      }
                      isConnectingOrDisconnecting[device.remoteId] ??= ValueNotifier(false);
                      isConnectingOrDisconnecting[device.remoteId]!.value = false;
                    };
                    text = 'CONNECT';
                    break;
                  default:
                    onPressed = null;
                    text = snapshot.data.toString().split(".").last.toUpperCase();
                    break;
                }
                return ValueListenableBuilder<bool>(
                    valueListenable: isConnectingOrDisconnecting[device.remoteId]!,
                    builder: (context, value, child) {
                      isConnectingOrDisconnecting[device.remoteId] ??= ValueNotifier(false);
                      if (isConnectingOrDisconnecting[device.remoteId]!.value == true) {
                        // Show spinner when connecting or disconnecting
                        return Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: AspectRatio(
                            aspectRatio: 1.0,
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.black12,
                              color: Colors.black26,
                            ),
                          ),
                        );
                      } else {
                        return TextButton(
                            onPressed: onPressed,
                            child: Text(
                              text,
                              style: Theme.of(context).primaryTextTheme.labelLarge?.copyWith(color: Colors.white),
                            ));
                      }
                    });
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              StreamBuilder<BluetoothConnectionState>(
                stream: device.connectionState,
                initialData: BluetoothConnectionState.connecting,
                builder: (c, snapshot) => Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('${device.remoteId}'),
                    ),
                    ListTile(
                      leading: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          snapshot.data == BluetoothConnectionState.connected
                              ? const Icon(Icons.bluetooth_connected)
                              : const Icon(Icons.bluetooth_disabled),
                          snapshot.data == BluetoothConnectionState.connected
                              ? StreamBuilder<int>(
                              stream: rssiStream(maxItems: 1),
                              builder: (context, snapshot) {
                                return Text(snapshot.hasData ? '${snapshot.data}dBm' : '',
                                    style: Theme.of(context).textTheme.bodySmall);
                              })
                              : Text('', style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                      title: Text('Device is ${snapshot.data.toString().split('.')[1]}.'),

                    ),
                    ElevatedButton(
                      child:  Text('Sensor'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: snapshot.data == BluetoothConnectionState.connected?(){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SensorScreen()));
                      }:null,
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Stream<int> rssiStream({Duration frequency = const Duration(seconds: 5), int? maxItems = null}) async* {
    var isConnected = true;
    final subscription = device.connectionState.listen((v) {
      isConnected = v == BluetoothConnectionState.connected;
    });
    int i = 0;
    while (isConnected && (maxItems == null || i < maxItems)) {
      try {
        yield await device.readRssi();
      } catch (e) {
        print("Error reading RSSI: $e");
        break;
      }
      await Future.delayed(frequency);
      i++;
    }
    // Device disconnected, stopping RSSI stream
    subscription.cancel();
  }
}