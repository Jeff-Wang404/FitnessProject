import 'package:flutter/material.dart';
import 'package:fitness_project/size_config.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fitness_project/components/human.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  bool isPaired = false;

  Future<void> checkIfConnected() async {
    final connectedDevices = FlutterBluePlus.connectedDevices;
    if (connectedDevices.isNotEmpty) {
      print("Connected devices: $connectedDevices");
      setState(() {
        isPaired = true;
      });
    } else {
      setState(() {
        isPaired = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    checkIfConnected();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 239, 239, 239),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 239, 239, 239),
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.pushNamed(context, '/settings');
              },
            )
          ],
        ),
        body: Center(
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  HumanWidget(scale: 1.0),
                  SizedBox(
                    height: SizeConfig.blockSizeVertical! * 8,
                  ),
                  SizedBox(
                    height: SizeConfig.blockSizeVertical! * 8,
                    width: SizeConfig.blockSizeHorizontal! * 80,
                    // (expression) ? (true) : (false)
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                        ),
                        onPressed: (isPaired)
                            ? () {}
                            : () {
                                Navigator.pushNamed(context, '/connect');
                              },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                          child: Text((isPaired) ? "Connected" : "Pair Device",
                              style: GoogleFonts.exo2(
                                  fontSize: 40,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        )),
                  ),
                  // ElevatedButton(
                  //     onPressed: () {
                  //       setState(() {
                  //         isPaired = !isPaired;
                  //       });
                  //     },
                  //     child: Text("test"))
                ],
              ),
            ),
          ),
        ));
  }
}
