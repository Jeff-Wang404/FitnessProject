import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitness_project/services/data.dart';

/// Represents a single workout record
class WorkoutEntry {
  final DateTime date;
  final String name;
  final int reps;
  final int sets;
  final String category;

  WorkoutEntry({
    required this.date,
    required this.name,
    required this.reps,
    required this.sets,
    required this.category,
  });

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'name': name,
        'reps': reps,
        'sets': sets,
        'category': category,
      };

  factory WorkoutEntry.fromJson(Map<String, dynamic> json) => WorkoutEntry(
        date: DateTime.parse(json['date']),
        name: json['name'],
        reps: json['reps'],
        sets: json['sets'],
        category: json['category'],
      );
}

/// Service to manage soreness data & calculations
class PhysioService {
  static const _prefsKey = 'physio_soreness_history';

  late SharedPreferences _prefs;

  /// History map: bodyPart -> list of last-7-days soreness factors
  Map<String, List<double>> sorenessHistory = {};

  /// Recommended weekly movements per body part (target for 0.0→1.0)
  final Map<String, int> recommendedMovements = {
    'chest': 150,
    'abs': 200,
    'shoulders': 120,
    'biceps': 125,
    'forearms': 100,
    'thighs': 180,
    'shins': 80,
  };

  PhysioService();

  /// Initialize service and load stored history (7-day lists)
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final raw = _prefs.getString(_prefsKey);
    if (raw != null) {
      final Map<String, dynamic> decoded = json.decode(raw);
      sorenessHistory = decoded.map((part, list) {
        final arr = (list as List<dynamic>).map((e) => e as double).toList();
        return MapEntry(part, arr);
      });
    } else {
      // initialize empty lists
      for (var part in recommendedMovements.keys) {
        sorenessHistory[part] = List<double>.generate(7, (_) => 0.0);
      }
    }
  }

  Future<void> saveWorkout(
    DateTime date,
    String name,
    int reps,
    int sets,
    String category,
  ) async {
    final entry = WorkoutEntry(
      date: date,
      name: name,
      reps: reps,
      sets: sets,
      category: category,
    );
    // Store in shared preferences
    final encoded = json.encode(entry.toJson());
    await _prefs.setString('workout_${date.toIso8601String()}',
        encoded); // TODO determine better naming scheme
  }

  Future<List<WorkoutEntry>> loadWorkouts() async {
    final keys = _prefs.getKeys().where((k) => k.startsWith('workout_'));
    final entries = <WorkoutEntry>[];
    for (var key in keys) {
      final raw = _prefs.getString(key);
      if (raw != null) {
        final entry = WorkoutEntry.fromJson(json.decode(raw));
        entries.add(entry);
      }
    }
    return entries; // return list of WorkoutEntry
  }

  /// Persist current soreness history to shared preferences
  Future<void> saveHistory() async {
    final encoded = json.encode(sorenessHistory);
    await _prefs.setString(_prefsKey, encoded);
  }

  Future<Map<String, List<double>>> loadHistory() async {
    final raw = _prefs.getString(_prefsKey);
    if (raw != null) {
      final decoded = json.decode(raw) as Map<String, dynamic>;
      return decoded.map((part, list) {
        final arr = (list as List<dynamic>).map((e) => e as double).toList();
        return MapEntry(part, arr);
      });
    }
    return {}; // return empty map if no history
  }

  /// Relevancy weight: peaks around 1-2 days ago (24-72h)
  double relevancyFactor(int daysAgo) {
    final x = daysAgo.toDouble();
    return (0.0158025 * x * x * x) - (0.2390123 * x * x) + (0.8987654 * x);
  }

  /// Calculate per-bodyPart soreness factors (0.0–1.0) from workout entries
  /// - Applies exercise impact distribution and relevancy weighting
  /// - Uses `recommendedMovements` to normalize
  Map<String, double> calculateSorenessFactors(
    List<WorkoutEntry> entries,
    Map<String, Map<String, double>> impactMaps,
  ) {
    final now = DateTime.now();
    // accumulate weighted movements per part
    final accum = <String, double>{};
    for (var part in recommendedMovements.keys) {
      accum[part] = 0.0;
    }

    for (var entry in entries) {
      final daysAgo = now.difference(entry.date).inDays;
      if (daysAgo < 0 || daysAgo >= 7) continue; // ignore >7 days

      final weight = relevancyFactor(daysAgo);
      final movement = entry.sets * entry.reps;

      final characteristic = Data().exerciseCharacteristics[entry.name];
      if (characteristic == null) continue; // skip unknown exercises

      accum['chest'] =
          accum['chest']! + movement * characteristic.chestImpact * weight;
      accum['abs'] =
          accum['abs']! + movement * characteristic.absImpact * weight;
      accum['shoulders'] = accum['shoulders']! +
          movement * characteristic.shouldersImpact * weight;
      accum['biceps'] =
          accum['biceps']! + movement * characteristic.bicepsImpact * weight;
      accum['forearms'] = accum['forearms']! +
          movement * characteristic.forearmsImpact * weight;
      accum['thighs'] =
          accum['thighs']! + movement * characteristic.thighsImpact * weight;
      accum['shins'] =
          accum['shins']! + movement * characteristic.shinsImpact * weight;
    }

    // normalize to [0.0, 1.0]
    final factors = <String, double>{};
    for (var part in accum.keys) {
      final target = recommendedMovements[part]!.toDouble();
      final raw = accum[part]! / target;
      factors[part] = raw.clamp(0.0, 1.0);
    }
    return factors;
  }

  /// Update history arrays with new daily factor and rotate lists
  void rollAndStoreDailyFactors(Map<String, double> todaysFactors) {
    for (var part in sorenessHistory.keys) {
      List<double> history = sorenessHistory[part]!;
      // drop oldest (index 6) and insert today's at front
      history.removeLast();
      history.insert(0, todaysFactors[part] ?? 0.0);
      sorenessHistory[part] = history;
    }
  }

  /// Map factor→color string
  String colorForFactor(double factor) {
    if (factor < 0.34) return 'blue';
    if (factor < 0.67) return 'green';
    return 'red';
  }

  /// Public helper to load, calculate, update history & save
  Future<Map<String, String>> processWorkouts(
    List<WorkoutEntry> entries,
    Map<String, Map<String, double>> impactMaps,
  ) async {
    await init();
    final factors = calculateSorenessFactors(entries, impactMaps);
    // print("Calculated soreness factors: $factors");
    rollAndStoreDailyFactors(factors);
    await saveHistory();

    // return color mapping
    final colors = <String, String>{};
    for (var part in factors.keys) {
      colors['${part}_color'] = colorForFactor(factors[part]!);
      colors['${part}_soreness'] = factors[part]!.toStringAsFixed(2);
    }
    print("Color mapping: $colors");
    return colors;
  }

  double getBMI(String sex, int height, int weight, int age) {
    double bmi = weight / ((height / 100) * (height / 100));

    // Adjust based on sex
    final sexFactor = sex.toLowerCase() == 'female' ? 0.9 : 1.0;

    double ageFactor;

    if (age < 18) {
      ageFactor = 0.8;
    } else if (age > 65) {
      ageFactor = 1.2;
    } else {
      ageFactor = 1.0; // Default factor for ages 18-65
    }

    return (bmi * sexFactor * ageFactor).roundToDouble();
  }

  /// Recommend how many sets & reps to perform for the next workout.
  ///
  /// [exercise]  – must match a key in Data().exerciseCharacteristics
  /// [soreness]  – 0.0 (fresh) .. 1.0 (very sore) from PhysioService
  /// [bmi]       – numerical BMI (e.g. 27.4)
  ///
  /// Returns: {'sets': <int>, 'reps': <int>}
  Map<String, int> recommendSetsAndReps({
    required String exercise,
    required double soreness,
    required double bmi,
  }) {
    final data = Data(); // singleton
    final char = data.exerciseCharacteristics[exercise];
    if (char == null) {
      throw ArgumentError('Unknown exercise: $exercise');
    }

    // --- 1. Base prescription from exercise intensity ---
    int sets, reps;
    final int intensity = char.intensity; // 6–17 in your dataset

    if (intensity <= 8) {
      sets = 4;
      reps = 15;
    } // technique / metabolic
    else if (intensity <= 12) {
      sets = 4;
      reps = 12;
    } // hypertrophy‑endurance
    else if (intensity <= 15) {
      sets = 4;
      reps = 10;
    } // classic hypertrophy
    else {
      sets = 5;
      reps = 8;
    } // strength‑bias

    // --- 2. Adjust for BMI category ---
    if (bmi >= 30) {
      // Obese
      reps += 3; // extra calorie expenditure
    } else if (bmi >= 25) {
      // Over‑weight
      reps += 1;
    } else if (bmi < 18.5) {
      // Under‑weight
      reps = (reps - 2).clamp(5, 30);
      sets += 1;
    }

    // --- 3. Modify for current soreness ---
    if (soreness >= 0.67) {
      // red – very sore
      sets = (sets / 2).ceil();
      reps = (reps * 0.6).round();
    } else if (soreness >= 0.34) {
      // green – mildly sore
      sets = (sets * 0.8).ceil();
      reps = (reps * 0.9).round();
    }

    reps = reps.clamp(5, 30); // sanity bounds
    return {'sets': sets, 'reps': reps};
  }
}
