import 'package:flutter/material.dart';
import 'package:fitness_project/size_config.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fitness_project/components/human.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*
Soreness Calculation:
- Time window: 7 days
- Weight for each day (most core days are from actions 48-72 hours ago):
  - 1 day ago: 0.5
  - 2 days ago: 0.3
  - 3 days ago: 0.2
  - 4 days ago: 0.1
  - 5 days ago: 0.05
  - 6 days ago: 0.02
  - 7 days ago: 0.01
- Total soreness = sum of (weight * soreness for that day)

Shared Preferences:
- Store the last 7 days of soreness data
- Use a list of doubles to represent soreness for each day
- variable name: "sorenessData"
 */

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  bool isPaired = false;
  List<double> sorenessData = List<double>.filled(7, 0.0);
  final List<double> weights = [
    0.15, // 1 day ago
    0.35, // 2 days ago
    0.25, // 3 days ago
    0.15, // 4 days ago
    0.06, // 5 days ago
    0.03, // 6 days ago
    0.01, // 7 days ago
  ];

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

  Future<void> _loadSorenessData() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList('sorenessData') ?? [];
    // Convert stored string list to doubles, ensure length 7
    List<double> parsed = List<double>.filled(7, 0.0);
    for (int i = 0; i < stored.length && i < 7; i++) {
      parsed[i] = double.tryParse(stored[i]) ?? 0.0;
    }
    setState(() => sorenessData = parsed);
  }

  /// Calculates total soreness by weighting each day's soreness.
  double calculateTotalSoreness() {
    double total = 0.0;
    for (int i = 0; i < weights.length; i++) {
      total += weights[i] * sorenessData[i];
    }
    return total;
  }

  /// Infers workout intensity from reps (fewer reps = heavier load)
  double intensityFactor(int reps) {
    if (reps <= 4) return 1.0;
    if (reps <= 5) return 0.90;
    if (reps <= 6) return 0.85;
    if (reps <= 8) return 0.75;
    if (reps <= 10) return 0.70;
    if (reps <= 12) return 0.65;
    return 0.60;
  }

  @override
  void initState() {
    super.initState();
    checkIfConnected();
    _loadSorenessData();
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
