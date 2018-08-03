import 'dart:io';
import 'package:test/test.dart';
import 'package:whoisit/whois.dart';

void main() {
  group('Whois', () {
    var badHandles = <String>[
      '?', // Illegal characters
      'a', // Missing dot separator
    ];
    var badDomains = <String>[
      '.', // Empty top-level extension
      '.-', // Incorrect top-level extension
      '...', // Empty second-level extension
      'a.b.c.d', // Non-existent third-level extension
    ];
    var goodDomains = <String>[
      'google.com', // Good top-level extension
      'jobs.ac.uk', // Good second-level extension
      'pub.dartlang.org', // Bad query but good extension
    ];

    test('fails to parse bad handles', () {
      for(var handle in badHandles) {
        // Format exceptions should be thrown by the domain parser
        expect(Whois.query(handle), throwsFormatException);
      }
    });
    test('fails to query bad domains', () {
      for(var domain in badDomains) {
        // Socket exceptions should be thrown upon resolving the WHOIS server
        expect(Whois.query(domain), throwsA(isInstanceOf<SocketException>()));
      }
    });
    test('queries good domains', () async {
      for(var domain in goodDomains) {
        // Responses should be non-empty
        var whois = await Whois.query(domain);
        expect(whois, isInstanceOf<Whois>());
        expect(whois.response.length, greaterThan(0));
      }
    });
    test('domain matches handle', () async {
      for(var domain in goodDomains) {
        var whois = await Whois.query(domain);
        expect(whois.domain, equals(domain));
      }
    });
  });
}
