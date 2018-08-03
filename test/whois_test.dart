import 'dart:io';
import 'package:test/test.dart';
import 'package:whoisit/whois.dart';

void main() {
  group('Whois', () {
    test('fails to parse bad handles', () {
      var handles = <String>[
        '?', // Illegal characters
        'a', // Missing dot separator
      ];
      for(var handle in handles) {
        expect(Whois.query(handle), throwsFormatException);
      }
    });
    test('fails to query bad domains', () {
      var handles = <String>[
        '.', // Empty top-level extension
        '.-', // Incorrect top-level extension
        '...', // Empty second-level extension
        'a.b.c.d', // Non-existent third-level extension
      ];
      for(var handle in handles) {
        expect(Whois.query(handle), throwsA(isInstanceOf<SocketException>()));
      }
    });
    test('successfully queries good domains', () async {
      var handles = <String>[
        'google.com', // Good top-level extension
        'jobs.ac.uk', // Good second-level extension
        'pub.dartlang.org', // Bad query but good extension
      ];
      for(var handle in handles) {
        var whois = await Whois.query(handle);
        expect(whois, isInstanceOf<Whois>());
        expect(whois.response.length, greaterThan(0));
      }
    });
    test('domain matches handle', () async {
      var handles = <String>[
        'google.com', // Top-level domain
        'jobs.ac.uk', // Second-level domain
        'pub.dartlang.org', // Third-level domain
      ];
      for(var handle in handles) {
        var whois = await Whois.query(handle);
        expect(whois.domain, equals(handle));
      }
    });
  });
}
