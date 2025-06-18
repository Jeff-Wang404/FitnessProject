import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Center(
            child: Column(
          children: [
            SizedBox(
              height: 20,
              child: Row(
                children: [
                  Text("Height: "),
                  // TextField(
                  //   decoration: InputDecoration(
                  //     border: OutlineInputBorder(),
                  //     hintText: 'Enter your height in cm',
                  //   ),
                  // )
                ],
              ),
            ),
            SizedBox(
              height: 20,
              child: Row(
                children: [
                  Text("Weight: "),
                  // TextField(
                  //   decoration: InputDecoration(
                  //     border: OutlineInputBorder(),
                  //     hintText: 'Enter your weight in kg',
                  //   ),
                  // )
                ],
              ),
            ),
            SizedBox(
              height: 20,
              child: Row(
                children: [
                  Text("Age: "),
                  // TextField(
                  //   decoration: InputDecoration(
                  //     border: OutlineInputBorder(),
                  //     hintText: 'Enter your age in years',
                  //   ),
                  // )
                ],
              ),
            ),
          ],
        )));
  }
}
