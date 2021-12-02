import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_test/flutter_test.dart';

Future<HookTestingAction<T>> buildHook<T>(T Function() hook) async {
  late T result;

  Widget builder() {
    return HookBuilder(builder: (context) {
      result = hook();
      return Container();
    });
  }

  Future<void> rebuild() => attachAndPump(builder());
  await rebuild();

  Future<void> unmount() => attachAndPump(Container());

  return HookTestingAction<T>(result, rebuild, unmount);
}

Future<void> act(void Function() fn) {
  return TestAsyncUtils.guard<void>(() {
    final binding = TestWidgetsFlutterBinding.ensureInitialized()
        as TestWidgetsFlutterBinding;
    fn();
    binding.scheduleFrame();
    return binding.pump();
  });
}

class HookTestingAction<T> {
  const HookTestingAction(this.current, this.rebuild, this.unmount);

  /// The current value of the result will reflect the latest of whatever is
  /// returned from the callback passed to buildHook.
  final T current;

  /// A function to rebuild the test component, causing any hooks to be
  /// recalculated.
  final Future<void> Function() rebuild;

  /// A function to unmount the test component. This is commonly used to trigger
  /// cleanup effects for useEffect hooks.
  final Future<void> Function() unmount;
}

Future<void> attachAndPump(Widget widget) async {
  final binding = TestWidgetsFlutterBinding.ensureInitialized()
      as TestWidgetsFlutterBinding;
  return TestAsyncUtils.guard<void>(() {
    binding.attachRootWidget(widget);
    binding.scheduleFrame();
    return binding.pump();
  });
}
