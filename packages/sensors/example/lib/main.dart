import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_use_sensors/use_sensors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class SampleError extends Error {
  SampleError(this.message);
  final String message;
}

class UseError extends Error {}

class SampleException implements Exception {}

class UseException implements Exception {}

class MyHomePage extends HookWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint("build");

    final accelerometerState = useAccelerometer();
    final userAccelerometerState = useUserAccelerometer();
    final gyroscopeState = useGyroscope();
    final magnetometerState = useMagnetometer();

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("-- Sensors --"),
              Text("accelerometerState fetched: ${accelerometerState.fetched}"),
              Text("accelerometerState: ${accelerometerState.accelerometer}"),
              Text(
                  "userAccelerometerState fetched: ${userAccelerometerState.fetched}"),
              Text(
                  "userAccelerometerState: ${userAccelerometerState.userAccelerometer}"),
              Text("gyroscope fetched: ${gyroscopeState.fetched}"),
              Text("gyroscope: ${gyroscopeState.gyroscope}"),
              Text("magnetometer fetched: ${magnetometerState.fetched}"),
              Text("magnetometer: ${magnetometerState.magnetometer}"),
            ],
          ),
        ),
      ),
    );
  }
}
