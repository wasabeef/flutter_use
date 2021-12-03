import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_test/flutter_test.dart';

Future<_HookTestingAction<T, P>> buildHook<T, P>(
  T Function(P? props) hook, {
  P? initialProps,
}) async {
  late T result;

  Widget builder([P? props]) {
    return HookBuilder(builder: (context) {
      result = hook(props);
      return Container();
    });
  }

  await _build(builder(initialProps));

  Future<void> rebuild([P? props]) => _build(builder(props));

  Future<void> unmount() => _build(Container());

  return _HookTestingAction<T, P>(() => result, rebuild, unmount);
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

class _HookTestingAction<T, P> {
  const _HookTestingAction(this._current, this.rebuild, this.unmount);

  /// The current value of the result will reflect the latest of whatever is
  /// returned from the callback passed to buildHook.
  final T Function() _current;
  T get current => _current();

  /// A function to rebuild the test component, causing any hooks to be
  /// recalculated.
  final Future<void> Function([P? props]) rebuild;

  /// A function to unmount the test component. This is commonly used to trigger
  /// cleanup effects for useEffect hooks.
  final Future<void> Function() unmount;
}

Future<void> _build(Widget widget) async {
  final binding = TestWidgetsFlutterBinding.ensureInitialized()
      as TestWidgetsFlutterBinding;
  return TestAsyncUtils.guard<void>(() {
    binding.attachRootWidget(widget);
    binding.scheduleFrame();
    return binding.pump();
  });
}
