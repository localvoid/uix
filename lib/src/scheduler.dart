// Copyright (c) 2015, the uix project authors. Please see the
// AUTHORS file for details. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// DOM Scheduler for write and read tasks.
///
/// The scheduler algorithm is quite simple and looks like this:
///
/// ```dart
/// while (writeTasks.isNotEmpty) {
///   while (writeTasks.isNotEmpty) {
///      writeTasks.removeFirst().start();
///      runMicrotasks();
///   }
///   while (readTasks.isNotEmpty) {
///     readTasks.removeFirst().start();
///     runMicrotasks();
///   }
/// }
/// while (afterTasks.isNotEmpty) {
///   afterTasks.removeFirst().start();
///   runMicrotasks();
/// }
/// ```
///
/// It will perform write and read tasks in batches until there are no
/// write or read tasks left.
///
/// Write tasks sorted by their priority, and the tasks with the lowest
/// value in the priority property is executed first. It is implemented
/// this way because most of the time tasks priority will be its depth in
/// the DOM.
///
/// Scheduler runs in its own `Zone` and intercepts all microtasks, this
/// way it is possible to use `Future`s to track dependencies between
/// tasks.
library uix.src.scheduler;

import 'dart:async';
import 'dart:collection';
import 'dart:html' as html;
import 'package:collection/priority_queue.dart';

/// Write groups sorted by priority.
///
/// It is used as an optimization to make adding write tasks as an O(1)
/// operation.
class _WriteGroup implements Comparable {
  final int priority;

  Completer _completer;

  _WriteGroup(this.priority);

  int compareTo(_WriteGroup other) {
    if (priority < other.priority) {
      return 1;
    } else if (priority > other.priority) {
      return -1;
    }
    return 0;
  }
}

/// Frame tasks.
class Frame {
  static const int lowestPriority = (1 << 31) - 1;

  /// Write groups indexed by priority
  List<_WriteGroup> _writeGroups = [];
  _WriteGroup _lowestPriorityWriteGroup;

  HeapPriorityQueue<_WriteGroup> _writeQueue =
      new HeapPriorityQueue<_WriteGroup>();

  Completer _readCompleter;
  Completer _afterCompleter;

  /// Returns `Future` that will be completed when [DOMScheduler] starts
  /// executing write tasks with this priority.
  Future write([int priority = lowestPriority]) {
    if (priority == lowestPriority) {
      if (_lowestPriorityWriteGroup == null) {
        _lowestPriorityWriteGroup = new _WriteGroup(lowestPriority);
        _lowestPriorityWriteGroup._completer = new Completer();
      }
      return _lowestPriorityWriteGroup._completer.future;
    }

    if (priority >= _writeGroups.length) {
      var i = _writeGroups.length;
      while (i <= priority) {
        _writeGroups.add(new _WriteGroup(i++));
      }
    }
    final g = _writeGroups[priority];
    if (g._completer == null) {
      g._completer = new Completer();
      _writeQueue.add(g);
    }
    return g._completer.future;
  }

  /// Returns `Future` that will be completed when [DOMScheduler] starts
  /// executing read tasks.
  Future read() {
    if (_readCompleter == null) {
      _readCompleter = new Completer();
    }
    return _readCompleter.future;
  }

  /// Returns `Future` that will be completed when [DOMScheduler] finishes
  /// executing all write and read tasks.
  Future after() {
    if (_afterCompleter == null) {
      _afterCompleter = new Completer();
    }
    return _afterCompleter.future;
  }
}

/// [Scheduler] for write and read tasks.
class Scheduler {
  // TODO: add (intrusive) lists for animation tasks
  bool _running = false;
  Queue<Function> _currentTasks = new Queue<Function>();

  ZoneSpecification _zoneSpec;
  Zone _zone;

  int _rafId = 0;
  Frame _currentFrame = new Frame();
  Frame _nextFrame = new Frame();

  Scheduler() {
    _zoneSpec = new ZoneSpecification(scheduleMicrotask: _scheduleMicrotask);
    _zone = Zone.current.fork(specification: _zoneSpec);
  }

  /// Scheduler [Zone]
  Zone get zone => _zone;

  /// [Frame] that contains tasks for the current animation frame
  Frame get currentFrame {
    assert(_running);
    return _currentFrame;
  }

  /// [Frame] that contains tasks for the next animation frame.
  Frame get nextFrame {
    _requestAnimationFrame();
    return _nextFrame;
  }

  void _scheduleMicrotask(Zone self, ZoneDelegate parent, Zone zone, void f()) {
    if (_running) {
      _currentTasks.add(f);
    } else {
      parent.scheduleMicrotask(zone, f);
    }
  }

  void _runTasks() {
    while (_currentTasks.isNotEmpty) {
      _currentTasks.removeFirst()();
    }
  }

  void _requestAnimationFrame() {
    if (_rafId == 0) {
      _rafId = html.window.requestAnimationFrame(_handleAnimationFrame);
    }
  }

  void _handleAnimationFrame(num t) {
    _rafId = 0;

    _zone.run(() {
      _running = true;
      final tmp = _currentFrame;
      _currentFrame = _nextFrame;
      _nextFrame = tmp;
      final wq = _currentFrame._writeQueue;

      // TODO: refactor!
      do {
        while (wq.isNotEmpty) {
          final writeGroup = wq.removeFirst();
          writeGroup._completer.complete();
          _runTasks();
          writeGroup._completer = null;
        }
        if (_currentFrame._lowestPriorityWriteGroup != null) {
          _currentFrame._lowestPriorityWriteGroup._completer.complete();
          _runTasks();
          _currentFrame._lowestPriorityWriteGroup = null;
        }

        if (_currentFrame._readCompleter != null) {
          _currentFrame._readCompleter.complete();
          _runTasks();
          _currentFrame._readCompleter = null;
        }
      } while (wq.isNotEmpty || _currentFrame._lowestPriorityWriteGroup != null);

      if (_currentFrame._afterCompleter != null) {
        _currentFrame._afterCompleter.complete();
        _runTasks();
        _currentFrame._afterCompleter = null;
      }
      _running = false;
    });

  }

  /// Force [DOMScheduler] to run tasks for the [nextFrame].
  void forceNextFrame() {
    if (_rafId != 0) {
      html.window.cancelAnimationFrame(_rafId);
      _rafId = 0;
      _handleAnimationFrame(html.window.performance.now());
    }
  }
}
