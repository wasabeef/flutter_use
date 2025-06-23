import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_test/flutter_test.dart';

// ignore: library_private_types_in_public_api
Future<_HookTestingAction<T, P>> buildHook<T, P>(
  T Function(P? props) hook, {
  P? initialProps,
  Widget Function(Widget child)? wrapper,
}) async {
  late T result;

  Widget builder([P? props]) => HookBuilder(
        builder: (context) {
          result = hook(props);
          return Container();
        },
      );

  Widget wrappedBuilder([P? props]) =>
      wrapper == null ? builder(props) : wrapper(builder(props));

  await _build(wrappedBuilder(initialProps));

  Future<void> rebuild([P? props]) => _build(wrappedBuilder(props));

  Future<void> unmount() => _build(Container());

  return _HookTestingAction<T, P>(() => result, rebuild, unmount);
}

Future<void> act(void Function() fn) => TestAsyncUtils.guard<void>(() {
      final binding = TestWidgetsFlutterBinding.ensureInitialized();
      fn();
      binding.scheduleFrame();
      return binding.pump();
    });

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
  final binding = TestWidgetsFlutterBinding.ensureInitialized();
  return TestAsyncUtils.guard<void>(() {
    binding.attachRootWidget(binding.wrapWithDefaultView(widget));
    binding.scheduleFrame();
    return binding.pump();
  });
}
