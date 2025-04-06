import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fitness_project/size_config.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

class RecommendationScreen extends StatelessWidget {
  const RecommendationScreen({super.key, required this.exerciseName});
  final String exerciseName;

  // function to launch the link
  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
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
              child: Image.asset('assets/man.png'),
            ),
            Text(
              exerciseName,
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
                      ((Random().nextInt(3) + 3) * 2).toString(),
                      style: TextStyle(fontSize: 35),
                    )
                  ],
                ),
                Column(
                  children: [
                    Text("Sets:"),
                    Text(
                      // random number (3-9) for now
                      (Random().nextInt(5) + 3).toString(),
                      style: TextStyle(fontSize: 35),
                    )
                  ],
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
              child: TextButton(
                  onPressed: () {
                    _launchURL(
                        'https://www.youtube.com/watch?v=WDIpL0pjun0&ab_channel=NationalAcademyofSportsMedicine%28NASM%29'); // replace with actual URL
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
