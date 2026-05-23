import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app_test/counter_cubit_demo.dart';

void main() {
  group('CounterCubit', () {
    test('starts at 0, then emits 1 and 0', () {
      final cubit = CounterCubit();

      expect(cubit.state, 0);

      cubit.increment();
      expect(cubit.state, 1);

      cubit.decrement();
      expect(cubit.state, 0);

      cubit.close();
    });
  });

  group('CounterCubitDemoPage', () {
    testWidgets('updates UI when buttons call cubit methods', (tester) async {
      await tester.pumpWidget(const CounterCubitDemoPage());

      expect(find.byKey(const Key('counter_text')), findsOneWidget);
      expect(find.text('0'), findsOneWidget);

      await tester.tap(find.byKey(const Key('increment_button')));
      await tester.pump();

      expect(find.text('1'), findsOneWidget);

      await tester.tap(find.byKey(const Key('decrement_button')));
      await tester.pump();

      expect(find.text('0'), findsOneWidget);
    });
  });
}
