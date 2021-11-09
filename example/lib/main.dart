import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_use/flutter_use.dart';
import 'package:flutter_use_battery/use_battery.dart';
import 'package:flutter_use_geolocation/use_geolocation.dart';
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
    final geolocation = useGeolocation();

    final count = useState(0);
    final delay = useState(const Duration(milliseconds: 300));
    final isRunning = useState(true);
    useInterval(
      () => count.value++,
      delay: isRunning.value ? delay.value : null,
    );

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("-- Battery --"),
            Text("fetched: ${battery.fetched}"),
            Text("batteryState: ${battery.batteryState}"),
            Text("level: ${battery.batteryLevel}"),
            Text("isInBatterySaveMode: ${battery.isInBatterySaveMode}"),
            const SizedBox(height: 32),
            const Text("-- Network --"),
            Text("fetched: ${networkState.fetched}"),
            Text("connectivityResult: ${networkState.connectivity}"),
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
            const Text("-- Geolocation --"),
            Text("permission checked: ${geolocation.fetched}"),
            Text("location: ${geolocation.position}"),
            Text("count: ${count.value}"),
            ElevatedButton(
              onPressed: () async {
                isRunning.value = !isRunning.value;
              },
              child: const Text("Button"),
            )
          ],
        ),
      ),
    );
  }
}
