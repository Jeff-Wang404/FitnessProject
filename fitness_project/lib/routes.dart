import 'package:fitness_project/screens/splashscreen.dart';
import 'package:fitness_project/screens/homescreen.dart';
import 'package:fitness_project/screens/connectscreen.dart';
// import 'package:fitness_project/screens/detailedscreen.dart';
import 'package:fitness_project/screens/workoutscreen.dart';

var routes = {
  '/': (context) => Homescreen(),
  // '/home': (context) => Homescreen(),
  '/connect': (context) => ConnectScreen(),
  // '/detailed': (context) => DetailScreen(),
  '/workout': (context) => WorkoutScreen(),
};
