import 'dart:collection';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as Path;
import 'package:path_provider/path_provider.dart' as Provider;

/// An iterable data structure that maintains the user's search history. The
/// search history will persist across sessions through a history file that
/// will be read on construction and overwritten whenever a change occurs.
class History extends SetBase<String> {
  /// The name of the history file (the full path is determined at runtime).
  static final _name = 'history';

  /// The history set is implemented as an insertion order hash set.
  Set<String> _history = Set();

  /// The history file.
  File? _file;

  /// Locates an existing history file or creates a new one.
  static Future<File?> _getFile() async {
    try {
      // Compute the full path of the history file
      final directory = await Provider.getApplicationDocumentsDirectory();

      // Create the file (nondestructive)
      return await File(Path.join(directory.path, _name)).create();
    } on FileSystemException {
      return null;
    } on MissingPluginException {
      return null;
    }
  }

  /// Loads the history from storage.
  static Future<History> fromStorage() async {
    final file = await _getFile();
    final history = History();

    if (file != null) {
      // Load the history file into the history set
      history.addAll(await file.readAsLines());
      history._file = file;
    }

    return history;
  }

  /// Adds the `value` to the history set and updates the history file. If the
  /// history set already contains the `value`, it is removed and reinserted.
  @override
  bool add(String value) {
    // Update the history set to reflect the order of search queries
    if (_history.contains(value)) {
      _history.remove(value);
    }
    _history.add(value);

    // The history file must be completely overwritten with every change
    _file?.writeAsString(_history.join('\n'));

    // This method always changes the history set
    return true;
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
  void clear() {
    return _history.clear();
  }

  @override
  bool contains(Object? element) {
    return _history.contains(element);
  }

  @override
  String? lookup(Object? element) {
    return _history.lookup(element);
  }

  @override
  bool remove(Object? value) {
    return _history.remove(value);
  }

  @override
  Set<String> toSet() {
    return _history.toSet();
  }
}
