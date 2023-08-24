import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../controllers/BLT_controller.dart';
import '../main.dart';
import '../widgets.dart';
import 'device_screen.dart';



class FindDevicesScreen extends StatefulWidget {
  const FindDevicesScreen({Key? key}) : super(key: key);

  @override
  State<FindDevicesScreen> createState() => _FindDevicesScreenState();
}

class _FindDevicesScreenState extends State<FindDevicesScreen> {
  BluetoothController bluetoothController = BluetoothController();
  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: snackBarKeyB,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Find Devices'),
        ),
        body: RefreshIndicator(
          onRefresh: () {
            setState(() {}); // force refresh of connectedSystemDevices
            if (FlutterBluePlus.isScanningNow == false) {
              FlutterBluePlus.startScan(timeout: const Duration(seconds: 15), androidUsesFineLocation: false);
            }
            return Future.delayed(Duration(milliseconds: 500)); // show refresh icon breifly
          },
          child: SingleChildScrollView(
            child: Padding(
              padding:  EdgeInsets.symmetric(horizontal: 15,vertical: 15),
              child: Column(
                children: <Widget>[
                  StreamBuilder<List<ScanResult>>(
                    stream: bluetoothController.scanResults,
                    initialData: const [],
                    builder: (c, snapshot) => Column(
                      children: (snapshot.data ?? []).map((r) => ScanResultTile(
                          result: r,
                          onTap: () => Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) {
                                isConnectingOrDisconnecting[r.device.remoteId] ??= ValueNotifier(true);
                                isConnectingOrDisconnecting[r.device.remoteId]!.value = true;
                                r.device.connect(timeout: Duration(seconds: 35)).catchError((e) {
                                  final snackBar = snackBarFail(prettyException("Connect Error:", e));
                                  snackBarKeyC.currentState?.removeCurrentSnackBar();
                                  snackBarKeyC.currentState?.showSnackBar(snackBar);
                                }).then((v) {
                                  isConnectingOrDisconnecting[r.device.remoteId] ??= ValueNotifier(false);
                                  isConnectingOrDisconnecting[r.device.remoteId]!.value = false;
                                });
                                return DeviceScreen(device: r.device);
                              },
                              settings: RouteSettings(name: '/deviceScreen'))),
                        ),
                      )
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: StreamBuilder<bool>(
          stream: FlutterBluePlus.isScanning,
          initialData: false,
          builder: (c, snapshot) {
            if (snapshot.data ?? false) {
              return FloatingActionButton(
                child: const Icon(Icons.stop),
                onPressed: () async {
                  try {
                    bluetoothController.stopScan();
                  } catch (e) {
                    final snackBar = snackBarFail(prettyException("Stop Scan Error:", e));
                    snackBarKeyB.currentState?.removeCurrentSnackBar();
                    snackBarKeyB.currentState?.showSnackBar(snackBar);
                  }
                },
                backgroundColor: Colors.red,
              );
            } else {
              return FloatingActionButton(
                  child: const Text("SCAN"),
                  onPressed: () async {
                    try {
                      if (FlutterBluePlus.isScanningNow == false) {
                        bluetoothController.scanDevice();
                      }
                    } catch (e) {
                      final snackBar = snackBarFail(prettyException("Start Scan Error:", e));
                      snackBarKeyB.currentState?.removeCurrentSnackBar();
                      snackBarKeyB.currentState?.showSnackBar(snackBar);
                    }
                    setState(() {}); // force refresh of connectedSystemDevices
                  });
            }
          },
        ),
      ),
    );
  }
}