import 'package:test/test.dart';
import 'package:whoisit/history.dart';

void main() {
  group('History', () {
    var history, queries = <String>[
      'google.com',
      'jobs.ac.uk',
      'pub.dartlang.org',
    ];

    setUp(() {
      history = History();
    });

    test('preserves insertion order', () {
      for(var query in queries) {
        history.add(query);
      }

      // The history list should match the query list
      expect(history.toList(), equals(queries));
    });
    test('correctly reorders duplicates', () {
      for(var query in queries) {
        history.add(query);
      }

      // Reinsert the first query into the history
      var duplicate = queries[0];
      history.add(duplicate);

      // Ensure the duplicate appears at the end of the history
      expect(history.elementAt(history.length - 1), equals(duplicate));
    });
  });
}
