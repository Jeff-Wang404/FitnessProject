import 'package:shared_preferences/shared_preferences.dart';

/*
  User Data{
    "chest_color": "blue",
    "abs_color": "blue",
    "shoulders_color": "blue",
    "biceps_color": "blue",
    "forearms_color": "blue",
    "thighs_color": "blue",
    "shins_color": "blue",
    "lifetime_calories": 0,
    "session_data": [ // if the date is older than 7 days, add calories to lifetime_calories and remove
      {
        "date": "YYYY-MM-DD:HH:MM:SS",
        "name": "Bicep Curls",
        "reps": 10,
        "sets": 3,
        "category": "biceps",
        "calories": 100,
      },
      ...
    ]
  }

  Soreness Calculation:
  -peak soreness after a workout is typically around 48-72 hours
  -use the following formula to calculate the relevancy factor: 0.0158025x^3 - 0.2390123x^2 + 0.8987654x
  -for each body part, count up the total movements (reps * sets) and divide by the total recommended movements
    -total recommended movements is based on the body part
    -for each data point, multiply the relevancy factor so that movements contributed in the last 48-72 hours have the most weight for determining soreness
 
  Hypothetical: bicep curls to build muscle, we determine that 125 movements throughout the week is the target
  - assume these 3 data points
      - Point 1: {"date": "2023-10-01:12:00:00", "name": "Bicep Curls", "reps": 10, "sets": 3, "category": "biceps", "calories": 100}
      - Point 2: {"date": "2023-10-02:12:00:00", "name": "Bicep Curls", "reps": 10, "sets": 3, "category": "biceps", "calories": 100}
      - Point 3: {"date": "2023-10-03:12:00:00", "name": "Bicep Curls", "reps": 10, "sets": 3, "category": "biceps", "calories": 100}
  - If the current date is 2023-10-04:12:00:00, then the relevancy factor for each point is:
      - Point 1: 0.0158025(3)^3 - 0.2390123(3)^2 + 0.8987654(3) = 0.97185
      - Point 2: 0.0158025(2)^3 - 0.2390123(2)^2 + 0.8987654(2) = 0.9679
      - Point 3: 0.0158025(1)^3 - 0.2390123(1)^2 + 0.8987654(1) = 0.67556
  - The total movements for each point is:
      - Point 1: 10 * 3 = 30 * 0.97185 = 29.1555
      - Point 2: 10 * 3 = 30 * 0.9679 = 29.037
      - Point 3: 10 * 3 = 30 * 0.67556 = 20.2668
  - The total movements is 29.1555 + 29.037 + 20.2668 = 78.4593
  - The soreness factor is 78.4593 / 125 = 0.62767
  - Assuming blue is 0-33%, green is 34-66%, and red is 67-100%, the soreness factor is green
  - The soreness factor is green, so the biceps color is set to green
 */
class ExerciseCharacteristics {
  // Constructor for ExerciseCharacteristics
  ExerciseCharacteristics({
    required this.chestImpact,
    required this.absImpact,
    required this.shouldersImpact,
    required this.bicepsImpact,
    required this.forearmsImpact,
    required this.thighsImpact,
    required this.shinsImpact,
    required this.intensity,
  });

  double chestImpact = 0.0;
  double absImpact = 0.0;
  double shouldersImpact = 0.0;
  double bicepsImpact = 0.0;
  double forearmsImpact = 0.0;
  double thighsImpact = 0.0;
  double shinsImpact = 0.0;
  int intensity;
}

class Data {
  // initialize the data class
  static final Data _instance = Data._internal();
  factory Data() {
    return _instance;
  }
  Data._internal();

  List<String> pecExercises = [
    "Pec Deck",
    "Barbell Bench Press",
    "Dumbbell Presses",
    "Dumbbell Flies",
    "Cable Crossover",
    "Incline Bench Press"
  ];

  List<String> armExercises = [
    "Bicep Curls",
    "Preacher Curls",
    "Triceps Pushdowns",
    "Overhead Cable Triceps Extension",
    "Hammer Curls",
    "Close-Grip Bench Press"
  ];

  List<String> legsExercises = [
    "Romanian Deadlift",
    "Kettlebell Swings",
    "Barbell Front Squats",
    "Dumbell Walking Lunges",
    "Cable Squat to Overhead Press",
    "Landmine Reverse Lunge with Press"
  ];

  late Map<String, ExerciseCharacteristics> exerciseCharacteristics;

  ExerciseCharacteristics pecDeck = ExerciseCharacteristics(
    chestImpact: 0.9,
    absImpact: 0.0,
    shouldersImpact: 0.1,
    bicepsImpact: 0.0,
    forearmsImpact: 0.0,
    thighsImpact: 0.0,
    shinsImpact: 0.0,
    intensity: 15,
  );

  ExerciseCharacteristics barbellBenchPress = ExerciseCharacteristics(
    chestImpact: 0.7,
    absImpact: 0.0,
    shouldersImpact: 0.2,
    bicepsImpact: 0.1,
    forearmsImpact: 0.0,
    thighsImpact: 0.0,
    shinsImpact: 0.0,
    intensity: 10,
  );

  ExerciseCharacteristics dumbbellFlies = ExerciseCharacteristics(
    chestImpact: 0.6,
    absImpact: 0.0,
    shouldersImpact: 0.1,
    bicepsImpact: 0.2,
    forearmsImpact: 0.0,
    thighsImpact: 0.0,
    shinsImpact: 0.0,
    intensity: 15,
  );

  ExerciseCharacteristics dumbbellPresses = ExerciseCharacteristics(
    chestImpact: 0.7,
    absImpact: 0.0,
    shouldersImpact: 0.2,
    bicepsImpact: 0.1,
    forearmsImpact: 0.0,
    thighsImpact: 0.0,
    shinsImpact: 0.0,
    intensity: 10,
  );

  ExerciseCharacteristics cableCrossover = ExerciseCharacteristics(
    chestImpact: 0.8,
    absImpact: 0.0,
    shouldersImpact: 0.0,
    bicepsImpact: 0.2,
    forearmsImpact: 0.0,
    thighsImpact: 0.0,
    shinsImpact: 0.0,
    intensity: 15,
  );

  ExerciseCharacteristics inclineBenchPress = ExerciseCharacteristics(
    chestImpact: 0.5,
    absImpact: 0.0,
    shouldersImpact: 0.3,
    bicepsImpact: 0.2,
    forearmsImpact: 0.0,
    thighsImpact: 0.0,
    shinsImpact: 0.0,
    intensity: 10,
  );

  ExerciseCharacteristics bicepCurls = ExerciseCharacteristics(
    chestImpact: 0.0,
    absImpact: 0.0,
    shouldersImpact: 0.0,
    bicepsImpact: 1.0,
    forearmsImpact: 0.0,
    thighsImpact: 0.0,
    shinsImpact: 0.0,
    intensity: 15,
  );

  ExerciseCharacteristics preacherCurls = ExerciseCharacteristics(
    chestImpact: 0.0,
    absImpact: 0.0,
    shouldersImpact: 0.0,
    bicepsImpact: 1.0,
    forearmsImpact: 0.0,
    thighsImpact: 0.0,
    shinsImpact: 0.0,
    intensity: 17,
  );

  ExerciseCharacteristics tricepsPushdowns = ExerciseCharacteristics(
    chestImpact: 0.0,
    absImpact: 0.0,
    shouldersImpact: 0.0,
    bicepsImpact: 1.0,
    forearmsImpact: 0.0,
    thighsImpact: 0.0,
    shinsImpact: 0.0,
    intensity: 10,
  );

  ExerciseCharacteristics overheadCableTricepsExtension =
      ExerciseCharacteristics(
    chestImpact: 0.0,
    absImpact: 0.0,
    shouldersImpact: 0.0,
    bicepsImpact: 1.0,
    forearmsImpact: 0.0,
    thighsImpact: 0.0,
    shinsImpact: 0.0,
    intensity: 10,
  );

  ExerciseCharacteristics hammerCurls = ExerciseCharacteristics(
    chestImpact: 0.0,
    absImpact: 0.0,
    shouldersImpact: 0.0,
    bicepsImpact: 0.5,
    forearmsImpact: 0.5,
    thighsImpact: 0.0,
    shinsImpact: 0.0,
    intensity: 15,
  );

  ExerciseCharacteristics closeGripBenchPress = ExerciseCharacteristics(
    chestImpact: 0.2,
    absImpact: 0.0,
    shouldersImpact: 0.0,
    bicepsImpact: 0.2,
    forearmsImpact: 0.0,
    thighsImpact: 0.0,
    shinsImpact: 0.0,
    intensity: 10,
  );

  ExerciseCharacteristics romanianDeadlift = ExerciseCharacteristics(
    chestImpact: 0.0,
    absImpact: 0.0,
    shouldersImpact: 0.0,
    bicepsImpact: 0.0,
    forearmsImpact: 0.0,
    thighsImpact: 0.8,
    shinsImpact: 0.2,
    intensity: 10,
  );

  ExerciseCharacteristics kettlebellSwings = ExerciseCharacteristics(
    chestImpact: 0.0,
    absImpact: 0.0,
    shouldersImpact: 0.1,
    bicepsImpact: 0.0,
    forearmsImpact: 0.0,
    thighsImpact: 0.9,
    shinsImpact: 0.0,
    intensity: 6,
  );

  ExerciseCharacteristics barbellFrontSquats = ExerciseCharacteristics(
    chestImpact: 0.0,
    absImpact: 0.0,
    shouldersImpact: 0.0,
    bicepsImpact: 0.0,
    forearmsImpact: 0.0,
    thighsImpact: 0.9,
    shinsImpact: 0.1,
    intensity: 15,
  );

  ExerciseCharacteristics dumbellWalkingLunges = ExerciseCharacteristics(
    chestImpact: 0.0,
    absImpact: 0.0,
    shouldersImpact: 0.0,
    bicepsImpact: 0.0,
    forearmsImpact: 0.0,
    thighsImpact: 0.8,
    shinsImpact: 0.2,
    intensity: 8,
  );

  ExerciseCharacteristics cableSquatToOverheadPress = ExerciseCharacteristics(
    chestImpact: 0.0,
    absImpact: 0.0,
    shouldersImpact: 0.2,
    bicepsImpact: 0.0,
    forearmsImpact: 0.0,
    thighsImpact: 0.8,
    shinsImpact: 0.0,
    intensity: 10,
  );

  ExerciseCharacteristics landmineReverseLungeWithPress =
      ExerciseCharacteristics(
    chestImpact: 0.0,
    absImpact: 0.0,
    shouldersImpact: 0.0,
    bicepsImpact: 0.0,
    forearmsImpact: 0.0,
    thighsImpact: 1.0,
    shinsImpact: 0.0,
    intensity: 12,
  );

  String currentRecommendedWorkouts = "";

  // shared preferences instance
  SharedPreferences? _prefs;
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    // initialize exercise characteristics map
    exerciseCharacteristics = {
      "Pec Deck": pecDeck,
      "Barbell Bench Press": barbellBenchPress,
      "Dumbbell Presses": dumbbellPresses,
      "Dumbbell Flies": dumbbellFlies,
      "Cable Crossover": cableCrossover,
      "Incline Bench Press": inclineBenchPress,
      "Bicep Curls": bicepCurls,
      "Preacher Curls": preacherCurls,
      "Triceps Pushdowns": tricepsPushdowns,
      "Overhead Cable Triceps Extension": overheadCableTricepsExtension,
      "Hammer Curls": hammerCurls,
      "Close-Grip Bench Press": closeGripBenchPress,
      "Romanian Deadlift": romanianDeadlift,
      "Kettlebell Swings": kettlebellSwings,
      "Barbell Front Squats": barbellFrontSquats,
      "Dumbell Walking Lunges": dumbellWalkingLunges,
      "Cable Squat to Overhead Press": cableSquatToOverheadPress,
      "Landmine Reverse Lunge with Press": landmineReverseLungeWithPress,
    };
  }

  // variables
  final Map<String, dynamic> _data = {};
  Map<String, dynamic> get data => _data;
  // set data
  void setData(String key, dynamic value) {
    _data[key] = value;
    _prefs?.setString(key, value.toString());
  }

  // load the data from shared preferences
  Future<void> loadData() async {
    _data.clear();
    if (_prefs != null) {
      for (String key in _prefs!.getKeys()) {
        _data[key] = _prefs!.get(key);
      }
    }
  }

  // write data to shared preferences
  Future<void> writeData() async {
    if (_prefs != null) {
      for (String key in _data.keys) {
        // determine the type of the value
        var value = _data[key];
        if (value is int) {
          await _prefs!.setInt(key, value);
        } else if (value is double) {
          await _prefs!.setDouble(key, value);
        } else if (value is bool) {
          await _prefs!.setBool(key, value);
        } else if (value is String) {
          await _prefs!.setString(key, value);
        } else {
          // if the value is not one of the above types, convert it to a string
          await _prefs!.setString(key, value.toString());
        }
      }
    }
  }

  // clear data
  Future<void> clearData() async {
    _data.clear();
    if (_prefs != null) {
      await _prefs!.clear();
    }
  }

  // remove a specific key
  Future<void> removeKey(String key) async {
    _data.remove(key);
    if (_prefs != null) {
      await _prefs!.remove(key);
    }
  }
}
