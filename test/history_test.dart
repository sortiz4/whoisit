import 'package:flutter_test/flutter_test.dart';
import 'package:whoisit/history.dart';

void main() {
  group('History', () {
    final history = History();

    // The history only cares about uniqueness
    const queries = <String>['a', 'b', 'c'];

    tearDown(() {
      // Tests depend on a fresh instance
      history.clear();
    });

    test('does not repeat', () {
      history.addAll(queries + queries);

      // The history list should match the query list
      expect(history.toList(), equals(queries));
    });

    test('preserves insertion order', () {
      history.addAll(queries);

      // The history list should match the query list
      expect(history.toList(), equals(queries));
    });

    test('correctly reorders duplicates', () {
      history.addAll(queries);

      // Reinsert the first query into the history
      final duplicate = queries[0];
      history.add(duplicate);

      // Ensure the duplicate appears at the end of the history
      expect(history.elementAt(history.length - 1), equals(duplicate));
    });
  });
}
