// Copyright (c) 2015, the uix project authors. Please see the
// AUTHORS file for details. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// Scheduler
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
import 'dart:html' as html;
import 'package:collection/priority_queue.dart';
import 'component.dart';

class _TaskEntry {
  final Function fn;
  _TaskEntry _next;

  _TaskEntry(this.fn);
}

class _TaskQueue {
  _TaskEntry _first;
  _TaskEntry _last;

  void add(Function fn) {
    final e = new _TaskEntry(fn);
    if (_last == null) {
      _first = e;
    } else {
      _last._next = e;
    }
    _last = e;
  }

  void run() {
    while (_first != null) {
      _first.fn();
      _first = _first._next;
    }
    _last = null;
  }
}

/// Write groups sorted by priority.
///
/// It is used as an optimization to make adding write tasks as an O(1)
/// operation.
class _WriteGroup implements Comparable {
  final int priority;

  Completer _completer;

  _WriteGroup(this.priority);

  int compareTo(_WriteGroup other) => priority.compareTo(other.priority);
}

/// Frame tasks.
class Frame {
  static const int lowestPriority = (1 << 31) - 1;

  /// Write groups indexed by priority
  List<_WriteGroup> _prioWriteGroups = [];
  _WriteGroup _writeGroup;

  final HeapPriorityQueue<_WriteGroup> _writeQueue = new HeapPriorityQueue<_WriteGroup>();

  Completer _readCompleter;
  Completer _afterCompleter;

  /// Returns `Future` that will be completed when [Scheduler] starts
  /// executing write tasks with this priority.
  Future write([int priority = lowestPriority]) {
    if (priority == lowestPriority) {
      if (_writeGroup == null) {
        _writeGroup = new _WriteGroup(lowestPriority);
        _writeGroup._completer = new Completer();
      }
      return _writeGroup._completer.future;
    }

    if (priority >= _prioWriteGroups.length) {
      var i = _prioWriteGroups.length;
      while (i <= priority) {
        _prioWriteGroups.add(new _WriteGroup(i++));
      }
    }

    final g = _prioWriteGroups[priority];
    if (g._completer == null) {
      g._completer = new Completer();
      _writeQueue.add(g);
    }

    return g._completer.future;
  }

  /// Returns `Future` that will be completed when [Scheduler] starts
  /// executing read tasks.
  Future read() {
    if (_readCompleter == null) {
      _readCompleter = new Completer();
    }
    return _readCompleter.future;
  }

  /// Returns `Future` that will be completed when [Scheduler] finishes
  /// executing all write and read tasks.
  Future after() {
    if (_afterCompleter == null) {
      _afterCompleter = new Completer();
    }
    return _afterCompleter.future;
  }
}

/// Scheduler.
class Scheduler {
  static const int tickRunningFlag = 1;
  static const int frameRunningFlag = 1 << 1;
  static const int tickPendingFlag = 1 << 2;
  static const int framePendingFlag = 1 << 3;
  static const int runningFlags = tickRunningFlag | frameRunningFlag;

  int flags = 0;

  /// Monotonically increasing internal clock.
  int clock = 1;

  /// High Resolution timestamp measured in milliseconds, accurate to one
  /// thousandth of a millisecond.
  num time = -1;

  bool get isRunning => ((flags & runningFlags) != 0);
  bool get isFrameRunning => ((flags & frameRunningFlag) != 0);

  final _TaskQueue _currentTasks = new _TaskQueue();

  final CNode rootCNode = new CNode(null);

  Zone _outerZone;
  Zone _innerZone;

  Zone get outerZone => _outerZone;
  Zone get zone => _innerZone;

  Completer _nextTickCompleter;

  StreamController _onNextFrameController;
  Stream get onNextFrame => _onNextFrameController.stream;

  Frame _currentFrame = new Frame();
  Frame _nextFrame = new Frame();

  /// [Future] that will be completed on the next tick.
  Future get nextTick {
    if (_nextTickCompleter == null) {
      _nextTickCompleter = new Completer();
      _requestNextTick();
    }
    return _nextTickCompleter.future;
  }

  /// [Frame] that contains tasks for the current animation frame.
  Frame get currentFrame {
    assert(isFrameRunning);
    return _currentFrame;
  }

  /// [Frame] that contains tasks for the next animation frame.
  Frame get nextFrame {
    _requestAnimationFrame();
    return _nextFrame;
  }

  Scheduler() {
    _onNextFrameController = new StreamController.broadcast(onListen: () {
      _requestAnimationFrame();
    });

    _outerZone = Zone.current;
    _innerZone = Zone.current.fork(
        specification: new ZoneSpecification(
            scheduleMicrotask: _scheduleMicrotask,
            run: _run,
            runUnary: _runUnary,
            runBinary: _runBinary
        )
    );
  }

  /// Force Scheduler to run tasks for the [nextFrame].
  void forceNextFrame() {
    if ((flags & framePendingFlag) != 0) {
      _handleAnimationFrame(html.window.performance.now());
    }
  }

  /// Force Scheduler to run tasks for the next tick.
  void forceNextTick() {
    if ((flags & tickPendingFlag) != 0) {
      _handleNextTick();
    }
  }

  void run(fn) {
    time = html.window.performance.now();

    _innerZone.run(() {
      flags |= tickRunningFlag;

      fn();

      clock++;
      flags &= ~tickRunningFlag;
    });
  }

  void _requestAnimationFrame() {
    if ((flags & framePendingFlag) == 0) {
      html.window.requestAnimationFrame(_handleAnimationFrame);
      flags |= framePendingFlag;
    }
  }

  void _requestNextTick() {
    if ((flags & tickPendingFlag) == 0) {
      Zone.ROOT.scheduleMicrotask(_handleNextTick);
      flags |= tickPendingFlag;
    }
  }

  void _handleAnimationFrame(num t) {
    if ((flags & framePendingFlag) == 0) {
      return;
    }
    time = t;

    _innerZone.run(() {
      flags &= ~framePendingFlag;
      flags |= frameRunningFlag;

      _onNextFrameController.add(null);
      _currentTasks.run();
      if (_onNextFrameController.hasListener) {
        _requestAnimationFrame();
      }

      rootCNode.update();

      final tmp = _currentFrame;
      _currentFrame = _nextFrame;
      _nextFrame = tmp;
      final wq = _currentFrame._writeQueue;

      do {
        do {
          while (wq.isNotEmpty) {
            final writeGroup = wq.removeFirst();
            writeGroup._completer.complete();
            writeGroup._completer = null;
            _currentTasks.run();
          }
          while (_currentFrame._writeGroup != null) {
            _currentFrame._writeGroup._completer.complete();
            _currentFrame._writeGroup = null;
            _currentTasks.run();
          }
        } while (wq.isNotEmpty);

        while (_currentFrame._readCompleter != null) {
          _currentFrame._readCompleter.complete();
          _currentFrame._readCompleter = null;
          _currentTasks.run();
        }
      } while (wq.isNotEmpty || (_currentFrame._writeGroup != null));

      if (_currentFrame._afterCompleter != null) {
        _currentFrame._afterCompleter.complete();
        _currentFrame._afterCompleter = null;
        _currentTasks.run();
      }

      clock++;
      flags &= ~frameRunningFlag;
    });
  }

  void _handleNextTick() {
    if ((flags & tickPendingFlag) == 0) {
      return;
    }

    time = html.window.performance.now();

    _innerZone.run(() {
      flags &= ~tickPendingFlag;
      flags |= tickRunningFlag;

      _nextTickCompleter.complete();
      _nextTickCompleter = null;
      _currentTasks.run();

      clock++;
      flags &= ~tickRunningFlag;
    });
  }

  dynamic _run(Zone self, ZoneDelegate parent, Zone zone, fn()) {
    if (!isFrameRunning) {
      _requestAnimationFrame();
    }
    return parent.run(zone, fn);
  }

  dynamic _runUnary(Zone self, ZoneDelegate parent, Zone zone, fn(arg), arg) =>
    _run(self, parent, zone, () => fn(arg));

  dynamic _runBinary(Zone self, ZoneDelegate parent, Zone zone, fn(arg1, arg2), arg1, arg2) =>
    _run(self, parent, zone, () => fn(arg1, arg2));

  void _scheduleMicrotask(Zone self, ZoneDelegate parent, Zone zone, fn) {
    if (isRunning) {
      _currentTasks.add(fn);
    } else {
      parent.scheduleMicrotask(zone, fn);
    }
  }
}
