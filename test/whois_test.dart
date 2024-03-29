import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:whoisit/whois.dart';

void main() {
  group('Whois', () {
    const badHandles = [
      '?', // Illegal characters
      'a', // Missing dot separator
    ];
    const badDomains = [
      '.', // Empty top-level extension
      '.-', // Incorrect top-level extension
      '...', // Empty second-level extension
      'a.b.c.d', // Non-existent third-level extension
    ];
    const goodDomains = [
      'google.com', // Good top-level extension
      'jobs.ac.uk', // Good second-level extension
      'pub.dartlang.org', // Bad query but good extension
    ];
    const server = 'whois-servers.net';

    test('fails to parse bad handles', () {
      for (final handle in badHandles) {
        // Format exceptions should be thrown by the domain parser
        expect(Whois.query(handle), throwsFormatException);
      }
    });

    test('fails to query bad domains', () {
      for (final domain in badDomains) {
        // Socket exceptions should be thrown upon resolving the WHOIS server
        expect(Whois.query(domain), throwsA(isInstanceOf<SocketException>()));
      }
    });

    test('queries good domains', () async {
      for (final domain in goodDomains) {
        // Responses should be non-empty
        final whois = await Whois.query(domain);
        expect(whois, isInstanceOf<Whois>());
        expect(whois.response.length, greaterThan(0));
      }
    });

    test('domain matches handle', () async {
      for (final domain in goodDomains) {
        final whois = await Whois.query(domain);
        expect(whois.domain, equals(domain));
      }
    });

    test('server matches reference', () async {
      for (final domain in goodDomains) {
        final whois = await Whois.query(domain);
        expect(whois.server, endsWith('.$server'));
      }
    });
  });
}
