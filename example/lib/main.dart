import 'dart:async';

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
    // final battery = useBattery();
    // final networkState = useNetworkState();
    // final accelerometerState = useAccelerometer();
    // final userAccelerometerState = useUserAccelerometer();
    // final gyroscopeState = useGyroscope();
    // final magnetometerState = useMagnetometer();
    // final geolocation = useGeolocation();

    // final count = useState(0);
    // final delay = useState(const Duration(milliseconds: 300));
    // final isRunning = useState(true);
    // useInterval(
    //   () => count.value++,
    //   delay: isRunning.value ? delay.value : null,
    // );

    // final update = useUpdate();

    // final timeoutFn = useTimeoutFn(() {
    //   debugPrint('useTimeoutFn timeout');
    // }, const Duration(seconds: 3));

    // final timeout = useTimeout(const Duration(seconds: 3));

    // useLifecycles(
    //   mount: () {
    //     debugPrint('useLifecycles mount');
    //   },
    //   unmount: () {
    //     debugPrint('useLifecycles unmount');
    //   },
    // );

    // // flutter_hooks v0.18.1
    // useOnAppLifecycleStateChange((prev, current) {
    //   debugPrint('useOnAppLifecycleStateChange: ${prev}, ${current}');
    //   debugPrint('${MediaQuery.of(context).orientation}');
    // });

    // final toggleState = useToggle(false);

    // final orientation = useOrientation();
    // useOrientationFn((orientation) {
    //   debugPrint('useOrientationFn: $orientation');
    // });

    // final errorState = useError();
    // if (errorState.value is SampleError) {
    //   final error = errorState.value as SampleError;
    //   debugPrint('SampleError: ${error.message}');
    // } else if (errorState.value is UseError) {
    //   debugPrint('UseError: ${errorState.value}');
    // } else {
    //   debugPrint('Error: ${errorState.value}');
    // }
    // final exceptionState = useException();
    // if (exceptionState.value is SampleException) {
    //   debugPrint('SampleException: ${exceptionState.value}');
    // } else if (exceptionState.value is UseException) {
    //   debugPrint('UseException: ${exceptionState.value}');
    // } else {
    //   debugPrint('Exception: ${exceptionState.value}');
    // }

    // final futureRetry =
    //     useFutureRetry(Future.delayed(const Duration(seconds: 1), () {
    //   debugPrint('useFutureRetry');
    //   return 'Future.delayed:${DateTime.now()}';
    // }));

    // final inputState = useState('Typing stopped');
    // final inputValue = useState('');
    // final bounceValue = useState('');

    // useDebounce(() {
    //   inputState.value = 'Typing stopped';
    //   bounceValue.value = inputValue.value;
    // }, const Duration(seconds: 3));

    // useMount(() {
    //   debugPrint('MOUNTED');
    // });
    // useUnMount(() {
    //   debugPrint('UNMOUNTED');
    // });

    // final count = useState(0);
    // final latestCount = useLatest(count.value);
    // void handleClick() {
    //   Timer(const Duration(seconds: 2), () {
    //     debugPrint("Latest count value: ${latestCount.value}");
    //   });
    // }

    // final initialUser = {'name': 'Marshall'};
    // final defaultUser = {'name': 'Mathers'};

    // final user = useDefault(defaultUser, initialUser);

    // useLogger('MyHomePage);

    final mapState = useMap({'hello': 'there'});

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('${mapState.map}'),
              Wrap(
                spacing: 8,
                children: [
                  ElevatedButton(
                    onPressed: () => mapState.add(DateTime.now().toString(),
                        '${DateTime.now().microsecondsSinceEpoch}'),
                    child: const Text('Add'),
                  ),
                  ElevatedButton(
                    onPressed: () =>
                        mapState.addAll({'add': 'all', 'data': 'data'}),
                    child: const Text('Add all'),
                  ),
                  ElevatedButton(
                    onPressed: () =>
                        mapState.replace({'hello': 'new', 'data': 'data'}),
                    child: const Text('Replace'),
                  ),
                  ElevatedButton(
                    onPressed: () => mapState.remove('hello'),
                    child: const Text("Remove 'hello'"),
                  ),
                  ElevatedButton(
                    onPressed: () => mapState.reset(),
                    child: const Text('Reset'),
                  ),
                ],
              ),
              
              // const Text("-- Battery --"),
              // Text("fetched: ${battery.fetched}"),
              // Text("batteryState: ${battery.batteryState}"),
              // Text("level: ${battery.batteryLevel}"),
              // Text("isInBatterySaveMode: ${battery.isInBatterySaveMode}"),
              // const SizedBox(height: 32),
              // const Text("-- Network --"),
              // Text("fetched: ${networkState.fetched}"),
              // Text("connectivityResult: ${networkState.connectivity}"),
              // const SizedBox(height: 32),
              // const Text("-- Sensors --"),
              // Text("accelerometerState fetched: ${accelerometerState.fetched}"),
              // Text("accelerometerState: ${accelerometerState.accelerometer}"),
              // Text(
              //     "userAccelerometerState fetched: ${userAccelerometerState.fetched}"),
              // Text(
              //     "userAccelerometerState: ${userAccelerometerState.userAccelerometer}"),
              // Text("gyroscope fetched: ${gyroscopeState.fetched}"),
              // Text("gyroscope: ${gyroscopeState.gyroscope}"),
              // Text("magnetometer fetched: ${magnetometerState.fetched}"),
              // Text("magnetometer: ${magnetometerState.magnetometer}"),
              // const SizedBox(height: 32),
              // const Text("-- Geolocation --"),
              // Text("permission checked: ${geolocation.fetched}"),
              // Text("location: ${geolocation.position}"),
              // const SizedBox(height: 32),
              // const Text("-- Interval --"),
              // Text("count: ${count.value}"),
              // ElevatedButton(
              //   onPressed: () => isRunning.value = !isRunning.value,
              //   child: const Text("Stop Interval"),
              // ),
              // const SizedBox(height: 32),
              // const Text("-- Force Update --"),
              // ElevatedButton(
              //   onPressed: () => update(),
              //   child: const Text("Force Update"),
              // ),
              // const SizedBox(height: 32),
              // const Text("-- Timeout --"),
              // Text("timeoutFn: ${timeoutFn.isReady()}"),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     ElevatedButton(
              //       onPressed: () {
              //         // timeoutFn.cancel();
              //         timeout.cancel();
              //       },
              //       child: const Text("Cancel"),
              //     ),
              //     ElevatedButton(
              //       onPressed: () {
              //         // timeoutFn.reset();
              //         timeout.reset();
              //       },
              //       child: const Text("Reset"),
              //     ),
              //   ],
              // ),
              // const SizedBox(height: 32),
              // const Text("-- Toggle --"),
              // Text("${toggleState.value}"),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     ElevatedButton(
              //       onPressed: () {
              //         toggleState.toggle();
              //       },
              //       child: const Text('toggle'),
              //     ),
              //     ElevatedButton(
              //       onPressed: () {
              //         toggleState.value = true;
              //       },
              //       child: const Text('true'),
              //     ),
              //     ElevatedButton(
              //       onPressed: () {
              //         toggleState.value = false;
              //       },
              //       child: const Text('false'),
              //     ),
              //   ],
              // ),
              // const SizedBox(height: 32),
              // const Text("-- Orientation --"),
              // Text("${orientation}"),
              // const SizedBox(height: 32),
              // const Text("-- Error --"),
              // ElevatedButton(
              //   onPressed: () {
              //     errorState.dispatch(SampleError('This is SampleError'));
              //   },
              //   child: const Text('Dispatch SampleError'),
              // ),
              // ElevatedButton(
              //   onPressed: () {
              //     errorState.dispatch(UseError());
              //   },
              //   child: const Text('Dispatch UseError'),
              // ),
              // ElevatedButton(
              //   onPressed: () {
              //     exceptionState.dispatch(SampleException());
              //   },
              //   child: const Text('Dispatch SampleException'),
              // ),
              // const SizedBox(height: 32),
              // const Text("-- FutureRetry --"),
              // futureRetry.snapshot.connectionState == ConnectionState.done
              //     ? Text('Value: ${futureRetry.snapshot.data}')
              //     : const Text('Loading...'),
              // ElevatedButton(
              //   onPressed: () {
              //     futureRetry.retry();
              //   },
              //   child: const Text('Retry'),
              // ),
              // const SizedBox(height: 32),
              // const Text("-- Debounce --"),
              // Text("State: ${inputState.value}"),
              // Text("BounceValue: ${bounceValue.value}"),
              // TextFormField(
              //   onChanged: (text) {
              //     inputState.value = 'Waiting for typing to stop...';
              //     inputValue.value = text;
              //   },
              // ),
              // const SizedBox(height: 32),
              // const Text("-- Latest --"),
              // Text('You clicked ${count.value} times'),
              // ElevatedButton(
              //   onPressed: () {
              //     count.value++;
              //   },
              //   child: const Text('Click me'),
              // ),
              // ElevatedButton(
              //   onPressed: () {
              //     handleClick();
              //   },
              //   child: const Text('Start timer'),
              // ),
              // const SizedBox(height: 32),
              // const Text("-- Default --"),
              // Text('User: ${user.value['name']}'),
              // TextFormField(
              //   onChanged: (text) {
              //     user.value = {'name': text};
              //   },
              // ),
              // ElevatedButton(
              //   onPressed: () {
              //     user.value = null;
              //   },
              //   child: const Text('set to null'),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
