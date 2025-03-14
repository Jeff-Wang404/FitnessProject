import 'package:flutter/material.dart';
import 'package:fitness_project/size_config.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fitness_project/components/human.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  bool isPaired = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 239, 239, 239),
        body: Center(
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  HumanWidget(),
                  SizedBox(
                    height: SizeConfig.blockSizeVertical! * 8,
                    width: SizeConfig.blockSizeHorizontal! * 80,
                    // (expression) ? (true) : (false)
                    child: (isPaired)
                        ? Container()
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, '/connect');
                            },
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                              child: Text("Pair Device",
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
