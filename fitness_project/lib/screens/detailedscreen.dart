import 'package:flutter/material.dart';
import 'package:fitness_project/size_config.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fitness_project/screens/recommendation.dart';
import 'package:fitness_project/services/data.dart';
import 'package:fitness_project/services/physio.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.bodyPart});

  final String bodyPart;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final PhysioService _physio = PhysioService();
  final Data data = Data();
  double _soreness = 70;
  String option_1 = "Benches";
  String option_2 = "Flies";
  String option_3 = "Push-ups";

  int minutesTrainedThisWeek = 0;
  int totalMinutesTrained = 0;

  Color _partColor = Colors.blue; // Default color

  @override
  void initState() {
    super.initState();

    List<String> exercises = data.currentRecommendedWorkouts.split(', ');
    option_1 = exercises[0];
    option_2 = exercises[1];
    option_3 = exercises[2];
    print("Options: $option_1, $option_2, $option_3");
    print("Body part: ${widget.bodyPart}");

    _loadSorenessColor();
  }

  Future<void> _loadSorenessColor() async {
    // 1. initialize & read stored history + workouts
    await _physio.init();
    final entries = await _physio.loadWorkouts();

    // 2. compute colors
    //    If you have an impactMap structure, pass it here.
    //    Your service actually reads Data().exerciseCharacteristics internally,
    //    but you still need to supply *something*:
    final impactMaps = <String, Map<String, double>>{};
    final colorMap = await _physio.processWorkouts(entries, impactMaps);

    // 3. pick out the color for this bodyPart, e.g. "chest_color"
    final key = '${widget.bodyPart.toLowerCase()}_color';
    final colorName = colorMap[key] ?? 'blue';

    // 4. map the string → a Flutter Color
    setState(() {
      _partColor = _stringToColor(colorName);
    });
  }

  Color _stringToColor(String s) {
    switch (s) {
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      case 'red':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    print("Part Color: $_partColor");
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
                  style: GoogleFonts.barlow(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                  child: SizedBox(
                    height: SizeConfig.blockSizeVertical! * 25,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.query_builder, size: 40),
                              Text(" Minutes Trained This Week: 57",
                                  style: GoogleFonts.exo2(fontSize: 20)),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.punch_clock, size: 40),
                              Text(" Total Minutes Trained: 192",
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
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
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
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  RecommendationScreen(
                                                    exerciseName: option_1,
                                                  )));
                                    },
                                    child: Text(option_1,
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
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  RecommendationScreen(
                                                    exerciseName: option_2,
                                                  )));
                                    },
                                    child: Text(option_2,
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
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  RecommendationScreen(
                                                    exerciseName: option_3,
                                                  )));
                                    },
                                    child: Text(option_3,
                                        style: GoogleFonts.exo2(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black))),
                              ],
                            ),
                          ),
                        ]),
                  ),
                ),
                Stack(
                  children: [
                    SizedBox(
                      height: SizeConfig.blockSizeVertical! * 50,
                      width: SizeConfig.blockSizeHorizontal! * 80,
                      // TODO: use the commented code instead later
                      /*
                      ColorFiltered(
                        colorFilter: ColorFilter.mode(_partColor, BlendMode.modulate),
                        child: Image.asset(
                          'assets/${widget.bodyPart}.png',
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                       */
                      child: Image.asset(
                        'assets/${widget.bodyPart}.png',
                        // 'assets/Pecs.png',
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: SizeConfig.blockSizeHorizontal! * 80,
                  child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 20,
                        thumbShape: SliderComponentShape.noThumb,
                      ),
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
                          })),
                )
              ],
            ),
          ),
        ));
  }
}
