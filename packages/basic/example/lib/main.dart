import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_use/flutter_use.dart';

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

    final toggleState = useToggle(false);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
                      toggleState.toggle(true);
                    },
                    child: const Text('true'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      toggleState.toggle(false);
                    },
                    child: const Text('false'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
