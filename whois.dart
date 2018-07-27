import 'dart:io';

void main(List<String> args) async {
  if(args.length == 1) {
    print(await WhoisClient.query(args[0]));
  }
}

class Domain {
  static final RegExp _url = RegExp(r'(?:\w+://)?(?:[\w.:-]+@)?([\w.-]+).*');

  String ext, name;

  String get host {
    return '$name.$ext';
  }

  Domain(String handle) {
    handle = handle.toLowerCase().trim();
    var pieces, matches = _url.allMatches(handle).toList();

    try {
      pieces = matches[0].group(1).split('.');
    } on RangeError catch(exc) {
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

class WhoisClient {
  // Throws OSError (no such host)
  static String query(String handle) async {
    var domain = Domain(handle);
    var server = '${domain.ext}.whois-servers.net';

    var client = await Socket.connect(server, 43);
    client.write('${domain.host}\r\n');

    var response = List<int>();
    await for(var chunk in client) {
      response.addAll(chunk);
    }
    client.destroy();
  
    return String.fromCharCodes(response).trimRight();
  }
}
