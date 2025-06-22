import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_use/flutter_use.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:flutter_hooks_test/flutter_hooks_test.dart';

void main() {
  group('useScroll', () {
    testWidgets('should return initial scroll state', (tester) async {
      final result = await buildHook((_) => useScroll());

      expect(result.current.x, 0);
      expect(result.current.y, 0);
      expect(result.current.controller, isA<ScrollController>());
    });

    testWidgets('should provide stable controller across rebuilds',
        (tester) async {
      final result = await buildHook((_) => useScroll());

      final firstController = result.current.controller;

      await result.rebuild();

      expect(identical(firstController, result.current.controller), isTrue);
    });

    testWidgets('should track scroll position', (tester) async {
      late ScrollState scrollState;

      await tester.pumpWidget(
        MaterialApp(
          home: HookBuilder(
            builder: (context) {
              scrollState = useScroll();

              return SizedBox(
                height: 200,
                child: ListView.builder(
                  controller: scrollState.controller,
                  itemCount: 100,
                  itemBuilder: (context, index) => SizedBox(
                    height: 50,
                    child: Text('Item $index'),
                  ),
                ),
              );
            },
          ),
        ),
      );

      // Initially at top
      expect(scrollState.y, 0);

      // Simulate scrolling down using drag gesture
      await tester.drag(find.byType(ListView), const Offset(0, -100));
      await tester.pump();

      expect(scrollState.y, greaterThan(0));
      expect(scrollState.x, 0); // Always 0 for vertical scroll

      // Drag further down
      await tester.drag(find.byType(ListView), const Offset(0, -150));
      await tester.pump();

      expect(scrollState.y, greaterThan(100));
    });

    testWidgets('should handle scroll controller disposal', (tester) async {
      final result = await buildHook((_) => useScroll());

      final controller = result.current.controller;
      expect(controller.hasClients, false);

      // Unmount should dispose the controller
      await result.unmount();

      // Controller should be disposed (this might throw if disposed)
      expect(() => controller.offset, throwsA(isA<AssertionError>()));
    });

    testWidgets('should update state when scroll position changes',
        (tester) async {
      late ScrollState scrollState;

      await tester.pumpWidget(
        MaterialApp(
          home: HookBuilder(
            builder: (context) {
              scrollState = useScroll();

              return SizedBox(
                height: 200,
                child: ListView.builder(
                  controller: scrollState.controller,
                  itemCount: 100,
                  itemBuilder: (context, index) => SizedBox(
                    height: 50,
                    child: Text('Item $index'),
                  ),
                ),
              );
            },
          ),
        ),
      );

      expect(scrollState.y, 0);

      // Simulate scrolling by dragging
      await tester.drag(find.byType(ListView), const Offset(0, -150));
      await tester.pump();

      expect(scrollState.y, greaterThan(100));
    });
  });
}
