import 'dart:async';
import 'dart:io';

class Domain {
  static final RegExp _url = RegExp(r'(?:\w+://)?(?:[\w.:-]+@)?([\w.-]+).*');

  String ext, name;

  String get host {
    return '$name.$ext';
  }

  Domain(String handle) {
    var pieces, matches = _url.allMatches(handle).toList();

    try {
      pieces = matches[0].group(1).split('.');
    } on RangeError {
      throw FormatException('Invalid input format');
    }

    if(pieces.length >= 2) {
      ext = pieces.sublist(1).join('.');
      name = pieces[0];
    } else {
      throw FormatException('Invalid domain format');
    }
  }
}

class Whois {
  static final RegExp _trim = RegExp(r'^[\r\n]+|[\r\n]+$');

  final Domain domain;
  final String response;

  Whois(this.domain, this.response);

  static Future<Whois> query(String handle) async {
    var domain = Domain(handle);
    var server = '${domain.ext}.whois-servers.net';

    var client = await Socket.connect(server, 43);
    client.write('${domain.host}\r\n');

    var buffer = <int>[];
    await for(var chunk in client) {
      buffer.addAll(chunk);
    }
    client.destroy();

    var response = String.fromCharCodes(buffer);
    response = response.replaceAll(_trim, '');
    return Whois(domain, response);
  }
}
