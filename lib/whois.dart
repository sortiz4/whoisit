import 'dart:async';
import 'dart:convert';
import 'dart:io';

/// A simple WHOIS client supporting most (if not all) domain queries.
class Whois {
  static final _surrounding = RegExp(r'^[\r\n]+|[\r\n]+$');
  static final _trailing = RegExp(r'[\t ]+(?=[\r\n])');
  static final _tabs = RegExp(r'\t');
  final String domain;
  final String response;

  Whois._internal(this.domain, this.response);

  /// Tries to connect using the full domain extension. Failing that, the
  /// extension will iteratively generalize until the connection succeeds or
  /// all possibilities are exhausted.
  static Future<Socket> _connect(_Domain domain) async {
    var extension = domain.extension;
    try {
      return await _resolve(extension);
    } on SocketException catch(exc) {
      var parts = extension.split('.');
      for(var i in Iterable.generate(parts.length)) {
        if(i > 0) {
          try {
            return await _resolve(parts.sublist(i).join('.'));
          } on SocketException {}
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
    var domain = _Domain(handle);

    // Connect to and query the appropriate WHOIS server
    var client = await _connect(domain)
      ..write('$domain\r\n');

    // Reduce the socket to a list of integers (code points)
    var buffer = <int>[];
    await for(var chunk in client) {
      buffer.addAll(chunk);
    }
    client.destroy();

    // Decode the buffer, trim the surrounding blank lines, remove the trailing
    // whitespace at the end of each line, and replace tabs with four spaces
    var response = Utf8Decoder().convert(buffer)
      ..replaceAll(_surrounding, '')
      ..replaceAll(_trailing, '')
      ..replaceAll(_tabs, '    ');
    return Whois._internal('$domain', response);
  }
}

class _Domain {
  static final _pattern = RegExp(r'^[-\w.]+$');
  String name, extension;

  /// Separates the `handle` into a `name` and `extension`. The `handle` should
  /// be a trimmed and normalized host name. Serious problems with the `handle`
  /// will be managed by the WHOIS client.
  _Domain(String handle) {
    // Reject obvious pattern mismatches
    if(!_pattern.hasMatch(handle)) {
      throw FormatException('Invalid input format');
    }

    // Attempt to separate the handle
    var parts = handle.split('.');
    if(parts.length >= 2) {
      name = parts[0];
      extension = parts.sublist(1).join('.');
    } else {
      throw FormatException('Invalid domain format');
    }
  }

  /// Returns the `name` and `extension` joined with a dot.
  String toString() {
    return '$name.$extension';
  }
}
