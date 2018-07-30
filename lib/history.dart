import 'dart:collection';
import 'dart:core';
import 'dart:io';
import 'package:path/path.dart' as Path;
import 'package:path_provider/path_provider.dart';

class HistorySet extends IterableMixin<String> {
  Set<String> _history;
  File _file;

  HistorySet() {
    _history = Set();
    _open();
  }

  void _open() async {
    var directory = await getApplicationDocumentsDirectory();
    var location = Path.join(directory.path, 'history');
    try {
      _file = await File(location).create();
    } on FileSystemException {
      print('The history file could not be opened');
    }
    if(_file != null) {
      _read();
    }
  }

  void _read() async {
    var lines = await _file.readAsLines();
    lines.retainWhere((var line) => line.length > 0);
    _history.addAll(lines);
  }

  void _write() async {
    await _file.writeAsString(_history.join('\n'));
  }

  @override
  Iterator<String> get iterator {
    return _history.iterator;
  }

  @override
  int get length {
    return _history.length;
  }

  @override
  bool contains(Object value) {
    return _history.contains(value);
  }

  bool add(String value) {
    if(_history.contains(value)) {
      _history.remove(value);
    }
    _history.add(value);
    if(_file != null) {
      _write();
    }
    return true;
  }
}
