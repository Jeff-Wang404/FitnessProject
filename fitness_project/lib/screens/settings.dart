import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

const List<String> _sexOptions = <String>['Male', 'Female'];

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  int _selectedSexIndex = 0;
  int _selectedHeight = 0;
  int _selectedWeight = 0;
  int _selectedAge = 0;
  void _showDialog(Widget child) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        // The Bottom margin is provided to align the popup above the system navigation bar.
        margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        // Provide a background color for the popup.
        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(top: false, child: child),
      ),
    );
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
    return Scaffold(
        appBar: AppBar(
          title: Text("Health Details",
              style: GoogleFonts.exo2(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              )),
          centerTitle: true,
        ),
        body: Center(
            child: Container(
          color: const Color.fromARGB(0, 251, 255, 241),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 24.0, 8.0, 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Sex: ",
                        style: GoogleFonts.exo2(
                          fontSize: 16,
                        )),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black,
                      ),
                      onPressed: () {
                        _showDialog(
                          CupertinoPicker(
                            magnification: 1.22,
                            squeeze: 1.2,
                            useMagnifier: true,
                            itemExtent: 32.0,
                            scrollController: FixedExtentScrollController(
                                initialItem: _selectedSexIndex),
                            onSelectedItemChanged: (int index) {
                              setState(() {
                                _selectedSexIndex = index;
                                // Save the selected
                                SharedPreferences.getInstance().then((prefs) {
                                  prefs.setInt('selectedSexIndex', index);
                                });
                              });
                            },
                            children: _sexOptions
                                .map((String value) => Center(
                                      child: Text(value,
                                          style: GoogleFonts.exo2(
                                            fontSize: 16,
                                          )),
                                    ))
                                .toList(),
                          ),
                        );
                      },
                      child: Text(_sexOptions[_selectedSexIndex],
                          style: GoogleFonts.exo2(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ],
                ),
              ),
              Divider(indent: 8.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Height: ",
                        style: GoogleFonts.exo2(
                          fontSize: 16,
                        )),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black,
                      ),
                      onPressed: () {
                        _showDialog(
                          CupertinoPicker(
                            magnification: 1.22,
                            squeeze: 1.2,
                            useMagnifier: true,
                            itemExtent: 32.0,
                            scrollController:
                                FixedExtentScrollController(initialItem: 0),
                            onSelectedItemChanged: (int index) {
                              // Handle height selection
                              setState(() {
                                _selectedHeight =
                                    index + 100; // Height from 100 to 300 cm
                                // Save the selected height
                                SharedPreferences.getInstance().then((prefs) {
                                  prefs.setInt(
                                      'selectedHeight', _selectedHeight);
                                });
                              });
                            },
                            children: List<Widget>.generate(
                                201,
                                (int index) => Center(
                                      child: Text("${index + 100} cm",
                                          style: GoogleFonts.exo2(
                                            fontSize: 16,
                                          )),
                                    )),
                          ),
                        );
                      },
                      child: Text("$_selectedHeight cm",
                          style: GoogleFonts.exo2(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ],
                ),
              ),
              Divider(indent: 8.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Weight: ",
                        style: GoogleFonts.exo2(
                          fontSize: 16,
                        )),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black,
                      ),
                      onPressed: () {
                        _showDialog(
                          CupertinoPicker(
                            magnification: 1.22,
                            squeeze: 1.2,
                            useMagnifier: true,
                            itemExtent: 32.0,
                            scrollController:
                                FixedExtentScrollController(initialItem: 0),
                            onSelectedItemChanged: (int index) {
                              // Handle weight selection
                              setState(() {
                                _selectedWeight =
                                    index + 30; // Weight from 30 to 500 kg
                                // Save the selected weight
                                SharedPreferences.getInstance().then((prefs) {
                                  prefs.setInt(
                                      'selectedWeight', _selectedWeight);
                                });
                              });
                            },
                            children: List<Widget>.generate(
                                471,
                                (int index) => Center(
                                      child: Text("${index + 30} kg",
                                          style: GoogleFonts.exo2(
                                            fontSize: 16,
                                          )),
                                    )),
                          ),
                        );
                      },
                      child: Text("$_selectedWeight kg",
                          style: GoogleFonts.exo2(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ],
                ),
              ),
              Divider(indent: 8.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Age: ",
                        style: GoogleFonts.exo2(
                          fontSize: 16,
                        )),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black,
                      ),
                      onPressed: () {
                        _showDialog(
                          CupertinoPicker(
                            magnification: 1.22,
                            squeeze: 1.2,
                            useMagnifier: true,
                            itemExtent: 32.0,
                            scrollController:
                                FixedExtentScrollController(initialItem: 0),
                            onSelectedItemChanged: (int index) {
                              setState(() {
                                _selectedAge = index + 10; // Age from 10 to 100
                                // Save the selected age
                                SharedPreferences.getInstance().then((prefs) {
                                  prefs.setInt('selectedAge', _selectedAge);
                                });
                              });
                            },
                            children: List<Widget>.generate(
                                91,
                                (int index) => Center(
                                      child: Text("${index + 10} years",
                                          style: GoogleFonts.exo2(
                                            fontSize: 16,
                                          )),
                                    )),
                          ),
                        );
                      },
                      child: Text("$_selectedAge years",
                          style: GoogleFonts.exo2(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: Image.asset(
                    "assets/heart_outline.png",
                    height: 200,
                  ),
                ),
              ),
            ],
          ),
        )));
  }
}
