import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_use_battery/use_battery.dart';
import 'package:flutter_use_network_state/use_network_state.dart';
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

class MyHomePage extends HookWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final battery = useBattery();
    final networkState = useNetworkState();
    final accelerometerState = useAccelerometer();
    final userAccelerometerState = useUserAccelerometer();
    final gyroscopeState = useGyroscope();
    final magnetometerState = useMagnetometer();

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("-- Battery --"),
            Text("fetched: ${battery.value.fetched}"),
            Text("batteryState: ${battery.value.batteryState}"),
            Text("level: ${battery.value.batteryLevel}"),
            Text("isInBatterySaveMode: ${battery.value.isInBatterySaveMode}"),
            const SizedBox(height: 32),
            const Text("-- Network --"),
            Text("fetched: ${networkState.value.fetched}"),
            Text("connectivityResult: ${networkState.value.connectivity}"),
            const Text("-- Sensors --"),
            Text(
                "accelerometerState: ${accelerometerState.value.accelerometer}"),
            Text(
                "userAccelerometerState: ${userAccelerometerState.value.userAccelerometer}"),
            Text("gyroscope: ${gyroscopeState.value.gyroscope}"),
            Text("magnetometer: ${magnetometerState.value.magnetometer}"),
          ],
        ),
      ),
    );
  }
}
