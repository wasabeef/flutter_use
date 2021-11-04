// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';

// import 'mock.dart';

// void main() {
//   testWidgets('Example', (tester) async {
//     final unrelated = MockWidgetBuild();
//     Widget builder() {
//       return HookBuilder(builder: (context) {
//         return GestureDetector(
//           onTap: () {},
//           key: Key("key"),
//         );
//       });
//     }

//     await tester.pumpWidget(builder());
//     await tester.tap(find.byKey(Key("key")));

//     // await tester.pumpWidget(Container());
//     // await tester.pumpWidget(builder());
//   });

//   testWidgets('useRef with null initial value', (tester) async {
//     late ObjectRef<String?> ref;

//     await tester.pumpWidget(
//       HookBuilder(builder: (context) {
//         ref = useRef(null);
//         return Container();
//       }),
//     );

//     expect(ref.value, null, reason: 'The ref value has the initial set value.');
//     ref.value = "ref22222";

//     late ObjectRef<String?> ref2;

//     await tester.pumpWidget(
//       HookBuilder(builder: (context) {
//         ref2 = useRef(null);
//         return Container();
//       }),
//     );

//     expect(ref2, ref, reason: 'The ref value remains the same after rebuild.');
//     expect(ref2.value, "ref22222",
//         reason: 'The ref value has the last assigned value.');
//   });
// }
