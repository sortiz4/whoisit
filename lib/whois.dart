import 'dart:async';
import 'dart:convert';
import 'dart:io';

/// A simple whois client supporting most (if not all) domain queries.
class Whois {
  static final _trim = RegExp(r'^[\r\n]+|[\r\n]+$');
  final String domain;
  final String response;

  Whois._internal(this.domain, this.response);

  /// Tries to connect using the full domain extension. Failing that, the
  /// top-level domain extension will be used in its place (if one exists).
  static Future<Socket> _connect(Domain domain) async {
    var extension = domain.extension;
    try {
      return await _resolve(extension);
    } on SocketException catch(exc) {
      var pieces = extension.split('.');
      if(pieces.length == 2) {
        return await _resolve(pieces[1]);
      } else {
        throw exc;
      }
    }
  }

  /// Subdomains of `whois-servers.net` CNAME the appropriate whois server.
  /// It's unclear who maintains these records or if they're exhaustive.
  static Future<Socket> _resolve(String extension) async {
    return await Socket.connect('$extension.whois-servers.net', 43);
  }

  /// Queries the appropriate whois server using the `handle` and returns an
  /// instance of `Whois`. The `handle` should be a trimmed and normalized
  /// host name.
  static Future<Whois> query(String handle) async {
    var domain = Domain(handle);

    // Connect to and query the appropriate whois server
    var client = await _connect(domain);
    client.write('$domain\r\n');

    // Reduce the socket to a list of integers (code points)
    var buffer = <int>[];
    await for(var chunk in client) {
      buffer.addAll(chunk);
    }
    client.destroy();

    // Decode the buffer and trim the surrounding line feeds
    var response = Utf8Decoder().convert(buffer);
    response = response.replaceAll(_trim, '');
    return Whois._internal('$domain', response);
  }
}

/// A simple domain parser and validator used by `Whois`.
class Domain {
  static final _pattern = RegExp(r'^[-\w.]+$');
  String name, extension;

  /// Separates the `handle` into a `name` and `extension` The `handle` should
  /// be a trimmed and normalized host name.
  Domain(String handle) {
    // Reject obvious pattern mismatches
    if(!_pattern.hasMatch(handle)) {
      throw FormatException('Invalid input format');
    }

    // Attempt to separate the handle
    var pieces = handle.split('.');
    if(pieces.length >= 2) {
      name = pieces[0];
      extension = pieces.sublist(1).join('.');
    } else {
      throw FormatException('Invalid domain format');
    }
  }

  /// Returns the `name` and `extension` joined with a dot.
  String toString() {
    return '$name.$extension';
  }
}
