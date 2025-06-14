import 'dart:async';

import 'package:flutter/material.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:fitness_project/size_config.dart';
import 'package:google_fonts/google_fonts.dart';

class ConnectScreen extends StatefulWidget {
  const ConnectScreen({super.key});

  @override
  State<ConnectScreen> createState() => _ConnectScreenState();
}

class _ConnectScreenState extends State<ConnectScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final FlutterBluePlus flutterBlue = FlutterBluePlus();

  static Guid serviceUuid = Guid('6E400001-B5A3-F393-E0A9-E50E24DCCA9E');
  bool isScanning = false;
  List<ScanResult> scanResults = [];
  late StreamSubscription<List<ScanResult>> scanSubscription;
  String statusMessage = "Not Connected";
  BluetoothDevice? _connectedDevice;

  // late AnimationController _animationController;
  late Animation<double> _pulseAnimation;

  // function to check if already connected
  Future<void> _checkConnectedDevices() async {
    try {
      final devices = await FlutterBluePlus.connectedDevices;
      if (devices.isNotEmpty) {
        for (final device in devices) {
          final services = await device.discoverServices();
          if (services.any((s) => s.uuid == serviceUuid)) {
            _connectedDevice = device;
            setState(() {
              statusMessage = "Connected!";
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              return;
            });
          }
        }
      }
    } catch (e) {
      print("Error fetching connected devices: $e");
    }
  }

  // function to start scanning for devices advertising the service
  void _startScanning() {
    print("Starting scan...");
    FlutterBluePlus.startScan(
      withServices: [serviceUuid],
      timeout: const Duration(seconds: 10), // original: 999 seconds
    );
    scanSubscription = FlutterBluePlus.scanResults.listen(
      (results) {
        setState(() {
          scanResults = results;
          for (var result in results) {
            // print(result.advertisementData.serviceUuids);
            // print(serviceUuid.toString());
            // print(result.advertisementData.serviceUuids[0] == serviceUuid);
            if (result.advertisementData.serviceUuids.contains(serviceUuid)) {
              print("Found device: ${result.device.advName}");
              FlutterBluePlus.stopScan();
              scanSubscription.cancel();
              _connectToDevice(result.device);
              return;
            }
          }
          setState(() {
            scanResults = results;
            // If you wish, put a message here to indicate no devices found
          });
        });
      },
    );
  }

  // function to attempt connecting to a device
  Future<void> _connectToDevice(BluetoothDevice device) async {
    try {
      print("Attempting to connect to ${device.advName}");
      await device.connect();
      final services = await device.discoverServices();
      if (services.any((s) => s.uuid == serviceUuid)) {
        setState(() {
          print("Connected to ${device.advName}");
          _connectedDevice = device;
          statusMessage = "Connected!";
          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        });
      } else {
        setState(() {
          statusMessage = "Failed to connect to device.";
        });
      }
    } catch (e) {
      setState(() {
        statusMessage = "Error connecting to device: $e";
      });
    } finally {
      scanSubscription.cancel();
    }
  }

  // function to disconnect from a device
  Future<void> _disconnectFromDevice() async {
    if (_connectedDevice != null) {
      await _connectedDevice!.disconnect();
      setState(() {
        print("Disconnected from device");
        _connectedDevice = null;
        statusMessage = "Disconnected";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _checkConnectedDevices();
    _fetchConnectedDevices();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
      lowerBound: 0.8,
      upperBound: 1.0,
    );

    _pulseAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    scanSubscription.cancel();
    super.dispose();
  }

  void _onBluetoothPressed() {
    if (_controller.isAnimating) {
      _controller.stop();
      FlutterBluePlus.stopScan();
      scanSubscription.cancel();
      _disconnectFromDevice();
      setState(() {
        isScanning = false;
        statusMessage = "Not Connected";
      });
    } else {
      _controller.forward();
      setState(() {
        isScanning = true;
        statusMessage = "Scanning...";
      });
      _startScanning();
    }

    // other logic
  }

  Future<void> _fetchConnectedDevices() async {
    try {
      final devices = await FlutterBluePlus.connectedDevices;
      setState(() {
        print(devices);
        if (devices.isNotEmpty) {
          Navigator.pushNamed(context, '/home');
        }
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 239, 239, 239),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ScaleTransition(
                scale: _pulseAnimation,
                child: Ink(
                  height: SizeConfig.blockSizeHorizontal! * 80,
                  width: SizeConfig.blockSizeHorizontal! * 80,
                  decoration: const ShapeDecoration(
                      color: Colors.white, shape: CircleBorder()),
                  child: IconButton(
                    color: const Color.fromARGB(255, 0, 0, 0),
                    icon: const Icon(Icons.bluetooth, size: 200),
                    onPressed: _onBluetoothPressed,
                  ),
                ),
              ),
              Column(
                children: [
                  SizedBox(
                      height: SizeConfig.blockSizeVertical! * 11,
                      width: SizeConfig.blockSizeHorizontal! * 80,
                      child: Card(
                          color: Colors.white,
                          child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("RepSync Device",
                                      style: GoogleFonts.exo2(
                                          fontSize: 20,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold)),
                                  Text(statusMessage)
                                ],
                              )))),
                  (_connectedDevice != null)
                      ? SizedBox(
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 0, 0, 0),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              onPressed: () {},
                              child: Text("Disconnect")),
                        )
                      : Container(),
                ],
              )
            ],
          ),
        ),
        // body: Padding(
        //   padding: const EdgeInsets.fromLTRB(100, 0, 100, 100),
        //   child: Center(
        //     child: Column(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         Image.asset('assets/Connect.jpg'),
        //         Text("Device Not Paired", style: TextStyle(fontSize: 20)),
        //         TextButton(
        //             style: TextButton.styleFrom(
        //               foregroundColor: const Color.fromARGB(255, 0, 0, 0),
        //             ),
        //             onPressed: () {
        //               AppSettings.openAppSettings(
        //                   type: AppSettingsType.bluetooth);
        //             },
        //             child: Text("Go to Settings",
        //                 style:
        //                     TextStyle(fontSize: 20, color: Colors.blueAccent))),
        //       ],
        //     ),
        //   ),
        // ),
        backgroundColor: const Color.fromARGB(255, 239, 239, 239));
  }
}
