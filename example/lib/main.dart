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

    final update = useUpdate();

    final timeoutFn = useTimeoutFn(() {
      debugPrint('useTimeoutFn timeout');
    }, const Duration(seconds: 3));

    final timeout = useTimeout(const Duration(seconds: 3));

    useLifecycles(
      mount: () {
        debugPrint('useLifecycles mount');
      },
      unmount: () {
        debugPrint('useLifecycles unmount');
      },
    );

    // flutter_hooks v0.18.1
    useOnAppLifecycleStateChange((prev, current) {
      debugPrint('useOnAppLifecycleStateChange: ${prev}, ${current}');
      debugPrint('${MediaQuery.of(context).orientation}');
    });

    final toggleState = useToggle(false);

    final orientation = useOrientation();
    useOrientationFn((orientation) {
      debugPrint('useOrientationFn: $orientation');
    });

    final errorState = useError();
    if (errorState.value is SampleError) {
      final error = errorState.value as SampleError;
      debugPrint('SampleError: ${error.message}');
    } else if (errorState.value is UseError) {
      debugPrint('UseError: ${errorState.value}');
    } else {
      debugPrint('Error: ${errorState.value}');
    }
    final exceptionState = useException();
    if (exceptionState.value is SampleException) {
      debugPrint('SampleException: ${exceptionState.value}');
    } else if (exceptionState.value is UseException) {
      debugPrint('UseException: ${exceptionState.value}');
    } else {
      debugPrint('Error: ${exceptionState.value}');
    }

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Center(
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
              const SizedBox(height: 32),
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
              const SizedBox(height: 32),
              const Text("-- Geolocation --"),
              Text("permission checked: ${geolocation.fetched}"),
              Text("location: ${geolocation.position}"),
              const SizedBox(height: 32),
              const Text("-- Interval --"),
              Text("count: ${count.value}"),
              ElevatedButton(
                onPressed: () => isRunning.value = !isRunning.value,
                child: const Text("Stop Interval"),
              ),
              const SizedBox(height: 32),
              const Text("-- Force Update --"),
              ElevatedButton(
                onPressed: () => update(),
                child: const Text("Force Update"),
              ),
              const SizedBox(height: 32),
              const Text("-- Timeout --"),
              Text("timeoutFn: ${timeoutFn.isReady}"),
              Text("timeout: ${timeout.isReady}"),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      timeoutFn.cancel();
                      timeout.cancel();
                    },
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      timeoutFn.reset();
                      timeout.reset();
                    },
                    child: const Text("Reset"),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              const Text("-- Toggle --"),
              Text("${toggleState.value}"),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      toggleState.toggle();
                    },
                    child: const Text('toggle'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      toggleState.toggle(value: true);
                    },
                    child: const Text('true'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      toggleState.toggle(value: false);
                    },
                    child: const Text('false'),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              const Text("-- Orientation --"),
              Text("${orientation}"),
              const SizedBox(height: 32),
              const Text("-- Error --"),
              ElevatedButton(
                onPressed: () {
                  errorState.dispatch(SampleError('This is SampleError'));
                },
                child: const Text('Dispatch SampleError'),
              ),
              ElevatedButton(
                onPressed: () {
                  exceptionState.dispatch(SampleException());
                },
                child: const Text('Dispatch SampleException'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
