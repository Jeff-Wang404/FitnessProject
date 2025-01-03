import 'package:flutter/material.dart';

class Splashscreen extends StatelessWidget {
  const Splashscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Image.asset('assets/splash.jpg'),
        ),
        backgroundColor: const Color.fromARGB(255, 239, 239, 239));
  }
}
