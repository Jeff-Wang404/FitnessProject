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
  StreamSubscription<ScanResult>? scanSubscription;
  String statusMessage = "Not Connected";

  // late AnimationController _animationController;
  late Animation<double> _pulseAnimation;

  // function to check if already connected

  // function to start scanning for devices advertising the service

  // function to attempt connecting to a device

  // function to disconnect from a device

  // helper function to render changes in the UI

  @override
  void initState() {
    super.initState();
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
    scanSubscription?.cancel();
    super.dispose();
  }

  void _onBluetoothPressed() {
    if (_controller.isAnimating) {
      _controller.stop();
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
              SizedBox(
                  height: SizeConfig.blockSizeVertical! * 10,
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
