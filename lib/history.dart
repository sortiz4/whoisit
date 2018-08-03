import 'dart:collection';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as Path;
import 'package:path_provider/path_provider.dart' as Provider;

/// An iterable data structure that maintains the user's search history. The
/// search history will persist across sessions through a history file that
/// will be read on construction and overwritten whenever a change occurs
/// (asynchronously). There is a very small window where an instance may be
/// modified before the history file has been read which will affect the order
/// of the search queries. In the unlikely event that the history file cannot
/// be accessed, the search history will continue to work but will not persist
/// across sessions. In the interest of consistency and performance, only one
/// instance of this data structure should exist at any given time.
class History extends SetBase<String> {
  /// The name of the history file (the full path is determined at runtime).
  static final _name = 'history';

  /// The history set is implemented as an insertion order hash set.
  Set<String> _history = Set();

  /// The full path of the history file is asynchronously set.
  File _file;

  /// Schedules an asynchronous task to load the history file.
  History() {
    () async {
      // Compute the full path of the history file
      var directory, location;
      try {
        directory = await Provider.getApplicationDocumentsDirectory();
        location = Path.join(directory?.path, _name);
      } on MissingPluginException {
        return;
      }

      try {
        // Create the file (nondestructive)
        _file = await File(location).create();
      } on FileSystemException {
        print('The history file could not be accessed');
      }

      if(_file != null) {
        // Load the history file into the history set
        _history.addAll(await _file.readAsLines());
      }
    }();
  }

  /// Adds the `value` to the history set and updates the history file. If the
  /// history set already contains the `value`, it is removed and reinserted.
  @override
  bool add(String value) {
    // Update the history set to reflect the order of search queries
    if(_history.contains(value)) {
      _history.remove(value);
    }
    _history.add(value);

    // The history file must be completely overwritten with every change
    if(_file != null) {
      _file.writeAsString(_history.join('\n'));
    }

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
  bool contains(Object element) {
    return _history.contains(element);
  }
  @override
  String lookup(Object element) {
    return _history.lookup(element);
  }
  @override
  bool remove(Object value) {
    return _history.remove(value);
  }
  @override
  Set<String> toSet() {
    return _history.toSet();
  }
}
