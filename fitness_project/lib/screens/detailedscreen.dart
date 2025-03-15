import 'package:flutter/material.dart';
import 'package:fitness_project/size_config.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.bodyPart});

  final String bodyPart;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  double _soreness = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 239, 239, 239),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // -Recommended Workouts
                // -Minutes trained in past week
                // -Total Minutes Trained
                // -Soreness indicator (Tiredness Factor)
                Text(
                  "${widget.bodyPart}",
                  style: GoogleFonts.exo2(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                  child: SizedBox(
                    height: SizeConfig.blockSizeVertical! * 25,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.query_builder, size: 40),
                              Text(" Minutes Trained This Week: 999",
                                  style: GoogleFonts.exo2(fontSize: 20)),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.punch_clock, size: 40),
                              Text(" Total Minutes Trained: 99999",
                                  style: GoogleFonts.exo2(fontSize: 20)),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.lightbulb, size: 40),
                              Text(" Recommended Workout:",
                                  style: TextStyle(fontSize: 20)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // SizedBox(
                              //   width: 45,
                              // ),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 0),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      backgroundColor: Colors.white),
                                  onPressed: () {},
                                  child: Text("Option 1",
                                      style: GoogleFonts.exo2(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black))),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 0),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      backgroundColor: Colors.white),
                                  onPressed: () {},
                                  child: Text("Option 2",
                                      style: GoogleFonts.exo2(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black))),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 0),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      backgroundColor: Colors.white),
                                  onPressed: () {},
                                  child: Text("Option 3",
                                      style: GoogleFonts.exo2(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black))),
                            ],
                          ),
                        ]),
                  ),
                ),
                SizedBox(
                  height: SizeConfig.blockSizeVertical! * 50,
                  width: SizeConfig.blockSizeHorizontal! * 80,
                  child: Image.asset(
                    'assets/${widget.bodyPart}.png',
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  width: SizeConfig.blockSizeHorizontal! * 80,
                  child: Slider(
                      value: _soreness,
                      min: 0,
                      max: 100,
                      thumbColor: Colors.black,
                      activeColor: (_soreness <= 33)
                          ? Colors.blue
                          : (_soreness <= 66)
                              ? Colors.green
                              : Colors.red,
                      inactiveColor: Colors.white,
                      onChanged: (value) {
                        setState(() {
                          _soreness = value;
                        });
                      }),
                )
              ],
            ),
          ),
        ));
  }
}
