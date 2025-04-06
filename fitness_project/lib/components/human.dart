import 'package:flutter/material.dart';
import 'package:fitness_project/size_config.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fitness_project/services/data.dart';
import 'package:fitness_project/screens/detailedscreen.dart';

class HumanWidget extends StatefulWidget {
  const HumanWidget({super.key});

  @override
  State<HumanWidget> createState() => _HumanWidgetState();
}

class _HumanWidgetState extends State<HumanWidget> {
  // String exampleColor = "blue";
  final Data data = Data();

  // Body part colors
  String chestColor = "blue";
  String absColor = "blue";
  String shouldersColor = "blue";
  String bicepsColor = "blue";
  String forearmsColor = "blue";
  String thighsColor = "blue";
  String shinsColor = "blue";

  void getBodyColors() {
    // Get the body part colors from the data
    if (data.data.containsKey("chest_color")) {
      chestColor = data.data["chest_color"];
    }
    if (data.data.containsKey("abs_color")) {
      absColor = data.data["abs_color"];
    }
    if (data.data.containsKey("shoulders_color")) {
      shouldersColor = data.data["shoulders_color"];
    }
    if (data.data.containsKey("biceps_color")) {
      bicepsColor = data.data["biceps_color"];
    }
    if (data.data.containsKey("forearms_color")) {
      forearmsColor = data.data["forearms_color"];
    }
    if (data.data.containsKey("thighs_color")) {
      thighsColor = data.data["thighs_color"];
    }
    if (data.data.containsKey("shins_color")) {
      shinsColor = data.data["shins_color"];
    }
  }

  @override
  void initState() {
    super.initState();
    getBodyColors();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: const Color.fromARGB(255, 239, 239, 239),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Stack(
              children: [
                Positioned(
                    top: SizeConfig.blockSizeVertical! * 3.8,
                    left: SizeConfig.blockSizeHorizontal! * 32,
                    child: Image.asset(
                      //'assets/chest_$exampleColor.png',
                      'assets/chest_$chestColor.png',
                      width: SizeConfig.blockSizeHorizontal! * 25.5,
                    )),
                Positioned(
                    top: SizeConfig.blockSizeVertical! * 11,
                    left: SizeConfig.blockSizeHorizontal! * 35,
                    child: Image.asset(
                      'assets/abs_$absColor.png',
                      width: SizeConfig.blockSizeHorizontal! * 20,
                    )),
                Positioned(
                    top: SizeConfig.blockSizeVertical! * 3.5,
                    left: SizeConfig.blockSizeHorizontal! * 27.5,
                    child: Image.asset(
                      //'assets/shoulders_$exampleColor.png',
                      'assets/shoulders_$shouldersColor.png',
                      width: SizeConfig.blockSizeHorizontal! * 35,
                    )),
                Positioned(
                    top: SizeConfig.blockSizeVertical! * 7,
                    left: SizeConfig.blockSizeHorizontal! * 21.5,
                    child: Image.asset(
                      'assets/biceps_$bicepsColor.png',
                      width: SizeConfig.blockSizeHorizontal! * 47.2,
                    )),
                Positioned(
                    top: SizeConfig.blockSizeVertical! * 10,
                    left: SizeConfig.blockSizeHorizontal! * 12,
                    child: Image.asset(
                      'assets/forearms_$forearmsColor.png',
                      width: SizeConfig.blockSizeHorizontal! * 66,
                    )),
                Positioned(
                    top: SizeConfig.blockSizeVertical! * 17,
                    left: SizeConfig.blockSizeHorizontal! * 31,
                    child: Image.asset(
                      'assets/thighs_$thighsColor.png',
                      width: SizeConfig.blockSizeHorizontal! * 28,
                    )),
                Positioned(
                    top: SizeConfig.blockSizeVertical! * 35,
                    left: SizeConfig.blockSizeHorizontal! * 32.5,
                    child: Image.asset(
                      'assets/shins_$shinsColor.png',
                      width: SizeConfig.blockSizeHorizontal! * 25,
                    )),
                Image.asset(
                  'assets/wireframe.png',
                  // height: SizeConfig.blockSizeVertical! * 60,
                  width: SizeConfig.blockSizeHorizontal! * 90,
                ),
              ],
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        print('Human');
                      },
                      onLongPress: () {
                        print('Long Press');
                        HapticFeedback.mediumImpact();
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return BodyPopup(
                              bodyPart: "Arms",
                            );
                          },
                        );
                      },
                      child: Container(
                        color: const Color.fromARGB(0, 244, 67, 54),
                        width: SizeConfig.blockSizeHorizontal! * 10,
                        height: SizeConfig.blockSizeVertical! * 18,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        print('Human');
                      },
                      onLongPress: () {
                        print('Long Press');
                        HapticFeedback.mediumImpact();
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return BodyPopup(bodyPart: "Pecs");
                          },
                        );
                      },
                      child: Container(
                        color: const Color.fromARGB(0, 33, 149, 243),
                        width: SizeConfig.blockSizeHorizontal! * 25,
                        height: SizeConfig.blockSizeVertical! * 18,
                      ),
                    ),
                    InkWell(
                        onTap: () {
                          print('Human');
                        },
                        onLongPress: () {
                          print('Long Press');
                          HapticFeedback.mediumImpact();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return BodyPopup(
                                bodyPart: "Arms",
                              );
                            },
                          );
                        },
                        child: Container(
                          color: const Color.fromARGB(0, 76, 175, 79),
                          width: SizeConfig.blockSizeHorizontal! * 10,
                          height: SizeConfig.blockSizeVertical! * 18,
                        ))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                        onTap: () {
                          print('Human');
                        },
                        onLongPress: () {
                          HapticFeedback.mediumImpact();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return BodyPopup(
                                bodyPart: "Legs",
                              );
                            },
                          );
                        },
                        child: Container(
                          color: const Color.fromARGB(0, 76, 175, 79),
                          width: SizeConfig.blockSizeHorizontal! * 10,
                          height: SizeConfig.blockSizeVertical! * 30,
                        )),
                    Container(
                      color: const Color.fromARGB(0, 244, 67, 54),
                      width: SizeConfig.blockSizeHorizontal! * 8,
                      height: SizeConfig.blockSizeVertical! * 30,
                    ),
                    InkWell(
                        onTap: () {
                          print('Human');
                        },
                        onLongPress: () {
                          print('Long Press');
                          HapticFeedback.mediumImpact();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return BodyPopup(
                                bodyPart: "Legs",
                              );
                            },
                          );
                        },
                        child: Container(
                          color: const Color.fromARGB(0, 244, 67, 54),
                          width: SizeConfig.blockSizeHorizontal! * 10,
                          height: SizeConfig.blockSizeVertical! * 30,
                        ))
                  ],
                )
              ],
            ),
          ],
        ));
  }
}

class BodyPopup extends StatefulWidget {
  BodyPopup({super.key, required this.bodyPart});

  String bodyPart;

  @override
  State<BodyPopup> createState() => _BodyPopupState();
}

class _BodyPopupState extends State<BodyPopup> {
  final Data data = Data();
  String determinePriority() {
    // Get the soreness level of the body part
    String sorenessLevel = data.data.containsKey("${widget.bodyPart}_soreness")
        ? data.data["${widget.bodyPart}_soreness"]
        : "low";

    // Get the user's chosen preset

    return "High";
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black,
      contentPadding: EdgeInsets.all(0),
      content: SizedBox(
        width: SizeConfig.blockSizeHorizontal! * 80,
        height: SizeConfig.blockSizeVertical! * 30,
        child: Card(
          color: Colors.black,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(widget.bodyPart,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.exo2(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Icon(Icons.whatshot, color: Colors.white),
                    Text(
                        "Calories Burned (Week): ${Data().data.containsKey("${widget.bodyPart}_calories") ? Data().data["${widget.bodyPart}_calories"] : 0}", // TODO: integrate the health package when time permits
                        style: GoogleFonts.exo2(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.whatshot, color: Colors.white),
                    Text(
                        "Reps Trained (Week): ${Data().data.containsKey("${widget.bodyPart}_reps") ? Data().data["${widget.bodyPart}_reps"] : 0}",
                        style: GoogleFonts.exo2(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.whatshot, color: Colors.white),
                    /*
                    Priority is based on the following:
                    - if that body part is part of the group the user is focusing on
                    - the soreness level of that body part
                     */
                    Text("Muscle Group Priority: High",
                        style: GoogleFonts.exo2(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.whatshot, color: Colors.white),
                    Text("Recommended Workouts:",
                        style: GoogleFonts.exo2(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                Text("Benches, Flies, Push-ups",
                    textAlign: TextAlign.left,
                    style: GoogleFonts.exo2(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
                ElevatedButton(
                    onPressed: () {
                      // go to the detailed view, pass in the body part argument
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailScreen(
                                    bodyPart: widget.bodyPart,
                                  )));
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.white),
                    child: Text("Detailed View",
                        style: GoogleFonts.exo2(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(200, 0, 0, 0))))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
