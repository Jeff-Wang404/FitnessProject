import 'package:flutter/material.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class ConnectScreen extends StatefulWidget {
  const ConnectScreen({super.key});

  @override
  State<ConnectScreen> createState() => _ConnectScreenState();
}

class _ConnectScreenState extends State<ConnectScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _fetchConnectedDevices();
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
        body: Padding(
          padding: const EdgeInsets.fromLTRB(100, 0, 100, 100),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/Connect.jpg'),
                Text("Device Not Paired", style: TextStyle(fontSize: 20)),
                TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                    ),
                    onPressed: () {
                      AppSettings.openAppSettings(
                          type: AppSettingsType.bluetooth);
                    },
                    child: Text("Go to Settings",
                        style:
                            TextStyle(fontSize: 20, color: Colors.blueAccent))),
              ],
            ),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 239, 239, 239));
  }
}
