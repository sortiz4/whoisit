import 'dart:async';
import 'dart:convert';
import 'dart:io';

/// A simple WHOIS client supporting most (if not all) domain queries.
class Whois {
  static final _surrounding = RegExp(r'^[\r\n]+|[\r\n]+$');
  static final _trailing = RegExp(r'[\t ]+(?=[\r\n])');
  static final _tabs = RegExp(r'\t');
  final String domain, server, response;

  Whois._internal(this.domain, this.server, this.response);

  /// Tries to connect using the full domain extension. Failing that, the
  /// extension will iteratively generalize until the connection succeeds or
  /// all possibilities are exhausted.
  static Future<Socket> _connect(_Domain domain) async {
    final extension = domain.extension;

    try {
      return await _resolve(extension);
    } on SocketException catch (exc) {
      final parts = extension.split('.');

      for (final i in Iterable.generate(parts.length)) {
        if (i > 0) {
          try {
            return await _resolve(parts.sublist(i).join('.'));
          } on SocketException {
          }
        }
      }

      throw exc;
    }
  }

  /// Subdomains of `whois-servers.net` CNAME the appropriate WHOIS server.
  /// It's unclear who maintains these records or if they're exhaustive.
  static Future<Socket> _resolve(String extension) async {
    return await Socket.connect('$extension.whois-servers.net', 43);
  }

  /// Queries the appropriate WHOIS server using the `handle` and returns an
  /// instance of `Whois`. The `handle` should be a trimmed and normalized
  /// host name.
  static Future<Whois> query(String handle) async {
    final domain = _Domain.parse(handle);

    // Connect to and query the appropriate WHOIS server
    final client = await _connect(domain);
    final server = client.address.host;
    client.write('$domain\r\n');

    // Reduce the socket to a list of integers (code points)
    final buffer = <int>[];
    await for (final chunk in client) {
      buffer.addAll(chunk);
    }
    client.destroy();

    // Decode the buffer, trim the surrounding blank lines, remove the trailing
    // whitespace at the end of each line, and replace tabs with four spaces
    final response = (
      Utf8Decoder()
        .convert(buffer)
        .replaceAll(_surrounding, '')
        .replaceAll(_trailing, '')
        .replaceAll(_tabs, '    ')
    );

    return Whois._internal('$domain', server, response);
  }
}

class _Domain {
  static final _pattern = RegExp(r'^[-\w.]+$');
  final String name, extension;

  _Domain._internal(this.name, this.extension);

  /// Separates the `handle` into a `name` and `extension`. The `handle` should
  /// be a trimmed and normalized host name. Serious problems with the `handle`
  /// will be managed by the WHOIS client.
  static _Domain parse(String handle) {
    // Reject obvious pattern mismatches
    if (_pattern.hasMatch(handle)) {
      final parts = handle.split('.');

      // Attempt to separate the handle
      if (parts.length >= 2) {
        return _Domain._internal(parts.first, parts.sublist(1).join('.'));
      }
    }

    throw FormatException('Invalid domain format');
  }

  /// Returns the `name` and `extension` joined with a dot.
  String toString() {
    return '$name.$extension';
  }
}
