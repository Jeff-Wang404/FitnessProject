import 'package:flutter/material.dart';
import 'package:fitness_project/size_config.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class HumanWidget extends StatefulWidget {
  const HumanWidget({super.key});

  @override
  State<HumanWidget> createState() => _HumanWidgetState();
}

class _HumanWidgetState extends State<HumanWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.orange,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              'assets/model.png',
              height: SizeConfig.blockSizeVertical! * 60,
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
                              bodyPart: "Right Arm",
                            );
                          },
                        );
                      },
                      child: Container(
                        color: const Color.fromARGB(48, 244, 67, 54),
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
                            return BodyPopup(bodyPart: "torso");
                          },
                        );
                      },
                      child: Container(
                        color: const Color.fromARGB(48, 33, 149, 243),
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
                                bodyPart: "Left Arm",
                              );
                            },
                          );
                        },
                        child: Container(
                          color: const Color.fromARGB(49, 76, 175, 79),
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
                          print('Long Press');
                          HapticFeedback.mediumImpact();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return BodyPopup(
                                bodyPart: "Right Leg",
                              );
                            },
                          );
                        },
                        child: Container(
                          color: const Color.fromARGB(49, 76, 175, 79),
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
                                bodyPart: "Left Leg",
                              );
                            },
                          );
                        },
                        child: Container(
                          color: const Color.fromARGB(52, 244, 67, 54),
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
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black,
      contentPadding: EdgeInsets.all(0),
      content: SizedBox(
        width: SizeConfig.blockSizeHorizontal! * 80,
        height: SizeConfig.blockSizeVertical! * 40,
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
                    Text("Calories Burned: 1000",
                        style: GoogleFonts.exo2(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.whatshot, color: Colors.white),
                    Text("Reps Trained: 1000",
                        style: GoogleFonts.exo2(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.whatshot, color: Colors.white),
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
                Text("String",
                    textAlign: TextAlign.left,
                    style: GoogleFonts.exo2(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/detailed');
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
