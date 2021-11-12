import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Returns a function that forces component to re-build when called.
VoidCallback useUpdate() {
  final reducer = useReducer(
    (state, action) => () {},
    initialState: null,
    initialAction: null,
  );
  return () => reducer.dispatch(null);
}
