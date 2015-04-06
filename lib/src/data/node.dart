// Copyright (c) 2015, the uix project authors. Please see the AUTHORS file for
// details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library uix.src.data.node;

import 'dart:async';
import '../env.dart';

/// Revisioned nodes are used for fast *dirty checking* of mutable
/// nodes.
abstract class RevisionedNode {
  int _revision = 0;

  /// Current revision.
  int get revision => _revision;

  /// Update revision.
  void updateRevision() { _revision = scheduler.clock; }

  /// Check if this node has newer revision than [other] node.
  bool isNewer(RevisionedNode other) => _revision > other._revision;
}

abstract class StreamListenerNode {
  List<StreamSubscription> _subscriptions;
  List<StreamSubscription> _transientSubscriptions;

  /// Add subscription that should be automatically canceled when
  /// this node is disposed.
  void addSubscription(StreamSubscription s) {
    if (_subscriptions == null) {
      _subscriptions = <StreamSubscription>[];
    }
    _subscriptions.add(s);
  }

  /// Cancel all subscriptions.
  void cancelSubscriptions() {
    if (_subscriptions != null) {
      for (var i = 0; i < _subscriptions.length; i++) {
        _subscriptions[i].cancel();
      }
      _subscriptions = null;
    }
  }

  /// Add transient subscription that should be automatically canceled
  /// when this node is invalidated.
  void addTransientSubscription(StreamSubscription s) {
    if (_transientSubscriptions == null) {
      _transientSubscriptions = <StreamSubscription>[];
    }
    _transientSubscriptions.add(s);
  }

  /// Cancel all transient subscriptions.
  void cancelTransientSubscriptions() {
    if (_transientSubscriptions != null) {
      for (var i = 0; i < _transientSubscriptions.length; i++) {
        _transientSubscriptions[i].cancel();
      }
      _transientSubscriptions = null;
    }
  }
}
