import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fitness_project/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fitness_project/services/data.dart';
import 'package:fitness_project/services/physio.dart';

class RecommendationScreen extends StatefulWidget {
  const RecommendationScreen(
      {super.key, required this.exerciseName, required this.soreness});
  final String exerciseName;
  final double soreness;

  @override
  State<RecommendationScreen> createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  final Data data = Data();
  int _selectedSexIndex = 0;
  int _selectedHeight = 0;
  int _selectedWeight = 0;
  int _selectedAge = 0;

  // function to launch the link
  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  String getLowerSnakecase(String text) {
    return text.toLowerCase().replaceAll(' ', '_');
  }

  @override
  void initState() {
    super.initState();
    // Load saved preferences
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        _selectedSexIndex = prefs.getInt('selectedSexIndex') ?? 0;
        _selectedHeight = prefs.getInt('selectedHeight') ?? 0; // Default 0 cm
        _selectedWeight = prefs.getInt('selectedWeight') ?? 0; // Default 0 kg
        _selectedAge = prefs.getInt('selectedAge') ?? 0; // Default 0 years
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var workoutCharacteristics =
        data.exerciseCharacteristics[widget.exerciseName];
    var videoUrl = workoutCharacteristics?.videoUrl;
    var physioService = PhysioService();

    var bmi = physioService.getBMI(
      _selectedSexIndex == 0 ? 'male' : 'female',
      _selectedHeight,
      _selectedWeight,
      _selectedAge,
    );

    print("BMI: $bmi");

    var recommendation = physioService.recommendSetsAndReps(
      exercise: widget.exerciseName,
      soreness: widget.soreness,
      bmi: bmi,
    );

    var reps = recommendation['reps'] ?? 5;
    var sets = recommendation['sets'] ?? 2;

    return Scaffold(
        appBar: AppBar(),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              // color: Colors.red,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.red,
              ),
              width: SizeConfig.blockSizeHorizontal! * 90,
              height: SizeConfig.blockSizeVertical! * 30,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Image.asset(
                    'assets/exercises/${getLowerSnakecase(widget.exerciseName)}.png'),
              ),
            ),
            Text(
              widget.exerciseName,
              style: GoogleFonts.exo2(
                textStyle: TextStyle(
                  fontSize: 40,
                  //fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text("Reps:"),
                    Text(
                      // random number (3-6) even for now
                      reps.toString(),
                      style: TextStyle(fontSize: 35),
                    )
                  ],
                ),
                Column(
                  children: [
                    Text("Sets:"),
                    Text(
                      // random number (3-9) for now
                      sets.toString(),
                      style: TextStyle(fontSize: 35),
                    )
                  ],
                )
              ],
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              onPressed: () {
                physioService.saveWorkout(
                    DateTime.now(),
                    widget.exerciseName,
                    reps, // reps
                    sets, // sets
                    "Arms");
              },
              child: Text(
                'DEBUG: log workout',
                style: GoogleFonts.exo2(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
              child: TextButton(
                  onPressed: () {
                    _launchURL(videoUrl.toString()); // replace with actual URL
                  },
                  child: Text(
                    'Click to Learn More',
                    style: TextStyle(fontSize: 24),
                  )),
            ),
          ],
        )));
  }
}
