import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_health_connect/flutter_health_connect.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // List<HealthConnectDataType> types = [
  //   HealthConnectDataType.ActiveCaloriesBurned,
  //   HealthConnectDataType.BasalBodyTemperature,
  //   HealthConnectDataType.BasalMetabolicRate,
  //   HealthConnectDataType.BloodGlucose,
  //   HealthConnectDataType.BloodPressure,
  //   HealthConnectDataType.BodyFat,
  //   HealthConnectDataType.BodyTemperature,
  //   HealthConnectDataType.BodyWaterMass,
  //   HealthConnectDataType.BoneMass,
  //   HealthConnectDataType.CervicalMucus,
  //   HealthConnectDataType.CyclingPedalingCadence,
  //   HealthConnectDataType.Distance,
  //   HealthConnectDataType.ElevationGained,
  //   HealthConnectDataType.ExerciseSession,
  //   HealthConnectDataType.FloorsClimbed,
  //   HealthConnectDataType.HeartRate,
  //   HealthConnectDataType.HeartRateVariabilityRmssd,
  //   HealthConnectDataType.Height,
  //   HealthConnectDataType.Hydration,
  //   HealthConnectDataType.IntermenstrualBleeding,
  //   HealthConnectDataType.LeanBodyMass,
  //   HealthConnectDataType.MenstruationFlow,
  //   HealthConnectDataType.Nutrition,
  //   HealthConnectDataType.OvulationTest,
  //   HealthConnectDataType.OxygenSaturation,
  //   HealthConnectDataType.Power,
  //   HealthConnectDataType.RespiratoryRate,
  //   HealthConnectDataType.RestingHeartRate,
  //   HealthConnectDataType.SexualActivity,
  //   HealthConnectDataType.SleepSession,
  //   HealthConnectDataType.SleepStage,
  //   HealthConnectDataType.Speed,
  //   HealthConnectDataType.StepsCadence,
  //   HealthConnectDataType.Steps,
  //   HealthConnectDataType.TotalCaloriesBurned,
  //   HealthConnectDataType.Vo2Max,
  //   HealthConnectDataType.Weight,
  //   HealthConnectDataType.WheelchairPushes,
  // ];

  List<HealthConnectDataType> types = [
    HealthConnectDataType.Steps,
    HealthConnectDataType.BodyFat,
    HealthConnectDataType.Weight,
    HealthConnectDataType.ActiveCaloriesBurned,
    HealthConnectDataType.HeartRateVariabilityRmssd,
    HealthConnectDataType.RestingHeartRate,
    HealthConnectDataType.Distance,
    HealthConnectDataType.SleepSession,
    HealthConnectDataType.Nutrition,
  ];

  bool readOnly = true;
  String resultText = '';

  String token = "";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Health Connect'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ElevatedButton(
              onPressed: () async {
                var result = await HealthConnectFactory.isApiSupported();
                resultText = 'isApiSupported: $result';
                _updateResultText();
              },
              child: const Text('isApiSupported'),
            ),
            ElevatedButton(
              onPressed: () async {
                var result = await HealthConnectFactory.isAvailable();
                resultText = 'isAvailable: $result';
                _updateResultText();
              },
              child: const Text('Check installed'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await HealthConnectFactory.installHealthConnect();
                  resultText = 'Install activity started';
                } catch (e) {
                  resultText = e.toString();
                }
                _updateResultText();
              },
              child: const Text('Install Health Connect'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await HealthConnectFactory.openHealthConnectSettings();
                  resultText = 'Settings activity started';
                } catch (e) {
                  resultText = e.toString();
                }
                _updateResultText();
              },
              child: const Text('Open Health Connect Settings'),
            ),
            ElevatedButton(
              onPressed: () async {
                var result = await HealthConnectFactory.hasPermissions(
                  types,
                  readOnly: false,
                  // readOnly: readOnly,
                );
                resultText = 'hasPermissions: $result';
                _updateResultText();
              },
              child: const Text('Has Permissions'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  token = await HealthConnectFactory.getChangesToken(types);
                  resultText = 'token: $token';
                } catch (e) {
                  resultText = e.toString();
                }
                _updateResultText();
              },
              child: const Text('Get Changes Token'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  var result = await HealthConnectFactory.getChanges(token);
                  resultText = 'token: $result';
                } catch (e) {
                  resultText = e.toString();
                }
                _updateResultText();
              },
              child: const Text('Get Changes'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  var result = await HealthConnectFactory.requestPermissions(
                    types,
                    // readOnly: readOnly,
                  );
                  resultText = 'requestPermissions: $result';
                } catch (e) {
                  resultText = e.toString();
                }
                _updateResultText();
              },
              child: const Text('Request Permissions'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  // This will only apply after the app has been fully closed.
                  var result = await HealthConnectFactory.revokeAllPermissions();
                  resultText = 'revokeAllPermissions: $result';
                } catch (e) {
                  resultText = e.toString();
                }
                _updateResultText();
              },
              child: const Text('Revoke All Permissions'),
            ),
            ElevatedButton(
              onPressed: () async {
                var startTime = DateTime.now().subtract(const Duration(days: 30));
                var endTime = DateTime.now();
                try {
                  final requests = <Future>[];
                  Map<String, dynamic> typePoints = {};
                  for (var type in types) {
                    requests.add(HealthConnectFactory.getRecords(
                      type: type,
                      startTime: startTime,
                      endTime: endTime,
                    ).then((value) => typePoints.addAll({type.name: value})));
                  }
                  await Future.wait(requests);
                  resultText = '$typePoints';
                } catch (e, s) {
                  resultText = '$e:$s'.toString();
                }
                log(resultText);
                _updateResultText();
              },
              child: const Text('Get Record'),
            ),
            ElevatedButton(
              onPressed: () async {
                var startTime = DateTime.now().subtract(const Duration(days: 6));
                var endTime = DateTime.now().subtract(const Duration(days: 5));
                var endTime1 = DateTime.now();
                ActiveCaloriesBurnedRecord stepsRecord = ActiveCaloriesBurnedRecord(
                  startTime: startTime,
                  endTime: endTime,
                  energy: const Energy(12.23, EnergyUnit.calories),
                );
                RestingHeartRateRecord exerciseSessionRecord = RestingHeartRateRecord(
                  time: startTime,
                  beatsPerMinute: 77,
                );
                HeartRateVariabilityRmssdRecord hRecord = HeartRateVariabilityRmssdRecord(
                  time: startTime,
                  heartRateVariabilityMillis: 79,
                );
                WeightRecord wRecord = WeightRecord(
                  time: startTime,
                  weight: const Mass(172.3, MassUnit.pounds),
                );
                NutritionRecord nRecord = NutritionRecord(
                  startTime: startTime,
                  endTime: endTime,
                  energy: const Energy(11.21, EnergyUnit.calories),
                );
                BodyFatRecord bRecord = BodyFatRecord(
                  time: startTime,
                  percentage: const Percentage(33.7),
                );
                try {
                  final requests = <Future>[];
                  Map<String, dynamic> typePoints = {};
                  requests.add(HealthConnectFactory.writeData(
                    type: HealthConnectDataType.ActiveCaloriesBurned,
                    data: [stepsRecord],
                  ).then((value) => typePoints.addAll({HealthConnectDataType.Steps.name: stepsRecord})));

                  requests.add(HealthConnectFactory.writeData(
                    type: HealthConnectDataType.RestingHeartRate,
                    data: [exerciseSessionRecord],
                  ).then((value) => typePoints.addAll({HealthConnectDataType.ExerciseSession.name: exerciseSessionRecord})));
                  requests.add(HealthConnectFactory.writeData(
                    type: HealthConnectDataType.Nutrition,
                    data: [nRecord],
                  ).then((value) => typePoints.addAll({HealthConnectDataType.ExerciseSession.name: exerciseSessionRecord})));
                  requests.add(HealthConnectFactory.writeData(
                    type: HealthConnectDataType.Weight,
                    data: [wRecord],
                  ).then((value) => typePoints.addAll({HealthConnectDataType.ExerciseSession.name: exerciseSessionRecord})));
                  requests.add(HealthConnectFactory.writeData(
                    type: HealthConnectDataType.BodyFat,
                    data: [bRecord],
                  ).then((value) => typePoints.addAll({HealthConnectDataType.ExerciseSession.name: exerciseSessionRecord})));
                  requests.add(HealthConnectFactory.writeData(
                    type: HealthConnectDataType.HeartRateVariabilityRmssd,
                    data: [hRecord],
                  ).then((value) => typePoints.addAll({HealthConnectDataType.ExerciseSession.name: exerciseSessionRecord})));
                  await Future.wait(requests);
                  resultText = '$typePoints';
                } catch (e, s) {
                  resultText = '$e:$s'.toString();
                }
                _updateResultText();
              },
              child: const Text('Send Record'),
            ),
            ElevatedButton(
              onPressed: () async {
                var lastDate = DateTime.now();
                try {
                  DateTime startTime = DateTime(lastDate.year, lastDate.month, lastDate.day - 3);
                  var endTime = DateTime(lastDate.year, lastDate.month, lastDate.day - 1);
                  var result = await HealthConnectFactory.aggregate(
                    aggregationKeys: [
                      StepsRecord.aggregationKeyCountTotal,
                      WeightRecord.aggregationKeyWeightAvg,
                      ActiveCaloriesBurnedRecord.aggregationKeyActiveCaloriesTotal,
                      RestingHeartRateRecord.aggregationKeyBpmAvg,
                      DistanceRecord.aggregationKeyDistanceTotal,
                      // SleepSessionRecord.aggregationKeySleepDurationTotal,
                    ],
                    startTime: startTime,
                    endTime: endTime,
                  );
                  resultText = '$result';
                } catch (e, s) {
                  resultText = '$e:$s'.toString();
                }
                _updateResultText();
              },
              child: const Text('Get aggregated data'),
            ),
            ElevatedButton(
              onPressed: () async {
                var lastDate = DateTime.now();
                try {
                  DateTime startTime = DateTime(lastDate.year, lastDate.month, lastDate.day - 15);
                  var endTime = DateTime(lastDate.year, lastDate.month, lastDate.day);

                  // For aggregateGroupByPeriod
                  var resultPeriod = await HealthConnectFactory.aggregateGroupByPeriod(
                    aggregationKeys: [
                      StepsRecord.aggregationKeyCountTotal,
                      WeightRecord.aggregationKeyWeightAvg,
                      ActiveCaloriesBurnedRecord.aggregationKeyActiveCaloriesTotal,
                      RestingHeartRateRecord.aggregationKeyBpmAvg,
                      DistanceRecord.aggregationKeyDistanceTotal,
                      NutritionRecord.aggregationKeyEnergyTotal,
                      // SleepSessionRecord.aggregationKeySleepDurationTotal,
                    ],
                    startTime: startTime,
                    endTime: endTime,
                    daySlicerCount: 2,
                  );
                  log(resultPeriod.toString());
                  resultText = 'Duration result: \nPeriod result: $resultPeriod';
                } catch (e, s) {
                  resultText = '$e:$s'.toString();
                }
                // print(resultText);
                _updateResultText();
              },
              child: const Text('Get aggregated by period data'),
            ),
            Text(resultText),
          ],
        ),
      ),
    );
  }

  void _updateResultText() {
    setState(() {});
  }
}
